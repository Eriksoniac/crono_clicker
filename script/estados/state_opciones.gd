extends StateBase
class_name EstadoOPCIONES

var estado_previo: String = ""

func enter() -> void:
	owner_node.hud._set_modo(owner_node.hud.Modo.OPCIONES)

func exit() -> void:
	pass

func _salir_press() -> void:
	if estado_previo == "StateMENU":
		owner_node.maquina.cambiar_estado("StateMENU")
	else:
	# venía de pausa — regresar sin cambiar estado
		owner_node.maquina.estado_actual = self
		exit()
		owner_node.maquina.estado_actual = owner_node.maquina.get_node(estado_previo)
		owner_node.hud._set_modo(owner_node.hud.Modo.PAUSA)

func _set_estado_previo(nombre:String) -> void:
	estado_previo = nombre
