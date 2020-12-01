extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var timeout_seconds = 5
export var fade_time_seconds = 1
export var animation_speed_scale = 0.5
export(String, FILE, "*.png,*.jpg,*.jpeg") var sprite_sheet = null
export var hframes=4
export var vframes=1
export(NodePath) var powerup_trigger = "."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/Control/AnimatedSprite.speed_scale = animation_speed_scale
	create_animation_frames()
	var powerup = get_node(powerup_trigger)
	if (powerup is Powerup):
		powerup.connect("powerup", self, "_conn_on_powerup_consumed")
	else:
		printerr("powerup_trigger should point to a node of type Powerup")
	$Timer.wait_time = timeout_seconds
	$Tween.interpolate_property(
		$MarginContainer/Control/AnimatedSprite,
		"modulate:a",
		1,
		0,
		fade_time_seconds,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		1
	)


func _conn_on_timer_timeout() -> void:
	$Tween.start()

func _conn_on_powerup_consumed(powerup_name: String, powerup: Powerup) -> void:
	$MarginContainer.visible = true
	$Timer.start()


func _conn_on_tween_all_completed() -> void:
	self.queue_free()


# sets up all of the animation frame crap needed for the animation
# to work
func create_animation_frames():
	
	var sprite_frames = SpriteFrames.new()
	var animated_sprite = $MarginContainer/Control/AnimatedSprite
	animated_sprite.frames = sprite_frames
	
	
	
	var sprite_sheet_image = Image.new() # just need this for width info
	sprite_sheet_image.load(sprite_sheet)
	# get the width so we know how many frames are in it
	var image_width = sprite_sheet_image.get_width()
	var image_height = sprite_sheet_image.get_height()
	
	# we'll need the image texture later for the
	# individual atlas texture frames
	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(sprite_sheet_image, Texture.FLAG_MIPMAPS)
	
	var frame_width = image_width / hframes
	var frame_height = image_height / vframes
	
	# divide for number of frames, and loop through how
	# many frames there will be
	for vertical_frames in floor(image_height / frame_height):
		for horizontal_frames in floor(image_width / frame_width):
			# for every frame, we create the new frame
			# we need an atlas texture for that
			var frame = AtlasTexture.new()
			# we know we want to use the the sprite sheet for
			# each frame so set the atlas property to the sprite
			# sheet imageTexture we loaded in ealier
			frame.atlas = imageTexture
			
			# now we're going to calculate the rect that
			# we need for the frame coordinates
			
			
			#frame.region = Rect2(Vector2(0, 0), Vector2(0, 0))
			frame.region = Rect2(frame_width * horizontal_frames, frame_height * vertical_frames, frame_width, frame_height)
			sprite_frames.add_frame('default', frame)
			

	pass
