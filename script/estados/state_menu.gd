extends StateBase
class_name EstadoMENU



func enter() -> void:
	owner_node.des_camera_rpg()
	owner_node.hud._set_modo(owner_node.hud.Modo.MENU)
	owner_node.hud.visible = true
	owner_node.rpg.visible = false
	owner_node.clicker.visible = false
	get_tree().paused = true

func exit() -> void:
	get_tree().paused = false

func _iniciar_press() -> void:
	if owner_node.primera_partida:
		owner_node.maquina.cambiar_estado("StateRPG")
	else:
		owner_node.maquina.cambiar_estado("StateCLICKER")

func _opciones_press() -> void:
	owner_node.maquina.cambiar_estado("StateOPCIONES")

func _salir_press() -> void:
	get_tree().quit()
