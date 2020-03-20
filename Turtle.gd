extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 30
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 6
const JUMP_FORCE = 220

var motion = Vector2.ZERO

onready var sprite = $Turtle_Spr
onready var animationPlayer = $AnimationPlayer

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
	
	if is_on_floor():
		#print("floor")
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