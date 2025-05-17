extends "res://Scripts/Game/interactable_object.gd"

@export var enemy: Resource = null

func interact():
	get_node("/root/Main/Battle").setEnemy(enemy)
	get_node("/root/Main").switch_to_battle()
