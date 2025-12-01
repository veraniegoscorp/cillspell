extends Node

var final_desbloqueado = false
var final_quit=0

func save_game():
	var data = {
		"final": final_desbloqueado
	}
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_var(data)

func load_game():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = file.get_var()
		final_desbloqueado = data.get("final", false)

func cambiar_final_juego():
	final_desbloqueado = true
	save_game()
	get_tree().quit()
