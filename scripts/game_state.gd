extends Node

signal time_changed(day: int, hour: int, minute: int)
signal weather_changed(weather: String)
signal inventory_changed
signal status_message(message: String)

const SAVE_PATH := "user://yuanshan_save.json"
const MINUTES_PER_REAL_SECOND := 1.5

var day := 1
var time_minutes := 7.0 * 60.0
var weather := "clear"
var weather_timer := 70.0
var inventory: Dictionary = {}
var collected_items: Dictionary = {}
var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.seed = 20260727
	_ensure_input_actions()

func _process(delta: float) -> void:
	var previous_minute := int(time_minutes)
	time_minutes += delta * MINUTES_PER_REAL_SECOND
	if time_minutes >= 1440.0:
		time_minutes -= 1440.0
		day += 1
	if int(time_minutes) != previous_minute:
		time_changed.emit(day, get_hour(), get_minute())

	weather_timer -= delta
	if weather_timer <= 0.0:
		weather_timer = random.randf_range(65.0, 110.0)
		set_weather("rain" if random.randf() < 0.45 else "clear")

func get_hour() -> int:
	return int(time_minutes) / 60

func get_minute() -> int:
	return int(time_minutes) % 60

func get_weather_name() -> String:
	return "小雨" if weather == "rain" else "晴朗"

func set_weather(next_weather: String) -> void:
	if weather == next_weather:
		return
	weather = next_weather
	weather_changed.emit(weather)
	status_message.emit("天气变成了%s" % get_weather_name())

func collect_item(item_id: String, item_name: String, amount: int = 1) -> void:
	if collected_items.has(item_id):
		return
	collected_items[item_id] = true
	inventory[item_name] = int(inventory.get(item_name, 0)) + amount
	inventory_changed.emit()
	status_message.emit("拾取了 %s ×%d" % [item_name, amount])

func is_item_collected(item_id: String) -> bool:
	return collected_items.has(item_id)

func save_game(player_position: Vector2) -> bool:
	var save_data := {
		"day": day,
		"time_minutes": time_minutes,
		"weather": weather,
		"weather_timer": weather_timer,
		"inventory": inventory,
		"collected_items": collected_items.keys(),
		"player_x": player_position.x,
		"player_y": player_position.y
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		status_message.emit("保存失败")
		return false
	file.store_string(JSON.stringify(save_data))
	status_message.emit("游戏已保存")
	return true

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		status_message.emit("存档无法读取")
		return {}
	var save_data: Dictionary = parsed
	day = int(save_data.get("day", 1))
	time_minutes = float(save_data.get("time_minutes", 420.0))
	weather = String(save_data.get("weather", "clear"))
	weather_timer = float(save_data.get("weather_timer", 70.0))
	inventory = save_data.get("inventory", {}) as Dictionary
	collected_items.clear()
	var saved_items: Array = save_data.get("collected_items", []) as Array
	for item_id in saved_items:
		collected_items[String(item_id)] = true
	inventory_changed.emit()
	time_changed.emit(day, get_hour(), get_minute())
	weather_changed.emit(weather)
	status_message.emit("已读取存档")
	return {
		"player_position": Vector2(
			float(save_data.get("player_x", 640.0)),
			float(save_data.get("player_y", 720.0))
		)
	}

func _ensure_input_actions() -> void:
	_add_key_action("toggle_inventory", KEY_TAB)
	_add_key_action("quick_save", KEY_F9)
	_add_key_action("quick_load", KEY_F10)

func _add_key_action(action_name: StringName, keycode: Key) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	if not InputMap.action_has_event(action_name, event):
		InputMap.action_add_event(action_name, event)
