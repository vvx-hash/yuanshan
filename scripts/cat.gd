extends CharacterBody2D

@export var walk_speed := 72.0
@export var follow_distance := 240.0

var player: CharacterBody2D
var home_position := Vector2.ZERO
var wander_target := Vector2.ZERO
var wander_timer := 0.0
var pet_timer := 0.0
var animation_time := 0.0
var facing := 1.0
var random := RandomNumberGenerator.new()

@onready var prompt: Label = $Prompt

func _ready() -> void:
	home_position = global_position
	random.seed = 20260727
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	_choose_wander_target()

func _physics_process(delta: float) -> void:
	pet_timer = maxf(pet_timer - delta, 0.0)
	wander_timer -= delta
	var direction := Vector2.ZERO

	if is_instance_valid(player):
		var player_distance := global_position.distance_to(player.global_position)
		prompt.visible = player_distance < 86.0
		if prompt.visible and Input.is_action_just_pressed("ui_accept"):
			pet_timer = 1.4
		if player_distance > 72.0 and player_distance < follow_distance:
			direction = global_position.direction_to(player.global_position)
		elif player_distance >= follow_distance:
			direction = _wander_direction()
	else:
		prompt.visible = false
		direction = _wander_direction()

	if pet_timer > 0.0:
		direction = Vector2.ZERO
	velocity = direction * walk_speed
	if absf(velocity.x) > 1.0:
		facing = signf(velocity.x)
	move_and_slide()
	queue_redraw()

func _process(delta: float) -> void:
	animation_time += delta
	queue_redraw()

func _draw() -> void:
	var bob := sin(animation_time * 8.0) * 1.5 if velocity.length() > 2.0 else 0.0
	var body_color := Color("d98f52")
	var dark_color := Color("8a5739")

	draw_arc(Vector2(-facing * 14.0, 5.0 + bob), 19.0, 0.5, 4.3, 18, dark_color, 7.0, true)
	draw_ellipse(Vector2(0, 7 + bob), 22.0, 15.0, body_color)
	draw_circle(Vector2(facing * 17, -8 + bob), 15.0, body_color)

	draw_colored_polygon(PackedVector2Array([
		Vector2(facing * 9, -18 + bob), Vector2(facing * 12, -35 + bob),
		Vector2(facing * 22, -21 + bob)
	]), body_color)
	draw_colored_polygon(PackedVector2Array([
		Vector2(facing * 22, -21 + bob), Vector2(facing * 30, -34 + bob),
		Vector2(facing * 31, -16 + bob)
	]), body_color)

	draw_circle(Vector2(facing * 22, -10 + bob), 2.0, Color("2d3430"))
	draw_circle(Vector2(facing * 31, -5 + bob), 2.0, Color("6b3d3d"))
	draw_line(Vector2(facing * 25, -2 + bob), Vector2(facing * 40, -5 + bob), Color("eadfca"), 1.5)
	draw_line(Vector2(facing * 25, 2 + bob), Vector2(facing * 40, 5 + bob), Color("eadfca"), 1.5)

	if pet_timer > 0.0:
		_draw_heart(Vector2(0, -55 - sin(animation_time * 5.0) * 4.0))

func _draw_heart(center: Vector2) -> void:
	var heart_color := Color("e66b73")
	draw_circle(center + Vector2(-5, -3), 7.0, heart_color)
	draw_circle(center + Vector2(5, -3), 7.0, heart_color)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-11, 0), center + Vector2(11, 0), center + Vector2(0, 15)
	]), heart_color)

func _wander_direction() -> Vector2:
	if wander_timer <= 0.0 or global_position.distance_to(wander_target) < 18.0:
		_choose_wander_target()
	return global_position.direction_to(wander_target)

func _choose_wander_target() -> void:
	wander_timer = random.randf_range(2.5, 5.5)
	wander_target = home_position + Vector2(
		random.randf_range(-180.0, 180.0),
		random.randf_range(-110.0, 110.0)
	)
	wander_target.x = clampf(wander_target.x, 40.0, 2520.0)
	wander_target.y = clampf(wander_target.y, 40.0, 1400.0)
