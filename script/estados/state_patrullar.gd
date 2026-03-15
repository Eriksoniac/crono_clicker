extends StateBase
class_name EstadoPATRULLAR

var pasos_restantes: int = 0
var direccion: Vector2i = Vector2i.ZERO

func enter() -> void:
	_nueva_direccion()

func exit() -> void:
	pass

func en_turno() -> void:
	if pasos_restantes <= 0:
		_nueva_direccion()
	var destino: Vector2 = owner_node.global_position + Vector2(direccion) * owner_node.casilla
	owner_node.global_position = destino
	pasos_restantes -= 1

func _nueva_direccion() -> void:
	pasos_restantes = randi_range(1, owner_node.pasos_direccion)
	var opciones: Array = [Vector2i(0,-1), Vector2i(0,1), Vector2i(1,0), Vector2i(-1,0)]
	direccion = opciones[randi() % opciones.size()]
