extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

var attacking = false
var last_direction = 1   # 1 = derecha, -1 = izquierda

func _physics_process(delta: float) -> void:

	# --- GRAVEDAD ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- ATAQUE ---
	if Input.is_action_just_pressed("sword") and not attacking:
		_start_attack()
		return  # no dejar que avance el resto del código

	if not attacking:

		# SALTO
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("left", "right")
		velocity.x = direction * SPEED

		if direction != 0:
			last_direction = direction

		$Visual.scale.x = -1 if last_direction < 0 else 1

		if not is_on_floor():
			if velocity.y < 0:
				$Visual/AnimatedSprite2D.play("jump_up")
			elif velocity.y > 0:
				$Visual/AnimatedSprite2D.play("jump_down")
		elif velocity.x != 0:
			$Visual/AnimatedSprite2D.play("run")
		else:
			$Visual/AnimatedSprite2D.play("idle")

	move_and_slide()

func _start_attack():
	attacking = true

	# detener movimiento
	velocity.x = 0

	# poner anim de ataque visible
	$Visual/AnimatedSprite2D.visible = false
	$Visual/ataque.visible = true

	# aplicar flip correcto
	$Visual.scale.x = -1 if last_direction < 0 else 1

	# reproducir anim del ataque
	$Visual/ataque.play("atack")
func _on_ataque_animation_finished():
	if $Visual/ataque.animation == "atack":
		attacking = false

		# restaurar visibilidad
		$Visual/ataque.visible = false
		$Visual/AnimatedSprite2D.visible = true

		# mantener flip correcto
		$Visual.scale.x = -1 if last_direction < 0 else 1


func _on_tp_inicio_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		body.global_position = get_node("/root/main/markers/spawn_point1").global_position


func _on_tp_segunda_vuelta_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		body.global_position = get_node("/root/main/markers/spawn_point2").global_position


func _on_spawn_angel_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		var angel_node = get_node("/root/main/areas/angel") # Ajusta la ruta si es diferente
		angel_node.visible = true
		angel_node.velocidad_actual = angel_node.velocidad_normal
		
func _ready() -> void:
	var camara_1= $Camera2D
	camara_1.make_current()
