extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 30
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 6
const JUMP_FORCE = 220
const SKY_SPEED = 35
const MAX_FLUTTER_GAS = 1.2 #seconds of flutter
const FLUTTER_POWER = -1.5 #like the opposite of gravity
const FLUTTER_DESCENT_THRESHOLD = 60 #how fast you have to be falling to start flutter

#flutter conditions
var secondJump:bool = false
var descending:bool = false
var flutterGas = MAX_FLUTTER_GAS

var motion = Vector2.ZERO

signal Hidden()
signal Emerged()
onready var sprite = $Turtle_Spr
onready var animationPlayer = $AnimationPlayer

onready var rray = $RayCastRight
onready var lray = $RayCastLeft
onready var hitbox = $HitboxPivot/Hitbox/CollisionShape2D
onready var hitboxpivot = $HitboxPivot

var hidden = false;

func is_on_ground():
	var onground = lray.is_colliding() or rray.is_colliding()
	if onground:
		secondJump = false
		descending = false
		flutterGas = MAX_FLUTTER_GAS
	return onground


func _physics_process(delta):
	var x_input = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")

	if Input.is_action_pressed("player_down") :
		# motion.x=0
		if !hidden:
			animationPlayer.play("Hide")
	elif(Input.is_action_just_released("player_down")):
		animationPlayer.play("Emerge")
	
	# if x_input is not 0, then that means that there IS some input, therefor we'll do this stuff
	# what I want though, if all of this is true, but also down isn't being pressed
	elif x_input != 0 and !hidden: #and !Input.is_action_pressed('player_down'):

		# vvvvvvvvv
		animationPlayer.play("Move")
		# ^^^^^^^
		
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
		
	elif x_input == 0 and !hidden and is_on_ground():
		if animationPlayer.current_animation == "Move":
			animationPlayer.play("Stand")
	
	if sprite.flip_h:
		# jank city
		hitboxpivot.transform=Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-12,-5))
	else:
		hitboxpivot.transform=Transform2D(Vector2(1,0),Vector2(0,1),Vector2(12,-5))
	
	if is_on_ground():
		motion.x = lerp(motion.x, 0, FRICTION * delta)
#		if x_input == 0:
#			if(Input.is_action_just_pressed("player_down")):
#				motion.x=0
#				animationPlayer.play("Hide")
#			elif(Input.is_action_just_released("player_down")):
#
#				animationPlayer.play("Emerge")
#			else:

			
		if Input.is_action_pressed("eat"):
			animationPlayer.play('Eat')
			hitbox.disabled = false
		else:
			hitbox.disabled = true
			
		if Input.is_action_just_pressed("player_up"):
			motion.y = -JUMP_FORCE
		
	else:  #IN AIR
		if motion.y > FLUTTER_DESCENT_THRESHOLD:
			descending = true
		
		#flutter
		if descending and secondJump and  Input.is_action_pressed("player_up") and flutterGas > 0:
			motion.y += FLUTTER_POWER * delta * TARGET_FPS
			flutterGas -= delta 
			motion.x 
		#get pulled down by gravity
		else:
			motion.y += GRAVITY * delta * TARGET_FPS
#		animationPlayer.play("Jump")
		
		if Input.is_action_just_released("player_up"): 
			secondJump = true
			#cut speed in half when let go of jump
			if motion.y < -JUMP_FORCE / 2.0:
				motion.y = -JUMP_FORCE / 2.0
		
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == 'Hide'):
		emit_signal("Hidden")
		hidden = true;
	if (anim_name == 'Emerge'):
		emit_signal("Emerged")
		hidden = false;
