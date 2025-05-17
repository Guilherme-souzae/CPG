extends Node2D

@onready var game: Node2D = $Game
@onready var battle: Control = $Battle

func _ready():
	# Começa com a cena Game ativa e Battle desativada
	game.show()
	game.set_process(true)
	
	battle.hide()
	battle.set_process(false)

func set_active_scene(active_scene: Node):
	# Primeiro desativa tudo
	game.hide()
	game.set_process(false)
	
	battle.hide()
	battle.set_process(false)
	
	# Depois ativa apenas a cena desejada
	active_scene.show()
	active_scene.set_process(true)

	# Ajusta a propriedade de processamento de input para Controls
	if active_scene is Control:
		active_scene.set_process_input(true)
		active_scene.set_process_unhandled_input(true)
		
func switch_to_game():
	set_active_scene(game)

func switch_to_battle():
	set_active_scene(battle)
