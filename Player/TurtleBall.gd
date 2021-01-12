extends RigidBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_sprite():
	return $Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TurtleBall_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	print(body)
