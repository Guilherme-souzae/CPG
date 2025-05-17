extends Control

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0

func _ready():
	$EnemyContainer/Enemy.texture = enemy.texture
	current_player_health = PlayerStats.current_health
	current_enemy_health = enemy.health

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text


func _on_attack_pressed() -> void:
	var roll = randi() % 20
	display_text("Você atacou a %s!" % enemy.name)
	if (roll == 0):
		display_text("A %s recebe um golpe brutal!" % enemy.name)
		current_enemy_health = max(0, current_enemy_health-(2*PlayerStats.attack_damage))
		print(current_enemy_health)
	elif ( roll < (PlayerStats.accuracy-enemy.evasion)/5):
		current_enemy_health = max(0, current_enemy_health-PlayerStats.attack_damage)
		display_text("A %s foi ferida." % enemy.name)
		print(current_enemy_health)
	else:
		display_text("A %s esquiva..." % enemy.name)
		


func _on_run_pressed() -> void:
	get_node("/root/Main").switch_to_game()
