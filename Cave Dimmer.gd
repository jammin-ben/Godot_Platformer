extends Node2D
var turtle_in_cave = false 
var turtle = null 
var active = true #becomes false at the end of the game
onready var dist_to_y_extent = $Area2D/CollisionShape2D.get_shape().extents[1]
onready var global_pos_y = global_position.y
export var c_dark = Color(13/256,70/256,122/256)
var c_light = Color(1,1,1,1)

var debug_count = 0

func _process(_delta):
	if(turtle_in_cave and active):
		var depth = (turtle.active_turtle.global_position.y - global_pos_y + dist_to_y_extent)/(2*dist_to_y_extent)
		depth = min(depth*2,1)
		$CanvasModulate.color = c_light.linear_interpolate(c_dark,depth)
		
func _on_Area2D_area_entered(area):
	turtle = area.get_parent().get_parent()
	debug_count += 1
	#.active_turtle.y
	turtle_in_cave=true

func _on_Area2D_area_exited(_area):
	
	debug_count +=1
	turtle_in_cave=false

func _on_giantstrawberry_eaten(_position):
	active = false
