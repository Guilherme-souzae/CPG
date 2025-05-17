extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var isBlocking = false
var currentEvasion

func _ready():
	$EnemyContainer/Enemy.texture = enemy.texture
	display_text(enemy.introduction)
	current_player_health = PlayerStats.current_health
	currentEvasion = PlayerStats.evasion
	current_enemy_health = enemy.health
	
	setHealth(current_player_health, PlayerStats.max_health)

func setHealth(current, max):
	$PlayerPanel/PlayerData/PlayerInfo.text = "HP:%d/%d" % [current, max]

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		emit_signal("textbox_closed")

func _on_attack_pressed() -> void:
	var attackroll = randi() % 20
	display_text("Você atacou a %s!" % enemy.name)
	await textbox_closed
	if (attackroll == 0):
		display_text("A %s recebe um golpe brutal!" % enemy.name)
		await textbox_closed
		current_enemy_health = max(0, current_enemy_health-(2*PlayerStats.attack_damage))
		print(current_enemy_health)
	elif ( attackroll < PlayerStats.accuracy-enemy.evasion):
		display_text("A %s foi ferida." % enemy.name)
		await textbox_closed
		current_enemy_health = max(0, current_enemy_health-PlayerStats.attack_damage)
		print(current_enemy_health)
	else:
		display_text("A %s esquiva..." % enemy.name)
		await textbox_closed
	enemyTurn()

func _on_block_pressed() -> void:
	isBlocking = true
	enemyTurn()

func _on_run_pressed() -> void:
	display_text("Escapou com sucesso.")
	await textbox_closed
	get_node("/root/Main").switch_to_game()

func enemyTurn():
	var enemyroll = randi() % 20
	if (isBlocking):
		currentEvasion = currentEvasion*2
	if (enemyroll == 0):
		display_text("A %s desfere um golpe brutal!" % enemy.name)
		await textbox_closed
		current_player_health = max(0, current_player_health-(2*enemy.attack))
		setHealth(current_player_health, PlayerStats.max_health)
	elif (enemyroll < enemy.accuracy-PlayerStats.evasion):
		current_player_health = max(0, current_player_health-enemy.attack)
		display_text("A %s o feriu." % enemy.name)
		await textbox_closed
		setHealth(current_player_health, PlayerStats.max_health)
	else:
		display_text("A %s erra seu ataque." % enemy.name)
		await textbox_closed
	currentEvasion = PlayerStats.evasion
	isBlocking = false
