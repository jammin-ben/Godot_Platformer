extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var timeout_seconds=5
export var fade_time_seconds=1
export(NodePath) var powerup_trigger = "."
export(Texture) var texture = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (texture):
		$MarginContainer/Control/TextureRect.texture = texture
	var powerup = get_node(powerup_trigger)
	if (powerup is Powerup):
		powerup.connect("powerup", self, "_conn_on_powerup_consumed")
	else:
		printerr("powerup_trigger should point to a node of type Powerup")
	$Timer.wait_time = timeout_seconds
	$Tween.interpolate_property(
		$MarginContainer/Control/TextureRect,
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

func _conn_on_powerup_consumed(powerup_name: String, powerup: Powerup) -> void:
	$MarginContainer.visible = true
	$Timer.start()


func _conn_on_tween_all_completed() -> void:
	self.queue_free()
