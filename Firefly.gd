extends Node2D

export(Color) var color = Color(1,1,1,1)

func _ready():
	$Glow.color=color
	$Thorax.color=color
