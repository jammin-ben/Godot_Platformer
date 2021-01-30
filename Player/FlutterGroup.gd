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
	connect_to_player_state_change()


func _enter_tree():
	connect_to_player_state_change()


func connect_to_player_state_change():
	var player = Globals.get_player()
	var turt_default = player.turt_default
	if turt_default:
		_connect_to_player_state_change(turt_default)

func _connect_to_player_state_change(turtle_default):
	if !turtle_default.is_connected("signal_st_changed", self, "_conn_TurtDefault_on_signal_st_changed"):
		turtle_default.connect("signal_st_changed", self, "_conn_TurtDefault_on_signal_st_changed")


func modulus(vec:Vector2):
	return sqrt(vec.x*vec.x + vec.y*vec.y)

func _process(delta):
	for bf in $Butterflies.get_children():
		var child = bf.get_children()[0]
		child.position = child.position.clamped(curr_max_distance)
		var parent = get_parent()
		if parent is Turtle:
			if get_parent().get_sprite().flip_h:
				bf.position.x = lerp(bf.position.x,-1*original_xs[bf],CONVERGE_SPEED*delta)
			else:
				bf.position.x = lerp(bf.position.x,original_xs[bf],CONVERGE_SPEED*delta)

	if carrying:
		curr_max_distance = lerp(curr_max_distance,0,CONVERGE_SPEED * delta)
		
	else:
		curr_max_distance = lerp(curr_max_distance,MAX_DISTANCE,CONVERGE_SPEED * delta)


func _conn_TurtDefault_on_signal_st_changed(state):
	if state == 1:
		carrying = true
	else:
		carrying = false


func _conn_consumed_powerup_flutter_jump() -> void:
	visible = true
	
