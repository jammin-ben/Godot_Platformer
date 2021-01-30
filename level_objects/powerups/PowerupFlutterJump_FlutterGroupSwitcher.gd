# Responsible for moving the flutter group from the powerup on to the player when the player eats the
# powerup 
extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var called_once = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _conn_on_PowerupFlutterJumpEaten(powerup_name, powerup) -> void:
	if !called_once:
		var parent = get_parent()
		var flutter_group = parent.get_node('FlutterGroup')
		var c_turt = Globals.get_player()
		var active_turt = c_turt.active_turtle
		if active_turt:
			parent.remove_child(flutter_group)
			active_turt.add_child(flutter_group)
			called_once = true
