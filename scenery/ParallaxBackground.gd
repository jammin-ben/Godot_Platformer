extends ParallaxBackground

onready var clouds = $Cloud_Layer
onready var forest = $Forest_Layer
onready var mountains = $Mountain_Layer2 
onready var mountains_far = $Mountain_Layer_Far 
onready var islands = $Island_Layer
export var menu_version = false

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	clouds.motion_offset.x += 2*delta
	islands.motion_offset.y = 2*sin(timer/5)
	if(menu_version):
		forest.motion_offset.x -= 2*delta
		mountains.motion_offset.x -= delta / 2
		mountains_far.motion_offset.x -= delta / 3
		
