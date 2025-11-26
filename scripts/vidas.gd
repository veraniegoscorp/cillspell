extends Node2D
var corazones=3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	corazones=3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func perdida_vida():
	corazones -= 1
	$camara_vidas.make_current()
	if corazones == 2:
		$"cora 1".play("lost_1_life")
		await $"cora 1".animation_finished
		$"cora 1".visible = false

	elif corazones == 1:
		$"cora 2".play("lost_1_life")
		await $"cora 2".animation_finished
		$"cora 2".visible = false

	elif corazones == 0:
		$"cora 3".play("lost_1_life")
		await $"cora 3".animation_finished
		$"cora 3".visible = false
