extends Sprite

var Health = 10
var being_eaten = false

onready var particle = $Particles2D
onready var TurtleSpr = get_tree().get_root().get_node("Node2D/Turt_Kinem/Turtle_Spr")

func _process(delta):

	if(being_eaten):
		Health -= delta
		particle.emitting = true 
	else:
		particle.emitting = false
	self.frame = 4 - Health / 2.5
	if(Health<=0):
		print(TurtleSpr.texture)
		TurtleSpr.texture = load("res://sprites/Turt_Alt.png")
		queue_free()

func _on_Area2D_area_entered(area):
	being_eaten=true

func _on_Area2D_area_exited(area):
	being_eaten=false