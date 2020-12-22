extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _connection_val = $TutorialUI/Tween.connect("tween_all_completed", self, "queue_free")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _conn_on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Turtle:
		$TutorialUI.start_tutorial()
	pass # Replace with function body.
