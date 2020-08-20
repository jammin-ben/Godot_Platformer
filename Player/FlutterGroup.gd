extends Node2D

const CONVERGE_SPEED = 7
const MAX_DISTANCE = 32
var curr_max_distance = MAX_DISTANCE
var carrying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func modulus(vec:Vector2):
	return sqrt(vec.x*vec.x + vec.y*vec.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for bf in $Butterflies.get_children():
		var child = bf.get_children()[0]
		child.position=child.position.clamped(curr_max_distance)
	if carrying:
		curr_max_distance = lerp(curr_max_distance,0,CONVERGE_SPEED * delta)
	else:
		curr_max_distance = lerp(curr_max_distance,MAX_DISTANCE,CONVERGE_SPEED * delta)


func _on_TurtleDefault_signal_debug_st_changed(state):
	if state == 1:
		carrying = true
	else:
		carrying = false
