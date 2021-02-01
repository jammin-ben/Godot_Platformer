extends Node2D
signal eaten(position)
signal credits_done()

func _ready():
	pass

func _on_Area2D_area_entered(_area):
	emit_signal("eaten", self.position)
	$SfxEat.play_eat_sfx()
	$creditsplayer.play("credits")


func _on_creditsplayer_animation_finished(_anim_name):
	emit_signal("credits_done")


func _on_Area2D_area_exited(_area: Area2D) -> void:
	$SfxEat.stop_eat_sfx()
	pass # Replace with function body.
