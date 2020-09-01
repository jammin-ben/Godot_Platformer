extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level_powerups = []

# Called when the node enters the scene tree for the first time.
func _ready():
	level_powerups = get_tree().get_nodes_in_group(Globals.POWERUP_GROUP)
	for powerup in level_powerups:
		powerup.connect("powerup", self, "_conn_on_powerup_consumed")
	pass # Replace with function body.

func _conn_on_powerup_consumed(powerup_name: String, powerup: Powerup):
	match(powerup_name):
		Globals.POWERUP_BALL_MODE, Globals.POWERUP_FLUTTER_JUMP, Globals.POWERUP_WALL_JUMP:
			var container = get_node("MarginContainer/GridContainer/" + powerup_name)
			if container:
				container.texture = powerup.ui_image

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
