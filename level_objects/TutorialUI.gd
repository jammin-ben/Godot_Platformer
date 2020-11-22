extends MarginContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var timeout_seconds=5
export var fade_time_seconds=1
export(NodePath) var powerup_trigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = timeout_seconds
	$Timer.start()
	$Tween.interpolate_property(
		$Control/TextureRect,
		"modulate:a",
		1,
		0,
		fade_time_seconds,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		1
		)


func _conn_on_timer_timeout() -> void:
	$Tween.start()
