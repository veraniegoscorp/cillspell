extends  Control

func _ready() -> void:
	if global.final_desbloqueado:
		$music_and_sounds/static.play()
