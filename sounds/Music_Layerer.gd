extends Node2D
onready var tween = get_node("Tween")

func _on_Area2D_area_entered(_area):
	#Fade out aboveground
	tween.interpolate_property($aboveground,"volume_db",$aboveground.volume_db,-60,5)
	tween.start()
	
	#add belowground track to reverb channel 
	$belowground.bus="Reverb"
	
func _on_Area2D_area_exited(_area):
	#Fade in aboveground
	tween.interpolate_property($aboveground,"volume_db",$aboveground.volume_db,0,5)
	tween.start()
	$belowground.bus="Master"

func _on_EndgameArea_area_entered(_area):
	tween.interpolate_property($aboveground,"volume_db",$aboveground.volume_db,-60,5)
	tween.interpolate_property($belowground,"volume_db",$belowground.volume_db,-60,5)
	tween.start()


func _on_giantstrawberry_credits_done():
	$aboveground.stop()
	$belowground.stop()
