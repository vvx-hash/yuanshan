extends Node2D

const MAP_SIZE := Vector2(2560.0, 1440.0)
const TREE_POSITIONS := [
	Vector2(150, 150), Vector2(290, 220), Vector2(440, 130),
	Vector2(2140, 170), Vector2(2320, 250), Vector2(2420, 120),
	Vector2(170, 1120), Vector2(320, 1260), Vector2(510, 1160),
	Vector2(2120, 1160), Vector2(2280, 1280), Vector2(2430, 1100),
	Vector2(1020, 180), Vector2(1220, 120), Vector2(1420, 210)
]
const ROCK_POSITIONS := [
	Vector2(720, 240), Vector2(930, 1110), Vector2(1540, 1180),
	Vector2(2040, 850), Vector2(360, 720)
]
const FLOWER_POSITIONS := [
	Vector2(560, 350), Vector2(620, 390), Vector2(760, 980),
	Vector2(820, 1030), Vector2(1320, 310), Vector2(1380, 340),
	Vector2(1970, 1030), Vector2(2020, 990), Vector2(2220, 650)
]

func _ready() -> void:
	_create_world_boundaries()
	_create_pond_collision()
	for tree_position in TREE_POSITIONS:
		_create_circle_obstacle(tree_position, 18.0)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, MAP_SIZE), Color("6f9b62"))
	_draw_grass_patches()
	_draw_path()
	_draw_pond()

	for rock_position in ROCK_POSITIONS:
		_draw_rock(rock_position)
	for tree_position in TREE_POSITIONS:
		_draw_tree(tree_position)
	for flower_position in FLOWER_POSITIONS:
		_draw_flower(flower_position)

func _draw_grass_patches() -> void:
	var patches := [
		Rect2(80, 420, 500, 320), Rect2(1880, 310, 560, 300),
		Rect2(580, 1050, 560, 260), Rect2(1420, 70, 480, 250)
	]
	for patch in patches:
		draw_rect(patch, Color("78a66a"), true)

func _draw_path() -> void:
	var path_points := PackedVector2Array([
		Vector2(0, 760), Vector2(430, 680), Vector2(850, 700),
		Vector2(1260, 610), Vector2(1650, 700), Vector2(2050, 650),
		Vector2(2560, 720), Vector2(2560, 900), Vector2(2050, 820),
		Vector2(1650, 860), Vector2(1260, 780), Vector2(850, 860),
		Vector2(430, 830), Vector2(0, 920)
	])
	draw_colored_polygon(path_points, Color("c2a878"))
	draw_polyline(PackedVector2Array([
		Vector2(0, 840), Vector2(430, 755), Vector2(850, 780),
		Vector2(1260, 695), Vector2(1650, 780), Vector2(2050, 735), Vector2(2560, 810)
	]), Color("d7bd8b"), 6.0, true)

func _draw_pond() -> void:
	draw_set_transform(Vector2(1780, 420), 0.0, Vector2(1.55, 0.82))
	draw_circle(Vector2.ZERO, 155.0, Color("496d67"))
	draw_circle(Vector2.ZERO, 140.0, Color("6ba8a2"))
	draw_arc(Vector2.ZERO, 92.0, 0.2, 2.5, 32, Color("9bc9b8"), 4.0, true)
	draw_set_transform(Vector2.ZERO)

func _draw_tree(tree_position: Vector2) -> void:
	draw_circle(tree_position + Vector2(0, 13), 18.0, Color("795b3b"))
	draw_circle(tree_position + Vector2(-18, -8), 34.0, Color("355f45"))
	draw_circle(tree_position + Vector2(17, -13), 38.0, Color("416f4f"))
	draw_circle(tree_position + Vector2(0, -35), 35.0, Color("4d7d55"))

func _draw_rock(rock_position: Vector2) -> void:
	draw_colored_polygon(PackedVector2Array([
		rock_position + Vector2(-22, 14), rock_position + Vector2(-15, -12),
		rock_position + Vector2(8, -22), rock_position + Vector2(25, -5),
		rock_position + Vector2(19, 18)
	]), Color("78827c"))

func _draw_flower(flower_position: Vector2) -> void:
	draw_circle(flower_position, 4.0, Color("f2d36f"))
	for offset in [Vector2(0, -6), Vector2(6, 0), Vector2(0, 6), Vector2(-6, 0)]:
		draw_circle(flower_position + offset, 4.0, Color("f4dbe5"))

func _create_world_boundaries() -> void:
	_create_box_obstacle(Vector2(MAP_SIZE.x * 0.5, -16), Vector2(MAP_SIZE.x, 32))
	_create_box_obstacle(Vector2(MAP_SIZE.x * 0.5, MAP_SIZE.y + 16), Vector2(MAP_SIZE.x, 32))
	_create_box_obstacle(Vector2(-16, MAP_SIZE.y * 0.5), Vector2(32, MAP_SIZE.y))
	_create_box_obstacle(Vector2(MAP_SIZE.x + 16, MAP_SIZE.y * 0.5), Vector2(32, MAP_SIZE.y))

func _create_pond_collision() -> void:
	var body := StaticBody2D.new()
	body.position = Vector2(1780, 420)
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 145.0
	collision.shape = shape
	collision.scale = Vector2(1.55, 0.82)
	body.add_child(collision)
	add_child(body)

func _create_circle_obstacle(obstacle_position: Vector2, radius: float) -> void:
	var body := StaticBody2D.new()
	body.position = obstacle_position
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _create_box_obstacle(obstacle_position: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = obstacle_position
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)
