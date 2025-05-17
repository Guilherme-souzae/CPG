extends CharacterBody2D

@export var enemyData: Resource = null
@export var speed = 100

# Variáveis de movimento
var target = null
var can_see_player = false

func _ready():
	# Conecta os sinais das áreas
	$DetectionArea.connect("body_entered", Callable(self, "_on_DetectionArea_body_entered"))
	$DetectionArea.connect("body_exited", Callable(self, "_on_DetectionArea_body_exited"))
	$CombatArea.connect("body_entered", Callable(self, "_on_CombatArea_body_entered"))

func _physics_process(delta):
	if target and can_see_player:
		# Calcula a direção para o jogador
		var direction = (target.global_position - global_position).normalized()
		
		# Move o inimigo
		position += direction * speed * delta
		
		# Atualiza o RayCast para apontar para o jogador
		$RayCast2D.target_position = to_local(target.global_position)
		$RayCast2D.force_raycast_update()
		
		# Verifica se há obstáculo entre o inimigo e o jogador
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if not collider.is_in_group("player"):
				can_see_player = false
				# Aqui você pode adicionar comportamento quando perde a visão do jogador

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("player"):
		target = body
		$RayCast2D.target_position = to_local(target.global_position)
		$RayCast2D.force_raycast_update()
		
		# Verifica se não há obstáculos imediatamente
		if not $RayCast2D.is_colliding() or $RayCast2D.get_collider().is_in_group("player"):
			can_see_player = true

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		can_see_player = false

func _on_CombatArea_body_entered(body):
	if body.is_in_group("player"):
		print("o monstro te pegou")
		get_node("/root/Main/Battle").setEnemy(enemyData)
		get_node("/root/Main").switch_to_battle()
		queue_free()
