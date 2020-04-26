extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var default_turt = $TurtleDefault
onready var ball_turt = $TurtleBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_turt.connect("Hidden", self, "on_turtle_hidden")
	default_turt.connect("Emerged", self, "on_turtle_emerged")
	pass # Replace with function body.

func on_turtle_hidden():
	print("The turtle is now hidden")

func on_turtle_emerged():
	print("The turtle has now emerged")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
