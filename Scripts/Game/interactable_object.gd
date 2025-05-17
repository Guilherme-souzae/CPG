extends Area2D

var player_in_range := false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()
		
func interact():
	print("Objeto interagido")
	
func _on_area_entered(area):
	if area.is_in_group("player"):
		player_in_range = true

func _on_area_exited(area):
	if area.is_in_group("player"):
		player_in_range = false
