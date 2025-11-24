extends Node2D
var corazones=3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	corazones=3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func perdida_vida():
	corazones -= 1
	var corazon_anim : AnimatedSprite2D
	match corazones:
		2:
			$cora_1.play("lost_1_life")
		1:
			$cora_2.play("lost_1_life")
		0:
			$cora_3.play("lost_1_life")
	# Reproducimos la animación
	corazon_anim.play("lost_1_life")
	await corazon_anim.animation_finished
	corazon_anim.visible = false
