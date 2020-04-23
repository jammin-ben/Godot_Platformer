extends Node2D

onready var ray = $RayCast2D

var offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#tick one degree
	offset += 2*PI/360
	ray.cast_to=Vector2(cos(offset),sin(offset))*10
	
	if(ray.cast_to.x!=0):
		print(180/PI*atan(ray.cast_to.y/ray.cast_to.x))
	