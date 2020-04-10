extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 30
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 6
const JUMP_FORCE = 220
const SKY_SPEED = 35

var motion = Vector2.ZERO

onready var sprite = $Turtle_Spr
onready var animationPlayer = $AnimationPlayer
onready var clouds = $ParallaxBackground/Cloud_Layer
onready var sky = $ParallaxBackground/Sky_Layer
onready var sunset = $ParallaxBackground/Sky_Layer/Sunrise
onready var rray = $RayCastRight
onready var lray = $RayCastLeft

func _process(delta):
	clouds.motion_offset.x += 2*delta
	#sky.motion_offset.y -= SKY_SPEED*delta
	#if(sky.motion_offset.y < -600):
	#	pass
#		sunset.offset.y+=SKY_SPEED*delta
	#if(sky.motion_offset.y < -675):
	#	sky.motion_offset.y=0
#		sunset.offset.y=0
func is_on_ground():
	return lray.is_colliding() or rray.is_colliding()
	
func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Move")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		if(animationPlayer.current_animation=="Move"):
			animationPlayer.play("Stand")
	
	if is_on_ground():
		if x_input == 0:
			if(Input.is_action_just_pressed("ui_down")):
				motion.x=0
				animationPlayer.play("Hide")
			elif(Input.is_action_just_released("ui_down")):
				
				animationPlayer.play("Emerge")
			else:
				motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		motion.y += GRAVITY * delta * TARGET_FPS
		animationPlayer.play("Jump")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion, Vector2.UP)