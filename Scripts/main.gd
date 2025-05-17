extends Node2D

@onready var game: Node2D = $Game
@onready var battle: Control = $Battle

func _ready():
	# Configura os modos de processamento antes de qualquer operação
	battle.process_mode = Node.PROCESS_MODE_ALWAYS  # A interface de combate sempre processa
	game.process_mode = Node.PROCESS_MODE_INHERIT  # A cena de exploração segue o estado global
	
	# Começa com a cena Game ativa e Battle desativada
	switch_to_game()

func set_active_scene(active_scene: Node):
	# Primeiro desativa tudo
	game.hide()
	battle.hide()
	
	# Depois ativa apenas a cena desejada
	active_scene.show()
	
	# Ajusta o estado de pausa global
	if active_scene == battle:
		get_tree().paused = true  # Pausa o jogo mas a batalha continua funcionando
	else:
		get_tree().paused = false
		
	# Garante que os inputs funcionem para a cena de batalha
	if active_scene is Control:
		active_scene.set_process_input(true)
		active_scene.set_process_unhandled_input(true)

func switch_to_game():
	set_active_scene(game)

func switch_to_battle():
	set_active_scene(battle)
