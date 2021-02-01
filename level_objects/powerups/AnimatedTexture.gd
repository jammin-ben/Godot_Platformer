tool
extends Sprite

class_name PowerupAnimatedTexture

var Health = 10
var being_eaten = false
var eater = null

var _can_free = false

signal eaten()
signal play_powerup_sfx()

export var particle_color = Color(1,0,0,1)
export var eat_sfx_pitch_scale_range = Vector2(0.9, 1.1)

onready var particle = $Particles2D
#onready var TurtleSpr = get_tree().get_root().get_node("Node2D/Turt_Kinem/Turtle_Spr")



func _ready():
	particle.process_material = particle.process_material.duplicate()
	particle.process_material.color = particle_color

func randomize_eat_sfx_pitch_scale():
	$SfxEat.pitch_scale = rand_range(eat_sfx_pitch_scale_range.x, eat_sfx_pitch_scale_range.y)

func _process(delta):

	if(being_eaten):
		if not $SfxEat.playing:
			randomize_eat_sfx_pitch_scale()
			$SfxEat.playing = true
		Health -= delta
		if not Engine.editor_hint:
			particle.emitting = true 
	else:
		if not Engine.editor_hint:
			particle.emitting = false
	
	if(Health<=0):
		emit_signal("eaten")
		queue_free_on_sfx_ended()
		return
	self.frame = 4 - Health / 2.5
	
func _on_Area2D_area_entered(area):
	eater = area.get_parent().get_parent()#composite_turtle
	#print(eater.name)
	being_eaten=true

func _on_Area2D_area_exited(_area):
	being_eaten=false

func queue_free_on_sfx_ended():
	_can_free = true


func _conn_on_eat_sfx_finished() -> void:
	if _can_free:
		emit_signal("play_powerup_sfx")
		get_parent().queue_free()
		
	randomize_eat_sfx_pitch_scale()
