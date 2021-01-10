extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_ybounds_body_exited(body):
	body.vel.y*=-1
	

func _on_xbounds_body_exited(body):
	body.vel.x*=-1
