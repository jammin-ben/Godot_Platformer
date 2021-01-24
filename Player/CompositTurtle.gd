extends Node2D

class_name CompositeTurtle

# warning-ignore:unused_signal
signal turtle_mode_change(mode)

var ball_mode = false setget set_ball_mode
var is_emerged = true


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
	if event.is_action_released("turtle_hide"):
		if not self.is_a_parent_of(turt_default):
			# call_deferred("add_child", turt_default)
			set_ball_mode(false)

func on_turtle_hidden():
	if turt_default.has_powerup.ball_mode and (!active_turtle == turt_ball) and is_emerged:
		set_ball_mode(true)

func on_turtle_emerged():
	is_emerged = true
	# if ball_mode:
	# 	add_child(turt_default)
	# 	set_ball_mode(false)


# warning-ignore:unused_argument
func set_flutter_group_to_active_turtle(flutter_group):
	active_turtle.add_child(flutter_group)


# warning-ignore:unused_argument
func set_texture(value):
	pass
	# turt_default.get_node("Sprite.texture = load(value)
	# turt_ball.get_node("Sprite.texture = load(value)
	
# warning-ignore:unused_argument
func set_ball_mode(value: bool):
	ball_mode = value
	if (ball_mode):
		_disable_turt_default()
		remove_child(turt_default)
		_enable_turt_ball()
		turt_ball.position = turt_default.position
		turt_ball.position.y -= 2
		turt_ball.rotation_degrees = 0
		turt_ball.linear_velocity = turt_default.motion;
		turt_ball.get_node("Sprite").flip_h = turt_default.get_node("Sprite").flip_h
		if turt_ball.get_node("Sprite").flip_h:
			turt_ball.get_node("CollisionShape").scale.x = -1
		else:
			turt_ball.get_node("CollisionShape").scale.x = 1
		emit_signal("turtle_mode_change", "ball")
		is_emerged = false
	else:
		add_child(turt_default)
		turt_default.position = Vector2(0, 25)
		_set_default_mode()
		emit_signal("turtle_mode_change", "default")


func _disable_turt_ball():
	turt_ball.visible = false
	# turt_ball.get_node("Camera2D").current = false
	
	turt_ball.get_node("CollisionShape").disabled = true
	turt_ball.get_node("Area2D/CollisionPolygon2D2").disabled = true
	turt_ball.mode = RigidBody2D.MODE_STATIC
	turt_ball.sleeping = true

func _enable_turt_ball():
	turt_ball.visible = true
	turt_ball.get_node("CollisionShape").disabled = false
	turt_ball.get_node("Area2D/CollisionPolygon2D2").disabled = false
	turt_ball.mode = RigidBody2D.MODE_RIGID
	turt_ball.sleeping = false
	var flutter_group = get_and_remove_flutter_group()
	active_turtle = turt_ball
	set_flutter_group_to_active_turtle(flutter_group)

func _disable_turt_default():
	turt_default.visible = false
	turt_default.get_node("CollisionShape2D").disabled = true
	turt_default.set_physics_process(false)
	
func _enable_turt_default():
	turt_default.get_node("CollisionShape2D").disabled = false
	turt_default.set_physics_process(true)
	var flutter_group = get_and_remove_flutter_group()
	active_turtle = turt_default
	set_flutter_group_to_active_turtle(flutter_group)
	turt_default.visible = true

func get_and_remove_flutter_group():
	var flutter_group = active_turtle.get_node("FlutterGroup")
	active_turtle.remove_child(flutter_group)
	return flutter_group

func _set_default_mode():
	_disable_turt_ball()
	_enable_turt_default()
	turt_default.position = turt_ball.position
	turt_default.rotation = turt_ball.rotation
	turt_default.motion = turt_ball.linear_velocity
	_correct_turt_default()

func _correct_turt_default():
	var tween = $Tween
	tween.interpolate_property(turt_default, "rotation_degrees",
	turt_default.rotation_degrees, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _set_ball_mode():
	pass


func _on_eat_giant_strawberry(area):
	$TurtleDefault.in_cutscene=true


func _on_big_mushroom_mushroom_eaten():
	$TurtleBall/Light2D.enabled=true
	$TurtleDefault/Light2D.enabled=true
