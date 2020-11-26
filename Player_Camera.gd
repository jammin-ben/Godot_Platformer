extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var turt_default = get_parent().get_node("CompositTurtle/TurtleDefault")
onready var turt_ball = get_parent().get_node("CompositTurtle/TurtleBall")
onready var turt_parent = get_parent().get_node("CompositTurtle")
onready var turt = turt_default
# Called when the node enters the scene tree for the first time.
func _ready():
	
	turt_parent.connect("turtle_mode_change", self, "_conn_turtle_mode_change")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weights = Vector2(2,2)
	var target= turt.position+turt_parent.position
	#self.position += 2 * delta * (target - position)
	if(target.y  - self.position.y> 50):
		weights.y = 4
	self.position += delta * weights * (target - position)

func _conn_turtle_mode_change(mode: String):
	if mode == "ball":
		turt = turt_ball
	else:
		turt = turt_default
