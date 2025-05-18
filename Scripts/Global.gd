extends Node

signal combat_ran
signal combat_start(enemy)
signal combat_won(enemy)
signal change_pfp
signal final_boss

var currentEnemy = null

func signal_combat_start(enemy):
	currentEnemy = enemy
	emit_signal("combat_start")

func signal_end_combat(won):
	if(won):
		emit_signal("combat_won", currentEnemy)
		currentEnemy = null
	else:
		emit_signal("combat_ran")
func changePfp():
	emit_signal("change_pfp")
	
func signal_final_boss():
	emit_signal("final_boss")
