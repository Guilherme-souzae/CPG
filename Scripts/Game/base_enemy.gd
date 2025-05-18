extends CharacterBody2D

@export var enemySprite: Array[Texture2D]
@export var enemyDeath: Texture2D
@export var enemyData: Resource = null
@export var speed = 100

# Variáveis de movimento
var target = null
var can_see_player = false
var last_direction = 0  # 0=baixo, 1=direita, 2=esquerda, 3=cima

func _ready():
	# Conecta os sinais das áreas
	$Sprite2D.texture = enemySprite[0]
	$DetectionArea.connect("body_entered", Callable(self, "_on_DetectionArea_body_entered"))
	$DetectionArea.connect("body_exited", Callable(self, "_on_DetectionArea_body_exited"))
	$CombatArea.connect("body_entered", Callable(self, "_on_CombatArea_body_entered"))
	Global.connect("combat_ran", Callable(self, "_on_combat_ran"))
	Global.connect("combat_won", Callable(self, "_on_combat_won"))

func _physics_process(delta):
	if target and can_see_player:
		# Calcula a direção para o jogador
		var direction = (target.global_position - global_position).normalized()
		
		# Move o inimigo
		position += direction * speed * delta
		
		# Determina a direção predominante para atualizar o sprite
		update_sprite_direction(direction)
		
		# Atualiza o RayCast para apontar para o jogador
		$RayCast2D.target_position = to_local(target.global_position)
		$RayCast2D.force_raycast_update()
		
		# Verifica se há obstáculo entre o inimigo e o jogador
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if not collider.is_in_group("player"):
				can_see_player = false

func update_sprite_direction(direction: Vector2):
	if enemySprite.size() == 1:
		$Sprite2D.texture = enemySprite[0]
		return

	if abs(direction.x) > abs(direction.y):
		# Movimento horizontal predominante
		if direction.x > 0:
			# Direita
			if last_direction != 1 and enemySprite.size() > 1:
				$Sprite2D.texture = enemySprite[1]
				last_direction = 1
		elif last_direction != 2 and enemySprite.size() > 2:
			$Sprite2D.texture = enemySprite[2]
			last_direction = 2
	else:
		# Movimento vertical predominante
		if direction.y > 0:
			# Baixo
			if last_direction != 0 and enemySprite.size() > 0:
				$Sprite2D.texture = enemySprite[0]
				last_direction = 0
		elif last_direction != 3 and enemySprite.size() > 3:
			$Sprite2D.texture = enemySprite[3]
			last_direction = 3

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

func _on_combat_ran():
	get_node("CombatArea/CollisionShape2D").disabled = true
	get_node("DetectionArea/CollisionShape2D").disabled = true
	$RunTimer.start(1.0)
	await $RunTimer.timeout
	get_node("CombatArea/CollisionShape2D").disabled = false
	get_node("DetectionArea/CollisionShape2D").disabled = false

func _on_combat_won():
	$Sprite2D.texture = enemyDeath
	get_node("CombatArea/CollisionShape2D").disabled = true
	get_node("DetectionArea/CollisionShape2D").disabled = true
