extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	var loaded_data := GameState.load_game()
	if loaded_data.has("player_position"):
		player.global_position = loaded_data["player_position"] as Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_save"):
		GameState.save_game(player.global_position)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("quick_load"):
		var loaded_data := GameState.load_game()
		if loaded_data.has("player_position"):
			player.global_position = loaded_data["player_position"] as Vector2
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and is_instance_valid(player):
		GameState.save_game(player.global_position)
		get_tree().quit()
