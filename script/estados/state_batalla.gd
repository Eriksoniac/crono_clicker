extends StateBase
class_name EstadoBATALLA



func enter() -> void:
	owner_node.hud._set_modo(owner_node.hud.Modo.BATALLA)
	owner_node.act_camera_rpg()

func exit() -> void:
	pass

func _accion_seleccionada(numero: int) -> void:
	print("accion seleccionada: ", numero)

func _terminar_batalla() -> void:
	owner_node.maquina.cambiar_estado("StateRPG")

func _batalla() -> void:
	pass
