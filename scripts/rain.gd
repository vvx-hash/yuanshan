extends Node2D

const DROP_COUNT := 130

var drops: Array[Vector2] = []
var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.seed = 4701
	for index in DROP_COUNT:
		drops.append(Vector2(random.randf_range(0.0, 1280.0), random.randf_range(0.0, 720.0)))
	GameState.weather_changed.connect(_on_weather_changed)
	_on_weather_changed(GameState.weather)

func _process(delta: float) -> void:
	if not visible:
		return
	for index in drops.size():
		drops[index] += Vector2(-170.0, 560.0) * delta
		if drops[index].y > 740.0:
			drops[index] = Vector2(random.randf_range(0.0, 1450.0), -20.0)
	queue_redraw()

func _draw() -> void:
	for drop in drops:
		draw_line(drop, drop + Vector2(-8, 24), Color(0.72, 0.86, 0.94, 0.58), 2.0)

func _on_weather_changed(next_weather: String) -> void:
	visible = next_weather == "rain"
	queue_redraw()
