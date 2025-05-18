extends Node2D  # Alterado para Node2D pois é o nó raiz da sua cena

var player_in_range := false

@onready var area_detection = $Area2D  # Referência ao nó Area2D
@onready var detection_shape = $Area2D/DetectionShape2D  # CollisionShape2D da área

func _ready():
	# Conecta os sinais manualmente (caso não estejam conectados no editor)
	area_detection.body_entered.connect(_on_body_entered)
	area_detection.body_exited.connect(_on_body_exited)

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()
		
func interact():
	var game_node = get_node("/root/Main/Game")
	game_node.show_message("Você pegou uma espada!", 2.5)
	print("Objeto interagido")
	
func _on_body_entered(body):  # Mudado de area_entered para body_entered
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):  # Mudado de area_exited para body_exited
	if body.is_in_group("player"):
		player_in_range = false
