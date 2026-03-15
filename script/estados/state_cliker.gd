extends StateBase
class_name EstadoCLIKER



func enter() -> void:
	await owner_node.des_camera_rpg()
	owner_node.hud._set_modo(owner_node.hud.Modo.CLICKER)
	owner_node.clicker.visible = true
	owner_node.rpg.visible = false

func exit() -> void:
	owner_node.clicker.visible = false

func _iniciar_rpg(turnos: int) -> void:
	print("turnos recibidos del cliker: ", turnos)
	Global.game_data1["turnos"] = turnos
	owner_node.maquina.cambiar_estado("StateRPG")
