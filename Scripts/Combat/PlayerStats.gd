extends Node

var current_health = 75
var max_health = 100
var defense = 0
var attack_damage = 5
var accuracy = 10 #From 0 to infinity, each point is about 5% hit chance
var margin = 0 #Critical margin
var evasion = 5 #From 0 to infinity, each point is about 5% dodge chance
var current_embers = 100
var max_embers = 100

func update():
	@warning_ignore("integer_division")
	max_health = 100 - (current_embers/2)
	current_health = max(0, max_health)
	@warning_ignore("integer_division")
	attack_damage = current_embers/10
	@warning_ignore("integer_division")
	evasion = current_embers/10
	@warning_ignore("integer_division")
	accuracy = current_embers/5
	@warning_ignore("integer_division")
	margin = current_embers/100
	
