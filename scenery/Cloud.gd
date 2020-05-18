extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var movespeed
# Called when the node enters the scene tree for the first time.
func _ready():
	movespeed = .7 # Replace with function body.
	self.frame = floor(randf()*3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x+=movespeed * delta
