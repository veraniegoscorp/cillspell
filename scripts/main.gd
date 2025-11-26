extends Node2D

var vida_barrera= 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$barrier_world.visible=false
	$f.play()

func _on_barrier_world_area_entered(area: Area2D) -> void:
	if area.name=="attack_colider":
		$barrier_world.visible = true
		$barrier_world/AnimationPlayer.play("hit")
		vida_barrera -= 1
		$"personaje principal/music_and_sounds/hit_wall".play()
		
		if vida_barrera == 0:
			$f.queue_free()
			$barrier_world.queue_free()
			await get_tree().create_timer(1).timeout
			$"personaje principal/music_and_sounds/PisadasLentas".play()
			await get_tree().create_timer(5).timeout
			$"personaje principal/music_and_sounds/PisadasLentas".stop()
			await get_tree().create_timer(2.5).timeout
			$"personaje principal/music_and_sounds/SonidoPersecucion".play()
			pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		$barrier_world.visible=false
		pass


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name=="personaje principal":
			body.global_position = get_node("/root/main/markers/tp_glitch").global_position
			$"areas/strange_sky".monitoring = false


func _on_tp_respawn_on_glitch_body_entered(body: Node2D) -> void:
		if body.name=="personaje principal":
			body.global_position = get_node("/root/main/markers/tp_glitch").global_position


func _on_pinmin_musi_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		var audio = $"personaje principal/music_and_sounds/pimin_cave"
		audio.play()

		# Crear tween
		var tween = create_tween()
		tween.tween_property(
			audio, 
			"volume_db", 
			audio.volume_db - 2,  # Baja 2 dB
			2.0)


func _on_respawn_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		body.global_position = get_node("/root/main/markers/spawn_point2").global_position
