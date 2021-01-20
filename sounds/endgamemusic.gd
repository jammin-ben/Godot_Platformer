extends AudioStreamPlayer

func _on_giantstrawberry_eaten(_position):
	if(!self.playing):
		self.play()
