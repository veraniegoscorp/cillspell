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
		if vida_barrera == 0:
			$f.queue_free()
			$barrier_world.queue_free()
			pass
		
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		$barrier_world.visible=false
		pass


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name=="personaje principal":
			body.global_position = get_node("/root/main/markers/tp_glitch").global_position
