extends Sprite

var Health = 10
var being_eaten = false

onready var particle = $Particles2D

func _process(delta):
	#if(Input.is_action_pressed("eat")):
#		being_eaten=true 
#	else: being_eaten = false
	
	if(being_eaten):
		Health -= delta
		particle.emitting = true 
	else:
		particle.emitting = false
	self.frame = 4 - Health / 2.5
	if(Health<=0):
		queue_free()

func _on_Area2D_area_entered(area):
	being_eaten=true

func _on_Area2D_area_exited(area):
	being_eaten=false