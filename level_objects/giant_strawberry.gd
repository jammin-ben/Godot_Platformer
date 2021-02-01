extends Node2D
signal eaten(position)
signal credits_done()
var credits = false
func _ready():
	pass

func _on_Area2D_area_entered(_area):
	if(!credits):
		emit_signal("eaten", self.position)
		$SfxEat.play_eat_sfx()
		$Particles2D.emitting = true
		$creditsplayer.play("credits")
		credits=true

func _on_creditsplayer_animation_finished(_anim_name):
	emit_signal("credits_done")

func _on_Area2D_area_exited(_area: Area2D) -> void:
	$SfxEat.stop_eat_sfx()
	$Particles2D.emitting = false
