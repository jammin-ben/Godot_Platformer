extends KinematicBody2D

var vel = Vector2(1,1)
const SPEED = 35

func _ready():
	self.vel.x = 2*randf()-1
	self.vel.y = 2*randf()-1
	self.vel=self.vel.normalized()*SPEED
	$RayCast2D.cast_to=self.vel/3
	
func _physics_process(delta):
	if($RayCast2D.is_colliding()):
		#randomize direction
		self.vel = self.vel.rotated(PI)
		$RayCast2D.cast_to=self.vel/3
	
	self.position += vel*delta
