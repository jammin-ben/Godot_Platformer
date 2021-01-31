extends AudioStreamPlayer




func _on_PowerupBallMode_powerup(_powerup_name, _powerup):
	if(!playing):
		play()


func _on_PowerupFlutterJump_powerup(_powerup_name, _powerup):
	if(!playing):
		play()


func _on_PowerupWallJump_powerup(_powerup_name, _powerup):
	if(!playing):
		play()
