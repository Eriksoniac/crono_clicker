extends Camera2D

var velocidad: int = 5000

func _process(delta: float) -> void:
	var direccion: Vector2 = Input.get_vector("izq","der","arr","aba")
	if direccion != Vector2.ZERO:
		global_position += direccion * delta * velocidad
