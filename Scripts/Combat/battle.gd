extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var isBlocking = false

func _ready():
	
	$TextBox.hide()
	$Blackscreen.hide()
	
	$Blackscreen.show()
	display_text(enemy.introduction)
	await textbox_closed
	$EnemyContainer/Enemy.texture = enemy.texture
	$Blackscreen.hide()
	current_player_health = PlayerStats.current_health
	current_enemy_health = enemy.health
	
	setHealth(current_player_health, PlayerStats.max_health)

func setHealth(current, maximum):
	$PlayerPanel/PlayerData/PlayerInfo.text = "HP:%d/%d" % [current, maximum]

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		$TextBox.hide()
		emit_signal("textbox_closed")

func _on_attack_pressed() -> void:
	var attackroll = randi() % 20
	display_text("Você atacou a %s!" % enemy.name)
	await textbox_closed
	if (attackroll == PlayerStats.margin):
		display_text(enemy.crippled)
		await textbox_closed
		current_enemy_health = max(0, current_enemy_health-(2*PlayerStats.attack_damage))
		print(current_enemy_health)
	elif ( attackroll < PlayerStats.accuracy-enemy.evasion):
		display_text(enemy.hurt)
		await textbox_closed
		current_enemy_health = max(0, current_enemy_health-PlayerStats.attack_damage)
		print(current_enemy_health)
	else:
		display_text(enemy.dodge)
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
	var hitChance 
	if (isBlocking):
		hitChance = enemy.accuracy-(2*PlayerStats.evasion)
	else:
		hitChance = enemy.accuracy-PlayerStats.evasion
	if (enemyroll == enemy.margin):
		display_text(enemy.brutal)
		await textbox_closed
		current_player_health = max(0, current_player_health-(2*enemy.attack))
		setHealth(current_player_health, PlayerStats.max_health)
	elif (enemyroll < hitChance):
		current_player_health = max(0, current_player_health-enemy.attack)
		display_text(enemy.hit)
		await textbox_closed
		setHealth(current_player_health, PlayerStats.max_health)
	else:
		display_text(enemy.miss)
		await textbox_closed
	isBlocking = false
