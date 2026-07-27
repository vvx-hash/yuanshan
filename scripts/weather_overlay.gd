extends CanvasLayer

@onready var night_tint: ColorRect = $NightTint

func _ready() -> void:
	GameState.time_changed.connect(_update_light)
	_update_light(GameState.day, GameState.get_hour(), GameState.get_minute())

func _update_light(_day: int, hour: int, minute: int) -> void:
	var current_hour := float(hour) + float(minute) / 60.0
	var darkness := 0.0
	if current_hour < 6.0 or current_hour >= 20.0:
		darkness = 0.52
	elif current_hour < 8.0:
		darkness = lerpf(0.52, 0.0, (current_hour - 6.0) / 2.0)
	elif current_hour >= 18.0:
		darkness = lerpf(0.0, 0.52, (current_hour - 18.0) / 2.0)
	night_tint.color = Color(0.08, 0.13, 0.28, darkness)
