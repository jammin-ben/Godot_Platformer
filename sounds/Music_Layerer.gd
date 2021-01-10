extends Node2D


func _on_Area2D_area_entered(_area):
	#Fade out aboveground
	var tween = get_node("Tween")
	tween.interpolate_property($aboveground,"volume_db",$aboveground.volume_db,-60,5)
	tween.start()
	
	#add belowground track to reverb channel 
	$belowground.bus="Reverb"
	
func _on_Area2D_area_exited(_area):
	#Fade in aboveground
	var tween = get_node("Tween")
	tween.interpolate_property($aboveground,"volume_db",$aboveground.volume_db,0,5)
	tween.start()
	$belowground.bus="Master"
	