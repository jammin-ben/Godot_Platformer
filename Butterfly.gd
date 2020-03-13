extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var height = 0
var t = 0
var bigheight = 0
var xspeed = 0
var yspeed = 0
# Called when the node enters the scene tree for the first time.
var yoffset = 0
var xoffset = 0
func _ready():
	var r = randf()
	if(r<.1):
		$ButterflyAnimator.play("Red")
	elif(r<.5):
		$ButterflyAnimator.play("Yellow")
	elif(r<.75):
		$ButterflyAnimator.play("Blue")
	else:
		$ButterflyAnimator.play("White")
	#random direction
	var speed = 100
	xspeed=randf()*2*speed-speed
	yspeed=randf()*2*speed-speed

	xoffset = get_global_transform()[2][0]
	yoffset = get_global_transform()[2][1]

func _process(delta):
	t+=delta
	height = sin(2*PI /.4*t)
	bigheight = sin(t) *4
	self.offset.y = height + bigheight
	self.position.x+=delta*xspeed
	self.position.y+=delta*yspeed
	if(self.position.x + xoffset >get_viewport().size.x):
		self.position.x = -xoffset
	if(self.position.y + yoffset >get_viewport().size.y):
		self.position.y = -yoffset
	if(self.position.x<-xoffset):
		self.position.x = get_viewport().size.x - xoffset
	if(self.position.y<-yoffset):
		self.position.y = get_viewport().size.y - yoffset

