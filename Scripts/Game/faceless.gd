extends "res://Scripts/Game/interactable_object.gd"

func interact():
	if (PlayerStats.current_embers <= 100):
		PlayerStats.current_embers = max(0, PlayerStats.current_embers+10)
		PlayerStats.update()
		PlayerStats.current_health = max(PlayerStats.current_health+50, PlayerStats.max_health)
		PlayerStats.update()
	game_node.show_message(frase, 2.5)
	print("Estatua interagida")
	print("HP: %d/%d" % [PlayerStats.current_health, PlayerStats.max_health])
	print("Embers %d/%d" % [PlayerStats.current_embers, PlayerStats.max_embers])
