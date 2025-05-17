extends Node2D

@export var initial_game_scene: PackedScene  # Defina sua cena Game base ou Level1 no inspector
@onready var battle: Control = $Battle
@onready var game_container: Node = $Game  # Agora é um container para a fase atual

var current_game: Node2D = null  # Vai armazenar a cena Game atual

func _ready():
	# Configura os modos de processamento
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Carrega a cena inicial
	load_game_scene(initial_game_scene)
	switch_to_game()

func load_game_scene(new_scene: PackedScene):
	# Remove a cena atual se existir
	if current_game:
		game_container.remove_child(current_game)
		current_game.queue_free()
	
	# Instancia e adiciona a nova cena
	current_game = new_scene.instantiate()
	game_container.add_child(current_game)
	
	# Mantém o mesmo process mode da lógica original
	current_game.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Conecta os sinais necessários (mantendo compatibilidade)
	if current_game.has_signal("battle_started"):
		current_game.connect("battle_started", switch_to_battle)

func set_active_scene(active_scene: Node):
	# Primeiro desativa tudo (mantendo a lógica original)
	game_container.hide()
	battle.hide()
	
	# Depois ativa apenas a cena desejada
	active_scene.show()
	
	# Ajusta o estado de pausa global (igual ao original)
	if active_scene == battle:
		get_tree().paused = true
	else:
		get_tree().paused = false
		
	# Garante inputs para a cena de batalha (igual ao original)
	if active_scene is Control:
		active_scene.set_process_input(true)
		active_scene.set_process_unhandled_input(true)

# Mantidas exatamente como no original
func switch_to_game():
	set_active_scene(game_container)

func switch_to_battle():
	set_active_scene(battle)

# Nova função para trocar de fase quando necessário
func change_game_scene(new_scene: PackedScene):
	load_game_scene(new_scene)
	switch_to_game()
