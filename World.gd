extends Node2D

var butterfly


func _ready():
	butterfly=load("res://Butterfly.tscn")
	for i in range(50):
		var butterfly_instance=butterfly.instance()
		get_tree().root.call_deferred("add_child",butterfly_instance)
		butterfly_instance.position=Vector2(randf()*get_viewport().size[0],randf()*get_viewport().size[1])