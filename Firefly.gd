extends Node2D

export(Color) var color = Color(1,1,1,1)

func _ready():
	$Timer.start(randf())
	$Glow.color=color



func _on_Timer_timeout():
	$AnimationPlayer.play("Blink")
