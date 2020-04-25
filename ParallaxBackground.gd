extends ParallaxBackground

onready var clouds = $Cloud_Layer
onready var sky = $Sky_Layer
onready var sunset = $Sky_Layer/Sunrise


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clouds.motion_offset.x += 2*delta
