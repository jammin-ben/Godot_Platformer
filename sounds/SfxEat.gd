extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var eat_sfx_pitch_scale_range = Vector2(0.9, 1.1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var being_eaten = false
var eater = null

var _can_free = false

func randomize_eat_sfx_pitch_scale():
	self.pitch_scale = rand_range(eat_sfx_pitch_scale_range.x, eat_sfx_pitch_scale_range.y)

func play_eat_sfx():
	being_eaten = true

func stop_eat_sfx():
	being_eaten = false

func _process(_delta):

	if(being_eaten):
		if not self.playing:
			randomize_eat_sfx_pitch_scale()
			self.playing = true
	

func queue_free_on_sfx_ended():
	_can_free = true


func _conn_on_eat_sfx_finished() -> void:
	randomize_eat_sfx_pitch_scale()
