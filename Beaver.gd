extends KinematicBody2D

const SPEED = 100

var dir = 1
var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rray = $rray
onready var lray = $lray

onready var raycast = rray

func stand():
	animationPlayer.play("Stand")
	dir=0

func run():
	dir = floor(randf()*2)
	if(dir == 0):
		if(!lray.is_colliding()):
			dir = 1
	elif(dir ==1):
		if(!rray.is_colliding()):
			dir = -1
	animationPlayer.play("Run")
	if (dir == 1):
		raycast = rray
	else:
		raycast = lray
		
func _ready():
	run()

func _physics_process(delta):
	if(abs(dir)>0):
		motion.x = SPEED * dir
		sprite.flip_h = (dir <0)
		motion = move_and_slide(motion, Vector2.UP)
		if(!raycast.is_colliding() or randf() < .02):
			stand()
	else:
		#standing
		if(randf()<.01):
			run()
			
	