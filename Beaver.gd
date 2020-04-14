extends KinematicBody2D

const SPEED = 100

var dir = 1
var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var rray = $rray
onready var lray = $lray

onready var raycast = rray


var being_eaten = false


onready var particle = $Particles2D

func stand():
	animationPlayer.play("Stand")
	dir=0

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
		
func _ready():
	run()

func _physics_process(delta):
	
	if(being_eaten):
		particle.emitting = true 
	else:
		particle.emitting = false
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






func _on_Area2D_area_entered(area):
	being_eaten=true

func _on_Area2D_area_exited(area):
	being_eaten=false
	