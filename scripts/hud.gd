extends CanvasLayer

@onready var day_label: Label = $TopBar/Day
@onready var time_label: Label = $TopBar/Time
@onready var weather_label: Label = $TopBar/Weather
@onready var inventory_panel: Panel = $InventoryPanel
@onready var inventory_items: Label = $InventoryPanel/Items
@onready var message_label: Label = $Message

var message_timer := 0.0

func _ready() -> void:
	GameState.time_changed.connect(_update_time)
	GameState.weather_changed.connect(_update_weather)
	GameState.inventory_changed.connect(_update_inventory)
	GameState.status_message.connect(_show_message)
	_update_time(GameState.day, GameState.get_hour(), GameState.get_minute())
	_update_weather(GameState.weather)
	_update_inventory()

func _process(delta: float) -> void:
	if message_timer > 0.0:
		message_timer -= delta
		if message_timer <= 0.0:
			message_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory_panel.visible = not inventory_panel.visible
		get_viewport().set_input_as_handled()

func _update_time(current_day: int, hour: int, minute: int) -> void:
	day_label.text = "第 %d 天" % current_day
	time_label.text = "%02d:%02d" % [hour, minute]

func _update_weather(_weather: String) -> void:
	weather_label.text = GameState.get_weather_name()

func _update_inventory() -> void:
	if GameState.inventory.is_empty():
		inventory_items.text = "背包还是空的\n\n去山谷里走走吧。"
		return
	var lines: PackedStringArray = []
	for item_name in GameState.inventory:
		lines.append("%s  ×%d" % [item_name, int(GameState.inventory[item_name])])
	inventory_items.text = "\n".join(lines)

func _show_message(message: String) -> void:
	message_label.text = message
	message_label.visible = true
	message_timer = 2.5
