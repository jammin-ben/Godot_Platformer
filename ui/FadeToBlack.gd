extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal fade_finished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fade():
	$AnimationPlayer.play("FadeToBlack")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "FadeToBlack":
		emit_signal("fade_finished")
	pass # Replace with function body.
