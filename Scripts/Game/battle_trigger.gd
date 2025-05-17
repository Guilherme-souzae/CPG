extends "res://Scripts/Game/interactable_object.gd"

func interact():
	get_node("/root/Main").switch_to_battle()
