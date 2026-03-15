extends StateBase
class_name EstadoPAUSA

var estado_previo: String = ""

func enter() -> void:
	owner_node.hud._set_modo(owner_node.hud.Modo.PAUSA)
	get_tree().paused = true

func exit() -> void:
	get_tree().paused = false

func _continuar_press() -> void:
	owner_node.maquina.cambiar_estado(estado_previo)

func _opciones_press() -> void:
	owner_node.maquina.cambiar_estado("StateOPCIONES")

func _salir_press() -> void:
	if owner_node.hud.modo_actual == owner_node.hud.Modo.OPCIONES:
		owner_node.hud._set_modo(owner_node.hud.Modo.PAUSA)
	else:
		owner_node.maquina.cambiar_estado(estado_previo)

func _set_estado_previo(nombre:String) -> void:
	estado_previo = nombre
