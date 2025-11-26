extends CharacterBody2D

var SPEED = 125.0
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
			$music_and_sounds/jump.play()

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
	$music_and_sounds/slash.play()
	$Visual/ataque/attack_colider/CollisionShape2D.disabled =false;

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
	if $Visual/ataque.animation == "atack" or $Visual/ataque.animation=="knockback" :
		$Visual/ataque/attack_colider/CollisionShape2D.disabled=true;
		attacking = false

		# restaurar visibilidad
		$Visual/ataque.visible = false
		$Visual/AnimatedSprite2D.visible = true

		# mantener flip correcto
		$Visual.scale.x = -1 if last_direction < 0 else 1

#primer tp por si se cae el jugador antes de tiempo
func _on_tp_inicio_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		body.global_position = get_node("/root/main/markers/spawn_point1").global_position

#tp segunda vuelta este SI es para avanzar
func _on_tp_segunda_vuelta_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		$music_and_sounds/wind.stop()
		var vida_node = get_node("/root/main/vida_animation")
		await vida_node.perdida_vida()
		body.global_position = get_node("/root/main/markers/spawn_point2").global_position
		$Camera2D.make_current()



#logica del angel
func _on_spawn_angel_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		$CanvasModulate.visible = false
		$PointLight2D.visible=false
		var angel_node = get_node("/root/main/areas/angel")
		body.global_position = get_node("/root/main/markers/spawn_point2").global_position
		angel_node.visible = true
		angel_node.velocidad_actual = angel_node.velocidad_normal
		#logica de la musica (a futuro)
		
		
		
		
#logica de la camara
func _ready() -> void:
	var camara_1= $Camera2D
	camara_1.make_current()
	$Visual/ataque/attack_colider/CollisionShape2D.disabled=true


# efectos de sonido de aqui abajo no tocar plz
func _on_wind_area_1_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		$music_and_sounds/wind.play()
		pass

func _on_strange_sky_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		$music_and_sounds/strange_sky.play()
		pass # Replace with function body.




func _on_oscurecersky_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		var tween = create_tween()
		tween.tween_property($"CanvasModulate", "color", Color(0,0,0,0.6),2 )
		var music_tween = create_tween()
		music_tween.tween_property($music_and_sounds/strange_sky, "volume_db", -30, 2) # -30 dB ≈ silencio
		await tween.finished
		$PointLight2D.visible=true
		$PointLight2D.energy=0.0
		var ligth_tween= create_tween()
		ligth_tween.tween_property($PointLight2D,"energy",1.0,1.5)
		$music_and_sounds/strange_sky.stop()
		


func _on_attack_colider_area_entered(area: Area2D) -> void:
	if area.name == "barrier_world":
		var knockback = Vector2(-250, 0)  # empuja hacia la izquierda
		$Visual/ataque.play("knockback")
		velocity = knockback


func _on_cave_ambience_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":

		SPEED = 80
		$CanvasModulate.visible = true
		$PointLight2D.visible = true
		$PointLight2D.energy = 0.0

		var light_tween = create_tween()
		light_tween.tween_property($PointLight2D, "energy", 1.0, 1.5)

		$music_and_sounds/strange_sky.stop()
		$music_and_sounds/cave_backround_ambience_aud.play()

		# --- ESPERA 1 ---
		var t1 = create_tween()
		t1.tween_interval(3.0)
		await t1.finished

		$music_and_sounds/breathing_back.play()

		# --- ESPERA 2 ---
		var t2 = create_tween()
		t2.tween_interval(3.0)
		await t2.finished

		$music_and_sounds/whispers_back.play()

		# --- ESPERA 3 ---
		var t3 = create_tween()
		t3.tween_interval(3.0)
		await t3.finished

		$music_and_sounds/main_whispers.play()
		$music_and_sounds/main_breathing.play()

		# --- ESPERA 4 ---
		var t4 = create_tween()
		t4.tween_interval(5.0)
		await t4.finished

		$music_and_sounds/pasos_cuevas.play()
		
		var t5 = create_tween()
		t5.tween_interval(2.0)
		await t5.finished
		$music_and_sounds/scream.play()
