extends Node2D

func _draw() -> void:
	_draw_shadow()
	_draw_chimney()
	_draw_walls()
	_draw_roof()
	_draw_door()
	_draw_window(Vector2(-72, 62))
	_draw_window(Vector2(68, 62))
	_draw_porch()

func _draw_shadow() -> void:
	draw_colored_polygon(PackedVector2Array([
		Vector2(-150, 150), Vector2(155, 150),
		Vector2(180, 174), Vector2(-125, 174)
	]), Color(0.16, 0.23, 0.18, 0.35))

func _draw_chimney() -> void:
	draw_rect(Rect2(70, -105, 34, 76), Color("6f4c3b"))
	draw_rect(Rect2(65, -110, 44, 12), Color("4d382f"))

func _draw_walls() -> void:
	draw_rect(Rect2(-130, 0, 260, 150), Color("b78355"))
	for plank_y in range(20, 150, 24):
		draw_line(Vector2(-130, plank_y), Vector2(130, plank_y), Color("966844"), 3.0)
	draw_line(Vector2(-130, 0), Vector2(-130, 150), Color("654632"), 8.0)
	draw_line(Vector2(130, 0), Vector2(130, 150), Color("654632"), 8.0)

func _draw_roof() -> void:
	draw_colored_polygon(PackedVector2Array([
		Vector2(-162, 12), Vector2(-105, -80), Vector2(0, -138),
		Vector2(105, -80), Vector2(162, 12)
	]), Color("59433b"))
	draw_polyline(PackedVector2Array([
		Vector2(-162, 12), Vector2(-105, -80), Vector2(0, -138),
		Vector2(105, -80), Vector2(162, 12)
	]), Color("3e322f"), 8.0, true)
	for roof_y in [-18, -48, -78]:
		draw_line(Vector2(-115 + abs(roof_y), roof_y), Vector2(115 - abs(roof_y), roof_y), Color("755448"), 3.0)

func _draw_door() -> void:
	draw_rect(Rect2(-30, 68, 60, 82), Color("65432f"))
	draw_rect(Rect2(-24, 74, 48, 76), Color("80563a"))
	draw_circle(Vector2(14, 111), 4.0, Color("d7b05b"))

func _draw_window(window_position: Vector2) -> void:
	draw_rect(Rect2(window_position - Vector2(30, 26), Vector2(60, 52)), Color("523d32"))
	draw_rect(Rect2(window_position - Vector2(24, 20), Vector2(48, 40)), Color("8fc2bd"))
	draw_line(window_position + Vector2(0, -20), window_position + Vector2(0, 20), Color("e2d3b0"), 4.0)
	draw_line(window_position + Vector2(-24, 0), window_position + Vector2(24, 0), Color("e2d3b0"), 4.0)
	draw_rect(Rect2(window_position + Vector2(-31, 28), Vector2(62, 10)), Color("4d6b3f"))

func _draw_porch() -> void:
	draw_colored_polygon(PackedVector2Array([
		Vector2(-55, 150), Vector2(55, 150), Vector2(72, 175), Vector2(-72, 175)
	]), Color("8f6b47"))
	for step_y in [158.0, 168.0]:
		draw_line(Vector2(-60, step_y), Vector2(60, step_y), Color("674b38"), 3.0)
