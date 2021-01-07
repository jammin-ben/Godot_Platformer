extends Node2D
var turtle_in_cave = false 
var turtle = null 
onready var dist_to_y_extent = $Area2D/CollisionShape2D.get_shape().extents[1]
onready var global_pos_y = global_position.y
onready var c_dark = Color(13/256,70/256,122/256)
var c_light = Color(1,1,1,1)

func _process(_delta):
	if(turtle_in_cave):
		var depth = (turtle.active_turtle.global_position.y - global_pos_y + dist_to_y_extent)/(2*dist_to_y_extent)
		$CanvasModulate.color = c_light.linear_interpolate(c_dark,depth)
		
func _on_Area2D_area_entered(area):
	turtle = area.get_parent().get_parent()
	#.active_turtle.y
	turtle_in_cave=true

func _on_Area2D_area_exited(_area):
	turtle_in_cave=false
