extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String

const POWERUP_BALL_MODE = "ball-mode"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass