extends Node

signal combat_ran
signal combat_won
signal change_pfp

func signal_end_combat(won):
	if(won):
		emit_signal("combat_won")
	else:
		emit_signal("combat_ran")
func changePfp():
	emit_signal("change_pfp")
