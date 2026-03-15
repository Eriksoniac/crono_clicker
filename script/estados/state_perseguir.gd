extends StateBase
class_name EstadoPERSEGUIR



func enter() -> void:
	pass

func exit() -> void:
	pass

func en_turno() -> void:
	if owner_node.jugador == null:
		return
	var pos_enemigo: Vector2i = Vector2i(owner_node.global_position / owner_node.casilla)
	var pos_jugador: Vector2i = Vector2i(owner_node.jugador.global_position / owner_node.casilla)
	var diferencia: Vector2i = pos_jugador - pos_enemigo
	var pasos: int = owner_node.pasos_direccion
	for i in pasos:
		if diferencia == Vector2i.ZERO:
			break
		var direccion: Vector2i
		if abs(diferencia.x) >= abs(diferencia.y):
			direccion = Vector2i(sign(diferencia.x), 0)
		else:
			direccion = Vector2i(0, sign(diferencia.y))
		# si la distancia es menor que la velocidad, moverse exactamente un tile
		var distancia: int = max(abs(diferencia.x), abs(diferencia.y))
		if distancia <= 1:
			owner_node.global_position += Vector2(direccion) * owner_node.casilla
		else:
			owner_node.global_position += Vector2(direccion) * owner_node.casilla * owner_node.velocidad
		diferencia = pos_jugador - Vector2i(owner_node.global_position / owner_node.casilla)
