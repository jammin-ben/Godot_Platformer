extends Node2D

class_name CompositeTurtle

# warning-ignore:unused_signal
signal turtle_mode_change(mode)

var ball_mode = false setget set_ball_mode


onready var turt_default = $TurtleDefault
onready var turt_ball = $TurtleBall
onready var active_turtle = turt_default

var level_powerups = []


func _process(_delta: float) -> void:
	pass


func _ready() -> void:
	pass
	# turt_default.connect("Hidden", self, "on_turtle_hidden")

func _input(event: InputEvent) -> void:
	pass
	if event.is_action_released("turtle_hide"):
		if ball_mode:
			set_ball_mode(false)

func on_turtle_hidden():
	if turt_default.has_powerup.ball_mode and (!active_turtle == turt_ball):
		set_ball_mode(true)

# func on_turtle_emerged():
# 	print("Here3")
# 	if ball_mode:
# 		set_ball_mode(false)


# warning-ignore:unused_argument
func set_flutter_group_to_active_turtle(flutter_group):
	pass
	# active_turtle.add_child(flutter_group)


# warning-ignore:unused_argument
func set_texture(value):
	pass
	# $TurtleDefault/Sprite.texture = load(value)
	# $TurtleBall/Sprite.texture = load(value)
	
# warning-ignore:unused_argument
func set_ball_mode(value: bool):
	ball_mode = value
	if (ball_mode):
		_disable_turt_default()
		# _enable_turt_ball()
		# turt_ball.position = turt_default.position
		# turt_ball.position.y -= 2
		# turt_ball.rotation_degrees = 0
		# turt_ball.linear_velocity = turt_default.motion;
		# $TurtleBall/Sprite.flip_h = $TurtleDefault/Sprite.flip_h
		# if $TurtleBall/Sprite.flip_h:
		# 	$TurtleBall/CollisionPolygon2D.scale.x = -1
		# else:
		# 	$TurtleBall/CollisionPolygon2D.scale.x = 1
			# emit_signal("turtle_mode_change", "ball")
	else:
		print("Heree")
		pass
		# _set_default_mode()
		# emit_signal("turtle_mode_change", "default")


func _disable_turt_ball():
	pass
	# turt_ball.visible = false
	#$TurtleBall/Camera2D.current = false
	
	# $TurtleBall/CollisionPolygon2D.disabled = true
	# turt_ball.mode =RigidBody2D.MODE_STATIC
	# turt_ball.sleeping = true

func _enable_turt_ball():
	pass
	# turt_ball.visible = true
	#$TurtleBall/Camera2D.current = true
	
	# $TurtleBall/CollisionPolygon2D.disabled = false
	# turt_ball.mode = RigidBody2D.MODE_RIGID
	# turt_ball.sleeping = false
	# var flutter_group = get_and_remove_flutter_group()
	# active_turtle = turt_ball
	# set_flutter_group_to_active_turtle(flutter_group)

func _disable_turt_default():
	turt_default.visible = false
	$TurtleDefault/CollisionShape2D.disabled = true
	turt_default.set_physics_process(false)
	turt_default.get_parent().remove_child(turt_default)
	
func _enable_turt_default():
	turt_default.visible = true
	turt_default.get_node("CollisionShape2D").disabled = false
	turt_default.set_physics_process(true)
	var flutter_group = get_and_remove_flutter_group()
	active_turtle = turt_default
	set_flutter_group_to_active_turtle(flutter_group)

func get_and_remove_flutter_group():
	pass
	# var flutter_group = active_turtle.get_node("FlutterGroup")
	# active_turtle.remove_child(flutter_group)
	# return flutter_group

func _set_default_mode():
	pass
	_disable_turt_ball()
	_enable_turt_default()
	turt_default.position = turt_ball.position
	turt_default.rotation = turt_ball.rotation
	turt_default.motion = turt_ball.linear_velocity
	_correct_turt_default()
	# turt_default.state_machine.travel("Emerge")

func _correct_turt_default():
	pass
	# var tween = $Tween
	# tween.interpolate_property(turt_default, "rotation_degrees",
	# turt_default.rotation_degrees, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# tween.start()

func _set_ball_mode():
	pass
