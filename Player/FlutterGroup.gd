extends Node2D

const CONVERGE_SPEED = 7
const MAX_DISTANCE = 32
var curr_max_distance = MAX_DISTANCE
var carrying = false
var original_xs = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for bf in $Butterflies.get_children():
		original_xs[bf] = bf.position.x

func modulus(vec:Vector2):
	return sqrt(vec.x*vec.x + vec.y*vec.y)

func _process(delta):
	for bf in $Butterflies.get_children():
		var child = bf.get_children()[0]
		child.position = child.position.clamped(curr_max_distance)
		if get_parent().get_sprite().flip_h:
			bf.position.x = lerp(bf.position.x,-1*original_xs[bf],CONVERGE_SPEED*delta)
		else:
			bf.position.x = lerp(bf.position.x,original_xs[bf],CONVERGE_SPEED*delta)
		
	if carrying:
		curr_max_distance = lerp(curr_max_distance,0,CONVERGE_SPEED * delta)
		
	else:
		curr_max_distance = lerp(curr_max_distance,MAX_DISTANCE,CONVERGE_SPEED * delta)


func _on_TurtleDefault_signal_debug_st_changed(state):
	if state == 1:
		carrying = true
	else:
		carrying = false


func _conn_consumed_powerup_flutter_jump() -> void:
	visible = true
