extends Control

signal textbox_closed
signal enemy_dead
signal player_dead

@export var enemy: Resource = null

var current_player_health = 0
var current_player_embers = 0
var current_enemy_health = 0
var isBlocking = false
var preparedAction = false

func _ready():
	$TextBox.hide()
	$Blackscreen.hide()
	$Background.show()
	$Deathscreen.hide()
	
	setEnemy(enemy)

func setHealth(current, maximum):
	$PlayerPanel/PlayerData/PlayerHPLabel.text = "HP:%d/%d" % [current, maximum]
func setEmbers(current, maximum):
	$PlayerPanel/PlayerData/PlayerEmbersLabel.text = "Embers:%d/%d" % [current, maximum]
	
func setEnemy(newenemy):
	enemy = newenemy
	$EnemyContainer/Enemy.texture = enemy.texture
	current_enemy_health = enemy.health
	

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		$TextBox.hide()
		emit_signal("textbox_closed")

func _on_attack_pressed() -> void:
	var attackroll = randi() % 20
	$PlayerPanel.hide()
	$ActionPanel.hide()
	display_text("Você atacou a %s!" % enemy.name)
	await textbox_closed
	$PlayerPanel.show()
	$ActionPanel.show()
	if (attackroll <= PlayerStats.margin):
		$PlayerPanel.hide()
		$ActionPanel.hide()
		musicPause()
		$HitSFX.play()
		await $HitSFX.finished
		musicPlayer()
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		display_text(enemy.crippled)
		await textbox_closed
		$PlayerPanel.show()
		$ActionPanel.show()
		current_enemy_health = max(0, current_enemy_health-(2*PlayerStats.attack_damage))
		if (current_enemy_health == 0):
			emit_signal("enemy_dead")
		else:
			enemyTurn()
			pass
		print(current_enemy_health)
	elif ( attackroll < PlayerStats.accuracy-enemy.evasion):
		$PlayerPanel.hide()
		$ActionPanel.hide()
		musicPause()
		$HitSFX.play()
		await $HitSFX.finished
		musicPlayer()
		$AnimationPlayer.play("enemy_damaged")
		await $AnimationPlayer.animation_finished
		display_text(enemy.hurt)
		await textbox_closed
		$PlayerPanel.show()
		$ActionPanel.show()
		current_enemy_health = max(0, current_enemy_health-PlayerStats.attack_damage)
		if (current_enemy_health == 0):
			emit_signal("enemy_dead")
		else:
			enemyTurn()
			print("ded")
		print(current_enemy_health)
	else:
		display_text(enemy.dodge)
		$PlayerPanel.hide()
		$ActionPanel.hide()
		await textbox_closed
		$PlayerPanel.show()
		$ActionPanel.show()
		enemyTurn()


func _on_block_pressed() -> void:
	isBlocking = true
	enemyTurn()

func _on_run_pressed() -> void:
	var runroll = randi()%20
	if (runroll<enemy.runchance):
		PlayerStats.current_health = current_player_health
		PlayerStats.current_embers = current_player_embers
		PlayerStats.update()
		display_text("Existe escapatória.")
		$PlayerPanel.hide()
		$ActionPanel.hide()
		await textbox_closed
		Global.signal_end_combat(false)
		get_node("/root/Main").switch_to_game()
	else:
		$PlayerPanel.hide()
		$ActionPanel.hide()
		display_text("Falha ao tentar escapar, será que há escapatória?")
		await textbox_closed
		$PlayerPanel.show()
		$ActionPanel.show()
		enemyTurn()

func enemyTurn():
	var actionroll = randi()%20
	var enemyroll = randi()%20
	var hitChance 
	if (isBlocking):
		hitChance = enemy.accuracy-(2*PlayerStats.evasion)
	else:
		hitChance = enemy.accuracy-PlayerStats.evasion
	if (actionroll < 3 or preparedAction == true):
		specialActions(enemyroll, hitChance)
	else:
		if (enemyroll <= enemy.margin):
			display_text(enemy.brutal)
			$PlayerPanel.hide()
			$ActionPanel.hide()
			await textbox_closed
			$PlayerPanel.show()
			$ActionPanel.show()
			current_player_health = max(0, current_player_health-(2*enemy.attack))
			if (current_player_health == 0):
				emit_signal("player_dead")
			setHealth(current_player_health, PlayerStats.max_health)
		elif (enemyroll < hitChance):
			current_player_health = max(0, current_player_health-enemy.attack)
			display_text(enemy.hit)
			$PlayerPanel.hide()
			$ActionPanel.hide()
			await textbox_closed
			$PlayerPanel.show()
			$ActionPanel.show()
			setHealth(current_player_health, PlayerStats.max_health)
			if (current_player_health == 0):
				emit_signal("player_dead")
		else:
			display_text(enemy.miss)
			$PlayerPanel.hide()
			$ActionPanel.hide()
			await textbox_closed
			$PlayerPanel.show()
			$ActionPanel.show()
			
	isBlocking = false
 
func specialActions(attackroll, hitchance):
	match enemy.special_move:
		"decapitate":
			if(preparedAction == false):
				preparedAction = true
				display_text("A centopeia estala suas grandes mandíbulas...")
				$PlayerPanel.hide()
				$ActionPanel.hide()
				await textbox_closed
				$PlayerPanel.show()
				$ActionPanel.show()
			else:
				if (attackroll <= enemy.margin and isBlocking == false):
					display_text("A centopeia abre sua mandíbula e te decapita...")
					$PlayerPanel.hide()
					$ActionPanel.hide()
					await textbox_closed
					$PlayerPanel.show()
					$ActionPanel.show()
					current_player_health = max(0, current_player_health-120)
					setHealth(current_player_health, PlayerStats.max_health)
				elif (attackroll < hitchance/2 and isBlocking == false):
					current_player_health = max(0, current_player_health-60)
					display_text("A centopeia tenta te decapitar talhando seu corpo.")
					$PlayerPanel.hide()
					$ActionPanel.hide()
					await textbox_closed
					$PlayerPanel.show()
					$ActionPanel.show()
					setHealth(current_player_health, PlayerStats.max_health)
				else:
					display_text("Você esquiva do bote da centopeia!")
					$PlayerPanel.hide()
					$ActionPanel.hide()
					await textbox_closed
					$PlayerPanel.show()
					$ActionPanel.show()
				preparedAction = false
		"bite":
			if (attackroll <= enemy.margin):
				display_text("O Zumbi te morde brutalmente, ele está reinvigorado...")
				$PlayerPanel.hide()
				$ActionPanel.hide()
				await textbox_closed
				$PlayerPanel.show()
				$ActionPanel.show()
				current_player_health = max(0, current_player_health-40)
				current_enemy_health = max(current_enemy_health+40, 50)
				setHealth(current_player_health, PlayerStats.max_health)
			elif (attackroll < hitchance+10):
				current_player_health = max(0, current_player_health-20)
				display_text("O zumbi te morde curando parte de sua vida.")
				$PlayerPanel.hide()
				$ActionPanel.hide()
				await textbox_closed
				$PlayerPanel.show()
				$ActionPanel.show()
				setHealth(current_player_health, PlayerStats.max_health)
			else:
				display_text("O zumbi erra seu bote!")
				$PlayerPanel.hide()
				$ActionPanel.hide()
				await textbox_closed
				$PlayerPanel.show()
				$ActionPanel.show()
		"skydive":
			if(preparedAction == false):
				preparedAction = true
				display_text("A gárgula sorri e depois levanta voo...")
				$PlayerPanel.hide()
				$ActionPanel.hide()
				await textbox_closed
				$PlayerPanel.show()
				$ActionPanel.show()
			else:
				if (isBlocking == false):
					display_text("A gárgula gargalha enquanto cai em cima de você, esmagando todos seus ossos...")
					$PlayerPanel.hide()
					$ActionPanel.hide()
					await textbox_closed
					$PlayerPanel.show()
					$ActionPanel.show()
					current_player_health = max(0, current_player_health-current_enemy_health)
					setHealth(current_player_health, PlayerStats.max_health)
					current_enemy_health = max(0, current_enemy_health-20)
				else:
					display_text("Você se esquiva de um destino terrível.")
					$PlayerPanel.hide()
					$ActionPanel.hide()
					await textbox_closed
					$PlayerPanel.show()
					$ActionPanel.show()
					current_enemy_health = max(0, current_enemy_health-20)
				preparedAction = false
		"none":
			display_text("O coelho respira amedrontado...")
			$PlayerPanel.hide()
			$ActionPanel.hide()
			await textbox_closed
			$PlayerPanel.show()
			$ActionPanel.show()
	if (current_enemy_health == 0):
		emit_signal("enemy_dead")
	elif (current_player_health == 0):
		emit_signal("player_dead")
	

func _on_draw() -> void:
	print("I entered the combat.")
	$Deathscreen.hide()
	$Blackscreen.show()
	PlayerStats.update()
	current_player_health = PlayerStats.current_health
	current_player_embers = PlayerStats.current_embers
	setHealth(current_player_health, PlayerStats.max_health)
	setEmbers(current_player_embers, PlayerStats.max_embers)
	display_text(enemy.introduction)
	
	match enemy.name:
		"centopeia":
			$CentipedeSFX.play()
			await $CentipedeSFX.finished
		"perdido":
			$ZombieSFX.play()
			await $ZombieSFX.finished
		"Gárgula":
			$GargoylleIntroSFX.play()
			await $GargoylleIntroSFX.finished
			
	musicPlayer()
	
	await textbox_closed
	$Blackscreen.hide()
	$PlayerPanel.show()
	$ActionPanel.show()
	
	setHealth(current_player_health, PlayerStats.max_health)


func _on_enemy_dead() -> void:
	PlayerStats.current_health = current_player_health
	PlayerStats.current_embers = current_player_embers + enemy.reward
	$Blackscreen.show()
	display_text(enemy.death)
	$PlayerPanel.hide()
	$ActionPanel.hide()
	await textbox_closed
	$Blackscreen.hide()
	$PlayerPanel.show()
	$ActionPanel.show()
	Global.signal_end_combat(true)
	get_node("/root/Main").switch_to_game()


func _on_player_dead() -> void:
	$Deathscreen.show()
	$PlayerPanel.hide()
	$ActionPanel.hide()
	await textbox_closed
	get_node("/root/Main").switch_to_game() #Placeholder
	
func musicPlayer():
	match enemy.name:
		"Gárgula":
			if ($GargoylleBattletheme.stream_paused):
				$GargoylleBattletheme.stream_paused = false
			else:
				$GargoylleBattletheme.play()
		_:
			if ($GenericBattletheme.stream_paused):
				$GenericBattletheme.stream_paused = false
			else:
				$GenericBattletheme.play()



func _on_hidden() -> void:
	$GenericBattletheme.stop()
	$GargoylleBattletheme.stop()

func musicPause():
	match enemy.name:
		"Gárgula":
			if(!$GargoylleBattletheme.stream_paused):
				$GargoylleBattletheme.stream_paused = true
		_:
			if(!$GenericBattletheme.stream_paused):
				$GenericBattletheme.stream_paused = true
