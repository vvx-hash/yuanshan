extends CharacterBody2D

@export var speed := 180.0

@onready var avatar: Sprite2D = $Avatar

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	if absf(velocity.x) > 1.0:
		avatar.flip_h = velocity.x < 0.0
	move_and_slide()
