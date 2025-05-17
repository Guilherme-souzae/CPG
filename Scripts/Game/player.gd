extends CharacterBody2D

@export var speed: float = 300.0
var current_dir: String = "none"

func _physics_process(delta):
	player_movement()

	move_and_slide()

func player_movement():
	var input_vector = Vector2.ZERO
	var directions_priority = [
		["move_right", Vector2.RIGHT, "right"],
		["move_left", Vector2.LEFT, "left"],
		["move_down", Vector2.DOWN, "down"],
		["move_up", Vector2.UP, "up"]
	]

	for dir_data in directions_priority:
		if Input.is_action_pressed(dir_data[0]):
			input_vector += dir_data[1]
	
	for dir_data in directions_priority:
		if Input.is_action_pressed(dir_data[0]):
			current_dir = dir_data[2]
			break
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO
