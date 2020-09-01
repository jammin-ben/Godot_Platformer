tool
extends Node2D
class_name Powerup

export(String) var powerup_name
export(Texture) var ui_image
export(Texture) var animated_texture setget set_animated_texture
export(Color, RGBA) var particle_color setget set_particle_color
export(Shape2D) var collision_shape setget set_collision_shape

signal powerup(powerup_name)

func _ready():
	if ui_image:
		$UIImage.texture = ui_image

func set_animated_texture(value: Texture):
	$AnimatedTexture.texture = value
	animated_texture = value
func set_particle_color(value: Color):
	$AnimatedTexture.texture = value
	particle_color = value

func set_collision_shape(value: Shape2D):
	$AnimatedTexture/Hurtbox.collision_shape = collision_shape
	collision_shape = value
