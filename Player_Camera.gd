extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var turt = get_parent().get_node("CompositTurtle/TurtleDefault")
onready var turt_parent = get_parent().get_node("CompositTurtle")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weights = Vector2(2,2)
	var target= turt.position+turt_parent.position
	#self.position += 2 * delta * (target - position)
	if(target.y  - self.position.y> 50):
		weights.y = 4
	self.position += delta * weights * (target - position)
