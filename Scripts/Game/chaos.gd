extends "res://Scripts/Game/interactable_object.gd"

var hasInteracted: bool = false

func interact():
	if (!hasInteracted):
		PlayerStats.current_embers = 100
		PlayerStats.update()
		hasInteracted = true
	game_node.show_message(frase, 2.5)
	print("Estatua interagida")
	print("HP: %d/%d" % [PlayerStats.current_health, PlayerStats.max_health])
	print("Embers %d/%d" % [PlayerStats.current_embers, PlayerStats.max_embers])
