extends Area2D
var velocidad_normal = 5
var velocidad_rapida = 400
var velocidad_actual = 0
var persiguiendo = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if persiguiendo:
		var direccion = (get_node("/root/main/personaje principal").global_position - global_position).normalized()
		position += direccion * velocidad_actual * delta
	else:
		# Movimiento lento inicial (puedes definir una ruta o animación)
		position.x += velocidad_actual * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	velocidad_actual=velocidad_rapida
	persiguiendo=true
	


func _on_body_entered(body: Node2D) -> void:
	if body.name=="personaje principal":
		body.global_position = get_node("/root/main/spawn_point3").global_position
