extends KinematicBody2D

var vel = Vector2(1,1)
const SPEED = 35

export var white = false

func _ready():
	var r = randf()
	
	if(!white):
		if(r<.25):
			$ButterflySprite/ButterflyAnimator.play("Red")
		elif(r<.5):
			$ButterflySprite/ButterflyAnimator.play("Yellow")
		elif(r<.75):
			$ButterflySprite/ButterflyAnimator.play("Blue")
		else:
			$ButterflySprite/ButterflyAnimator.play("White")
	else:
		$ButterflySprite/ButterflyAnimator.play("White")
	
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
