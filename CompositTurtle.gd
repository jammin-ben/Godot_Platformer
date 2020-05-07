extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var ball_mode = false setget set_ball_mode

onready var turt_default = $TurtleDefault
onready var turt_ball = $TurtleBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turt_default.connect("Hidden", self, "on_turtle_hidden")
	#turt_default.connect("Emerged", self, "on_turtle_emerged")
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_released("turtle_hide"):
		if ball_mode:
			set_ball_mode(false)

func on_turtle_hidden():
	set_ball_mode(true)

func on_turtle_emerged():
	set_ball_mode(false)


func set_ball_mode(value: bool):
	ball_mode = value
	if (ball_mode):
		_set_ball_mode()
	else:
		_set_default_mode()


func _disable_turt_ball():
	turt_ball.visible = false
	$TurtleBall/Camera2D.current = false
	
	$TurtleBall/CollisionPolygon2D.disabled = true
	turt_ball.mode =RigidBody2D.MODE_STATIC
	turt_ball.sleeping = true

func _enable_turt_ball():
	turt_ball.visible = true
	$TurtleBall/Camera2D.current = true
	
	$TurtleBall/CollisionPolygon2D.disabled = false
	turt_ball.mode = RigidBody2D.MODE_RIGID
	turt_ball.sleeping = false

func _disable_turt_default():
	turt_default.visible = false
	$TurtleDefault/Camera2D.current = false
	$TurtleDefault/CollisionShape2D.disabled = true
	turt_default.set_physics_process(false)
	
func _enable_turt_default():
	turt_default.visible = true
	$TurtleDefault/Camera2D.current = true
	$TurtleDefault/CollisionShape2D.disabled = false
	turt_default.set_physics_process(true)

func _set_default_mode():
	_disable_turt_ball()
	_enable_turt_default()
	turt_default.position = turt_ball.position
	turt_default.rotation = turt_ball.rotation
	_correct_turt_default()

func _correct_turt_default():
	var tween = $Tween
	tween.interpolate_property(turt_default, "rotation_degrees",
	turt_default.rotation_degrees, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _set_ball_mode():
	_disable_turt_default()
	_enable_turt_ball()
	turt_ball.position = turt_default.position
	turt_ball.position.y -= 2
	turt_ball.rotation_degrees = 0
	$TurtleBall/Sprite.flip_h = $TurtleDefault/Turtle_Spr.flip_h
	if $TurtleBall/Sprite.flip_h:
		$TurtleBall/CollisionPolygon2D.scale.x = -1
	else:
		$TurtleBall/CollisionPolygon2D.scale.x = 1
		
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	print(turt_default.rotation_degrees)
#	pass
