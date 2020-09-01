tool
extends Node2D
class_name Powerup

export(String) var powerup_name

export(Texture) var animated_texture setget set_animated_texture
export(Texture) var ui_image
export(Color, RGBA) var particle_color setget set_particle_color

signal powerup(powerup_name, powerup)

func _ready():
	if ui_image:
		$UIImage.texture = ui_image
#	print($AnimatedTexture)

func set_animated_texture(value: Texture):
	animated_texture = value
	if Engine.editor_hint and has_node("AnimatedTexture"):
		$AnimatedTexture.texture = value

	
func set_particle_color(value: Color):
	if Engine.editor_hint and has_node("AnimatedTexture/Particles2D"):
		$AnimatedTexture.particle_color = value
	particle_color = value


func _conn_on_powerup_eaten():
	emit_signal("powerup", powerup_name, self)
