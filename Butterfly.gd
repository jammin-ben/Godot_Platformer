extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MIN_SPEED = 20
const MAX_SPEED = 25

var height = 0
var t = 0
var bigheight = 0
#var speed = 0
# Called when the node enters the scene tree for the first time.
var yoffset = 0
var xoffset = 0


var vel = Vector2(0,0)
var acc = Vector2(0,0)
onready var w_area = $WallArea
onready var b_area = $ButterflyArea
onready var ray = $RayCast2D
onready var vision_width = $ButterflyArea/CollisionShape2D.shape.radius


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

	#random init
	var speed = 10
	vel = Vector2(speed,0)
	ray.cast_to = normalize(vel) * vision_width
	
func flutter(delta):
	t+=delta
	height = sin(2*PI /.4*t)
	bigheight = sin(t) *4
	self.offset.y = height + bigheight

func get_all_butterflies():
	return b_area.get_overlapping_bodies()
	
func normalize(vector):
	var mag = sqrt(vector.x*vector.x + vector.y*vector.y)
	return Vector2(vector.x/mag,vector.y/mag)

func avoid_obstacles():
	var walls =  w_area.get_overlapping_bodies()
	if(len(walls)>0):
		
		var angle = 0
		if(vel.x != 0):
			if(vel.x>0):
				angle = atan(vel.y/vel.x)
			else:
				angle = PI + atan(vel.y/vel.x)
		else:
			
			angle = PI/2 * sign(vel.y)
		print(angle/2/PI*360)
		
		var dist = 0
		var mag = 1
		var off = 2*PI/10
		var num_tries = 0
		print("_______________")
		while(ray.is_colliding()):
			print(angle/2/PI*360)
			dist += off 
			mag *= -1
			angle += mag * dist
			print('\t'+str(angle))
			ray.cast_to = vision_width * Vector2(cos(angle),sin(angle))
			ray.force_raycast_update()
			num_tries +=1
			if(num_tries > 5):
				print("i give up")
				break
		acc = ray.cast_to*10
func magnitude(vector):
	return sqrt(vector.x * vector.x + vector.y * vector.y)
	
func apply_acceleration(delta):
	vel += acc*delta
	var s = magnitude(vel)
	var dir = vel / s 
	s = clamp(s,MIN_SPEED,MAX_SPEED) * sign(s)
	#print(s)
	vel = dir * s


func _draw():
	pass   
# draw_line(Vector2(0,0), vel, Color(255, 0, 0), 1)


func _physics_process(delta):
	self.acc = Vector2(0,0)
	avoid_obstacles()
	apply_acceleration(delta)
	self.position += self.vel * delta
	#self.position=get_global_mouse_position()