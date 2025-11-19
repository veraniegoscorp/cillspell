extends Camera2D
var target : Node2D = null
func _process(_ddelta: float) -> void:
	if self.is_current() and target != null:
		position=target.global_position
		pass

func _on_camara_body_entered(body: Node2D) -> void:
	if body.name == "personaje principal":
		target=body
		self.make_current()

		
		
