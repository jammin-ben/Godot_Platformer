extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_area_entered(_area: Area2D) -> void:
	pass
	#if area.get_parent().get_parent() is CompositeTurtle:
	#	$FadeToBlack.fade()


func _on_FadeToBlack_fade_finished() -> void:
	$"win-text".visible = true
	pass # Replace with function body.
