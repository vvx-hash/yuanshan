extends Area2D

@export var item_id := "berry_01"
@export var item_name := "野莓"
@export var amount := 1

var animation_time := 0.0

func _ready() -> void:
	if GameState.is_item_collected(item_id):
		queue_free()
		return
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	animation_time += delta
	queue_redraw()

func _draw() -> void:
	var bob := sin(animation_time * 2.4) * 2.0
	draw_line(Vector2(0, 14 + bob), Vector2(0, -6 + bob), Color("416b3e"), 4.0)
	draw_circle(Vector2(-7, -8 + bob), 7.0, Color("b94f62"))
	draw_circle(Vector2(7, -6 + bob), 7.0, Color("a84058"))
	draw_circle(Vector2(0, -16 + bob), 7.0, Color("c65a6c"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0, -20 + bob), Vector2(13, -27 + bob), Vector2(7, -16 + bob)
	]), Color("54814e"))

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	GameState.collect_item(item_id, item_name, amount)
	queue_free()
