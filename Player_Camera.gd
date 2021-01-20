extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const YWEIGHTMIN=2
const YWEIGHTEXTRA=2
const YDISTTHRESHOLD=45 
const YDISTSLACK=30 #Slack as in baleying for rock climbers

onready var turt_default = get_parent().get_node("CompositTurtle/TurtleDefault")
onready var turt_ball = get_parent().get_node("CompositTurtle/TurtleBall")
onready var turt_parent = get_parent().get_node("CompositTurtle")
onready var turt = turt_default

var target
var weights
var in_cutscene=false

func _ready():
	
	turt_parent.connect("turtle_mode_change", self, "_conn_turtle_mode_change")

func _process(delta):
	
	if(!in_cutscene):
		weights = Vector2(2,2)
		target= turt.position+turt_parent.position
	
		#This code increases camera speed if turtle is falling too fast
		var t = target.y - self.position.y
		var interp = clamp((t-YDISTTHRESHOLD)/YDISTSLACK,0,1)
		weights.y = YWEIGHTMIN+YWEIGHTEXTRA*interp
	
	self.position += delta * weights * (target - position)

func _conn_turtle_mode_change(mode: String):
	if mode == "ball":
		turt = turt_ball
	else:
		turt = turt_default

func _on_giantstrawberry_eaten(position):
	in_cutscene=true
	weights = Vector2(1,.1)
	target = position
	target.y -= 80
