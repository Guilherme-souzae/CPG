extends Control

func _ready():
	$AnimationPlayer.play("fade_out")
	# Espera a animação terminar (substitua "fade_out" pela duração da sua animação, se quiser usar o temporizador)
	await $AnimationPlayer.animation_finished
	# Troca para a cena principal (ajuste o caminho conforme seu projeto)
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
