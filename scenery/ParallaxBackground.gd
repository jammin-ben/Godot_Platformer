extends ParallaxBackground

onready var clouds = $Cloud_Layer
onready var sky = $Sky_Layer
onready var sunset = $Sky_Layer/Sunrise
onready var forest = $Forest_Layer
onready var mountains = $Mountain_Layer2 
onready var mountains_far = $Mountain_Layer_Far 

export var menu_version = false

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clouds.motion_offset.x += 2*delta
	if(menu_version):
		forest.motion_offset.x -= 2*delta
		mountains.motion_offset.x -= delta / 2
		mountains_far.motion_offset.x -= delta / 3
		
