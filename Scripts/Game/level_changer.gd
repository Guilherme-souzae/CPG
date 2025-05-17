extends "res://Scripts/Game/interactable_object.gd"

@export var next_level : PackedScene

func interact():
	get_node("/root/Main").change_game_scene(next_level)
