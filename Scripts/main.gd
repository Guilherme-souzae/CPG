extends Node2D

@export var initial_game_scene: PackedScene
@onready var battle: Control = $Battle
@onready var game_container: Node = $Game

var current_game: Node2D = null
var player_camera: Camera2D = null

func _ready():
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	load_game_scene(initial_game_scene)
	switch_to_game()

func load_game_scene(new_scene: PackedScene):
	if current_game:
		game_container.remove_child(current_game)
		current_game.queue_free()
	
	current_game = new_scene.instantiate()
	game_container.add_child(current_game)
	current_game.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Encontra a câmera do jogador
	find_player_camera()
	
	if current_game.has_signal("battle_started"):
		current_game.connect("battle_started", switch_to_battle)

func find_player_camera():
	# Busca recursivamente pela câmera do jogador
	var player = current_game.find_child("Player") # Assumindo que o nó se chama "Player"
	if player:
		player_camera = player.find_child("Camera2D") # Assumindo que a câmera é filha direta do Player
	else:
		push_warning("Nó Player não encontrado na cena Game")

func set_active_scene(active_scene: Node):
	game_container.hide()
	battle.hide()
	active_scene.show()
	
	# Controle da câmera
	if player_camera:
		player_camera.enabled = (active_scene == game_container)
	
	if active_scene == battle:
		get_tree().paused = true
	else:
		get_tree().paused = false

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
