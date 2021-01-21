extends Node2D
signal eaten(position)
signal credits_done()

func _ready():
	pass
	#$Title.modulate.a=1

func _on_Area2D_area_entered(_area):
	emit_signal("eaten",self.position)
	$creditsplayer.play("credits")
	#$Tween.interpolate_property($Title,"modulate",$Title.modulate,Color(1,1,1,1),10,Tween.TRANS_QUINT)
	#$Tween.interpolate_property($CanvasModulate,"color",Color(1,1,1,1),Color(0,0,0,2),5)
	#$Tween.start()


func _on_creditsplayer_animation_finished(_anim_name):
	emit_signal("credits_done")
