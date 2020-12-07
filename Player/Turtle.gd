extends KinematicBody2D

class_name Turtle


# These are here to make it so you can tweak
# these while debugging. When it comes time
# to release the game these should be
# irrelevant
export var ball_mode = false
export var wall_jump = false
export var flutter_jump = false

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED_DEFAULT = 30
const MAX_SPEED_BOOSTED = 90
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 6
const JUMP_FORCE = 220
const SKY_SPEED = 35
const MAX_FLUTTER_GAS = 1.2 #seconds of flutter
const FLUTTER_POWER = -1.5 #like the opposite of gravity
const FALLING_THRESHOLD = 30 #how fast you have to be falling to start flutter
const WALL_SLIDE_SPEED = 40

enum {ST_ONGROUND, ST_FLUTTER, ST_FALLING, ST_AIRBORN, ST_ONLEFTWALL, ST_ONRIGHTWALL}
var state = ST_FALLING setget set_state

var max_speed = MAX_SPEED_DEFAULT

#flutter conditions
var flutterGas = MAX_FLUTTER_GAS
var flutterAccel = 0 # value between 0 and 1 for speed boost interpolation

var motion = Vector2.ZERO

signal Hidden()
signal Emerged()
signal signal_debug_st_changed(state)
signal signal_consumed_powerup_flutter_jump()


onready var sprite = $Sprite

onready var animationPlayer = $AnimationPlayer

#onready var rray = $RayCastRight
#onready var lray = $RayCastLeft
onready var hitbox = $Hitbox/CollisionShape2D
#onready var hitboxpivot = $HitboxPivot

var hidden = false;




var has_powerup = {
	ball_mode = false,
	flutter_jump = false,
	wall_jump = false
}

var level_powerups = []

func _ready() -> void:
	has_powerup.ball_mode = ball_mode
	has_powerup.flutter_jump = flutter_jump
	has_powerup.wall_jump = wall_jump
	level_powerups = get_tree().get_nodes_in_group(Globals.POWERUP_GROUP)
	for powerup in level_powerups:
		powerup.connect("powerup", self, "_conn_on_powerup_consumed")

func set_state(value):
	emit_signal("signal_debug_st_changed",value)
	if value == ST_AIRBORN or value == ST_FALLING or value == ST_FLUTTER:
		$Sprite.rotation_degrees = 0
		$Sprite.offset.y=0
		
	if value == ST_ONLEFTWALL:
		$Sprite.rotation_degrees = 90 
		$Sprite.offset.y=-5
		animationPlayer.play("Wallslide")
	if value == ST_ONRIGHTWALL:
		$Sprite.rotation_degrees = 270 
		$Sprite.offset.y=-5
		animationPlayer.play("Wallslide")
		
	if value == ST_ONGROUND:
		$Sprite.rotation_degrees=0
		$Sprite.offset.y=0
		flutterGas = MAX_FLUTTER_GAS
		flutterAccel = 0 
		#max_speed = MAX_SPEED_DEFAULT
	state = value

func get_sprite():
	return $Sprite

func check_for_ground():
	if $DownLeft.is_colliding() or $DownRight.is_colliding():
		set_state(ST_ONGROUND)
	
	elif ($LeftDown.is_colliding() or $LeftUp.is_colliding()) and has_powerup.wall_jump:
		set_state(ST_ONLEFTWALL)
	
	elif ($RightDown.is_colliding() or $RightUp.is_colliding()) and has_powerup.wall_jump:
		set_state(ST_ONRIGHTWALL)
	
	elif state==ST_ONGROUND or state==ST_ONLEFTWALL or state==ST_ONRIGHTWALL:
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
	elif x_input != 0 and !Input.is_action_pressed('player_down'):

		animationPlayer.play("Move")
		
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		
	#elif x_input == 0 and !hidden and state==ST_ONGROUND:
	elif x_input == 0 and state==ST_ONGROUND:
		if animationPlayer.current_animation == "Move":
			animationPlayer.play("Stand")
	
	if sprite.flip_h:
		$Hitbox.position.x = -12
	else:
		$Hitbox.position.x = 12
		
	check_for_ground()
	if state == ST_ONGROUND:
		motion.x = lerp(motion.x, 0, FRICTION * delta)
		motion.y = 0
		max_speed = lerp(max_speed,MAX_SPEED_DEFAULT,.1)
		
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
			#secondJump = true
			#cut speed in half when let go of jump
			if motion.y < -JUMP_FORCE / 2.0:
				motion.y = -JUMP_FORCE / 2.0
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		
	if state==ST_AIRBORN:
		if motion.y > FALLING_THRESHOLD:
			set_state(ST_FALLING)

	elif state==ST_FALLING:
		if Input.is_action_pressed("player_up") and flutterGas > 0 and has_powerup.flutter_jump:
			set_state(ST_FLUTTER)
		if motion.y < FALLING_THRESHOLD:
			set_state(ST_AIRBORN)
			
	elif state==ST_FLUTTER:
		if x_input !=0:
			flutterAccel += delta / MAX_FLUTTER_GAS
		
		#taking max so this doesn't slow us down in the case of a walljump
		max_speed = max(MAX_SPEED_DEFAULT + ease(flutterAccel, 2.0)*MAX_SPEED_BOOSTED,max_speed)
		
		motion.y += FLUTTER_POWER * delta * TARGET_FPS
		flutterGas -= delta 
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
		if flutterGas < 0 or Input.is_action_just_released("player_up"):
			if motion.y > FALLING_THRESHOLD:
				set_state(ST_FALLING)
			else:
				set_state(ST_AIRBORN)
	elif state==ST_ONLEFTWALL or state == ST_ONRIGHTWALL:
		motion.y += GRAVITY * delta * TARGET_FPS 
		motion.y = min(motion.y,WALL_SLIDE_SPEED)
		if(Input.is_action_just_pressed("player_up")):
			max_speed = MAX_SPEED_BOOSTED
			motion.x=-JUMP_FORCE/sqrt(2)
			motion.y=-JUMP_FORCE/sqrt(2)
			if state==ST_ONLEFTWALL:
				motion.x*=-1
	
	motion.x = clamp(motion.x, -max_speed, max_speed)
	if(motion.x!=0):
		sprite.flip_h = motion.x < 0
	
	motion = move_and_slide(motion, Vector2.UP)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name == 'Hide'):
		emit_signal("Hidden")
		hidden = true;
	if (anim_name == 'Emerge'):
		emit_signal("Emerged")
		hidden = false;


func _conn_on_powerup_consumed(powerup_name: String, _powerup: Powerup):
	match(powerup_name):
		Globals.POWERUP_BALL_MODE:
			has_powerup.ball_mode = true
		Globals.POWERUP_FLUTTER_JUMP:
			has_powerup.flutter_jump = true
			emit_signal("signal_consumed_powerup_flutter_jump")
		Globals.POWERUP_WALL_JUMP:
			has_powerup.wall_jump = true
