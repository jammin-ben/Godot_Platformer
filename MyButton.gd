extends Node2D
var timer = 0
# Called when the node enters the scene tree for the first time.
func _process(delta):
	timer+=delta
	self.position.y += sin(timer*3)/20
	if($Sprite.frame==2 and Input.is_action_just_pressed("ui_accept")):
		$Sprite.frame=1
	
	if(Input.is_action_just_released("ui_accept") and $Sprite.frame==1):
		run()

#general function when button is pressed.
func run():
	pass
	
func _on_Area2D_mouse_entered():
	$Sprite.frame=2
	$Sound.play()
	
func _on_Area2D_mouse_exited():
	$Sprite.frame=0
