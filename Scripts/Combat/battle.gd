extends Control

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0

func _ready():
	$Enemy.texture = enemy.texture
	current_player_health = PlayerStats.current_health
	current_enemy_health = enemy.health

func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text


func _on_attack_pressed() -> void:
	display_text("You attack the %s!" % enemy.name)
	current_enemy_health = max(0, current_enemy_health-PlayerStats.attack_damage)
	print(current_enemy_health)
