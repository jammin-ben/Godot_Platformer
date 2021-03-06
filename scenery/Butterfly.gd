extends KinematicBody2D
#DEPRECATED
#USE Simple_Butterfly instead

const MIN_SPEED = 35
const MAX_SPEED = 50
const OBSTACLE_WEIGHT = 20
const PEER_WEIGHT = 20
const CONVERGE_WEIGHT = 20
enum {FREE,FRIEND,GOTO_CENTER}

export var movementMode = FREE
var height = 0
var t = 0
var bigheight = 0
var mag = 1
var dist = 0
var off = 2*PI/6
var angle = -1
#var speed = 0
# Called when the node enters the scene tree for the first time.
var yoffset = 0
var xoffset = 0
var center_timer = 0


var vel = Vector2(0,0)
var acc = Vector2(0,0)
onready var w_area = $WallArea
onready var b_area = $ButterflyArea
onready var ray = $RayCast2D
onready var vision_width = $WallArea/CollisionShape2D.shape.radius


func _ready():
#	print(vision_width)
	
	var r = randf()
	if(r<.1):
		$ButterflySprite/ButterflyAnimator.play("Red")
	elif(r<.5):
		$ButterflySprite/ButterflyAnimator.play("Yellow")
	elif(r<.75):
		$ButterflySprite/ButterflyAnimator.play("Blue")
	else:
		$ButterflySprite/ButterflyAnimator.play("White")

	#random init
	vel = Vector2(randf()*2*MAX_SPEED-MAX_SPEED,randf()*2*MAX_SPEED-MAX_SPEED)
	ray.cast_to = normalize(vel) * vision_width
	
func flutter(delta):
	t+=delta
	height = sin(2*PI /.4*t)
	bigheight = sin(t) *4
	self.offset.y = height + bigheight

func get_all_butterflies():
	return b_area.get_overlapping_bodies()
	
func normalize(vector):
	var magnitude = sqrt(vector.x*vector.x + vector.y*vector.y)
	return Vector2(vector.x/magnitude,vector.y/magnitude)

func avoid_obstacles():
	#TODO make them avoid each other
	var walls =  w_area.get_overlapping_bodies()
	if(len(walls)>0):
		if(angle==-1):
			#set angle
			if(vel.x != 0):
				if(vel.x>0):
					angle = atan(vel.y/vel.x)
				else:
					angle = PI + atan(vel.y/vel.x)
			else:
				angle = PI/2 * sign(vel.y)
		
		if(ray.is_colliding()):
			dist += off 
			mag *= -1
			angle += mag * dist
			ray.cast_to = vision_width * Vector2(cos(angle),sin(angle))
		else:
			dist=0
			
			angle = -1
			return(ray.cast_to*10)
	return Vector2(0,0)

func follow_frens():
	var frens = b_area.get_overlapping_bodies()
	if(len(frens)>0):
		var avg = Vector2(0,0)
		var center = Vector2(0,0)
		for fren in frens:
			#print(fren)
			avg += fren.vel
			center += fren.position
		avg /= len(frens)
		center /= len(frens)
	
		var difference = position - center
		return [avg,difference]
	return [Vector2(0,0),Vector2(0,0)]

	

func magnitude(vector):
	return sqrt(vector.x * vector.x + vector.y * vector.y)
	
func apply_acceleration(delta):
	vel += acc*delta
	var s = magnitude(vel)
	var dir = vel / s 
	s = clamp(s,MIN_SPEED,MAX_SPEED) * sign(s)
	vel = dir * s


func _draw():
	pass   
# draw_line(Vector2(0,0), vel, Color(255, 0, 0), 1)


func _physics_process(delta):
	if movementMode == FREE:
		self.acc = Vector2(0,0)
		var a = avoid_obstacles()
		var dummy_val = follow_frens()
		var b = dummy_val[0]
		var c = dummy_val[1]
		
		acc = OBSTACLE_WEIGHT*a+PEER_WEIGHT*b+CONVERGE_WEIGHT*c
		
		apply_acceleration(delta)
		self.position += self.vel * delta
		
	elif movementMode == GOTO_CENTER:
		self.vel = -MIN_SPEED * normalize(self.position)
		self.position += self.vel * delta
		center_timer -= delta
		if center_timer <0:
			movementMode = FREE
	#self.position=get_global_mouse_position()
