extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state_machine

# Called when the node enters the scene tree for the first time.
func _ready():
	if(get_tree().get_root().get_node("Node2D/CompositTurtle/TurtleBall").connect("body_shape_entered",self,"_on_turtleball_body_shape_entered")!=0):
		print("error connecting trampoline to turtleball")
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("idle")
func _on_turtleball_body_shape_entered(_body_id,body,_body_shape,_local_shape):
	if(body == $StaticBody2D):
		state_machine.travel("spring")
