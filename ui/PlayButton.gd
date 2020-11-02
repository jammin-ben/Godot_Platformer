extends "res://MyButton.gd"

func run():
	var err = get_tree().change_scene("res://Levels/World.tscn")
	if err != OK:
		print("ERROR: ",err)
		
