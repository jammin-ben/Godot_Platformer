tool
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Shape2D) var collision_shape setget set_collision_shape

# Called when the node enters the scene tree for the first time.
func _ready():
	if collision_shape:
		set_collision_shape(collision_shape)

func set_collision_shape(shape: Shape2D):
	$CollisionShape2D.shape = shape
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
