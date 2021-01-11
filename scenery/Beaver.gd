extends KinematicBody2D

export var speed = 100

var dir = 1
var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rray = $rray
onready var lray = $lray

onready var raycast = rray

export var time_chunk = .6
export var max_run_chunks = 4
export var max_wait_chunks = 8

func stand():
	animationPlayer.play("Stand")
	dir=0
	$Timer.start(ceil(randf()*max_wait_chunks)*time_chunk)

func run():
	dir = floor(randf()*2) 
	if(dir == 0):
		dir = -1
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
	$Timer.start(ceil(randf()*max_run_chunks)*time_chunk)
func _ready():
	run()

func _physics_process(delta):
	if(abs(dir)>0):
		motion.x = speed * dir * delta * 60
		sprite.flip_h = (dir < 0)
		motion = move_and_slide(motion, Vector2.UP)
		if(!raycast.is_colliding()): #or randf() < .02):
			stand()
	#else:
		#standing
	#	if(randf()<.01):
	#		run()
			
	
func _on_Timer_timeout():
	if(dir == 0):
		run()
	else:
		stand()
