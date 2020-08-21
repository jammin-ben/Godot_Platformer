extends Sprite

var Health = 10
var being_eaten = false


export var replacement_spr_string="res://sprites/Turt_Alt.png"
export var particle_color = Color(1,0,0,1)

onready var particle = $Particles2D
onready var TurtleSpr = get_tree().get_root().get_node("Node2D/Turt_Kinem/Turtle_Spr")
func _ready():
	particle.process_material = particle.process_material.duplicate()
	particle.process_material.color = particle_color

func _process(delta):

	if(being_eaten):
		Health -= delta
		particle.emitting = true 
	else:
		particle.emitting = false
	self.frame = 4 - Health / 2.5
	if(Health<=0):
		print(TurtleSpr.texture)
		TurtleSpr.texture = load(replacement_spr_string)
		queue_free()

func _on_Area2D_area_entered(area):
	being_eaten=true

func _on_Area2D_area_exited(area):
	being_eaten=false
