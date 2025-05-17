extends CharacterBody2D

@export var speed: float = 300.0
var current_dir: String = "down"  # direção padrão inicial

func _physics_process(delta):
	player_movement()
	move_and_slide()
	play_anim()

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

func play_anim():
	var anim = $AnimatedSprite2D

	match current_dir:
		"right":
			if velocity != Vector2.ZERO:
				anim.animation = "walk_right"
			else:
				anim.animation = "idle_right"
		"left":
			if velocity != Vector2.ZERO:
				anim.animation = "walk_left"
			else:
				anim.animation = "idle_left"
		"up":
			if velocity != Vector2.ZERO:
				anim.animation = "walk_up"
			else:
				anim.animation = "idle_up"
		"down":
			if velocity != Vector2.ZERO:
				anim.animation = "walk_down"
			else:
				anim.animation = "idle_down"

	if not anim.is_playing():
		anim.play()
