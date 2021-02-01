extends Node2D
var health = 2.5
var being_eaten=false
signal mushroom_eaten
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if being_eaten:
		health -= delta
	if health <= delta: 
		emit_signal("mushroom_eaten")
		queue_free()


func _on_Area2D_area_entered(_area):
	being_eaten=true
	$Particles2D.emitting=true
	$SfxEat.play_eat_sfx()

func _on_Area2D_area_exited(_area):
	being_eaten=false
	$Particles2D.emitting=false
	$SfxEat.stop_eat_sfx()


func _on_SfxEat_finished() -> void:
	pass # Replace with function body.
