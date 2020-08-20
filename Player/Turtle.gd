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
const FALLING_THRESHOLD = 60 #how fast you have to be falling to start flutter
enum {ST_ONGROUND, ST_FLUTTER, ST_FALLING, ST_AIRBORN}
var state = ST_FALLING setget set_state


#flutter conditions
var secondJump:bool = false
var descending:bool = false
var flutterGas = MAX_FLUTTER_GAS

var motion = Vector2.ZERO

signal Hidden()
signal Emerged()
signal signal_debug_st_changed(state)
onready var sprite = $Turtle_Spr
onready var animationPlayer = $AnimationPlayer

onready var rray = $RayCastRight
onready var lray = $RayCastLeft
onready var hitbox = $HitboxPivot/Hitbox/CollisionShape2D
onready var hitboxpivot = $HitboxPivot

var hidden = false;

func set_state(value):
	emit_signal("signal_debug_st_changed",value)
	if value == ST_ONGROUND:
		secondJump = false
		descending = false
		flutterGas = MAX_FLUTTER_GAS
	state = value

func check_for_ground():
	if lray.is_colliding() or rray.is_colliding():
		set_state(ST_ONGROUND)
	elif state==ST_ONGROUND:
		set_state(ST_AIRBORN)

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
		
	elif x_input == 0 and !hidden and state==ST_ONGROUND:
		if animationPlayer.current_animation == "Move":
			animationPlayer.play("Stand")
	
	if sprite.flip_h:
		# jank city
		hitboxpivot.transform=Transform2D(Vector2(1,0),Vector2(0,1),Vector2(-12,-5))
	else:
		hitboxpivot.transform=Transform2D(Vector2(1,0),Vector2(0,1),Vector2(12,-5))
	
	check_for_ground()
	if state == ST_ONGROUND:
		motion.x = lerp(motion.x, 0, FRICTION * delta)
		motion.y = 0
		
		if Input.is_action_pressed("eat"):
			animationPlayer.play('Eat')
			hitbox.disabled = false
		else:
			hitbox.disabled = true
		
		if Input.is_action_just_pressed("player_up"):
			motion.y = -JUMP_FORCE
			set_state(ST_AIRBORN)
	
	#not sure if this is poor practice for a FSM
	elif state == ST_FALLING or state == ST_AIRBORN:
		motion.y += GRAVITY * delta * TARGET_FPS
		if Input.is_action_just_released("player_up"): 
			secondJump = true
			#cut speed in half when let go of jump
			if motion.y < -JUMP_FORCE / 2.0:
				motion.y = -JUMP_FORCE / 2.0
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		
	if state==ST_AIRBORN:
		if motion.y > FALLING_THRESHOLD:
			set_state(ST_FALLING)

	elif state==ST_FALLING:
		if secondJump and  Input.is_action_pressed("player_up") and flutterGas > 0:
			set_state(ST_FLUTTER)
		if motion.y < FALLING_THRESHOLD:
			set_state(ST_AIRBORN)
	elif state==ST_FLUTTER:
		motion.y += FLUTTER_POWER * delta * TARGET_FPS
		flutterGas -= delta 
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		if flutterGas < 0 or Input.is_action_just_released("player_up"):
			if motion.y > FALLING_THRESHOLD:
				set_state(ST_FALLING)
			else:
				set_state(ST_AIRBORN)
	motion = move_and_slide(motion, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == 'Hide'):
		emit_signal("Hidden")
		hidden = true;
	if (anim_name == 'Emerge'):
		emit_signal("Emerged")
		hidden = false;


func _on_Turt_Kinem_signal_debug_st_changed(state):
	pass # Replace with function body.
