extends StateBase
class_name EstadoRPG

func enter() -> void:
	owner_node.hud._set_modo(owner_node.hud.Modo.RPG)
	owner_node.rpg.visible = true
	owner_node.act_camera_rpg()
	var turnos:int
	if owner_node.primera_partida:
		turnos = 100
		owner_node.primera_partida = false
	else:
		turnos = Global.game_data1["turnos"]
		owner_node.rpg.iniciar_partida(turnos)
	print("turnos_pendientes: ", Global.game_data1.get("turnos", "NO EXISTE"))
	print("primera_partida: ", owner_node.primera_partida)

func exit() -> void:
	pass

func _guardar_press() -> void:
	Global.game_data1["position"] = owner_node.personaje.global_position
	Global.game_data1["vida"]     = owner_node.rpg.vida
	Global.game_data1["nivel"]    = owner_node.rpg.nivel
	Global.game_data1["turnos"]   = owner_node.rpg.turnos_restantes
	Global.game_data1["primera_partida"]= owner_node.primera_partida
	Global.save_game()

func _cargar_press() -> void:
	Global.load_game()
	if Global.game_data1["position"] != Vector2.ZERO:
		owner_node.rpg.personaje.global_position = Global.game_data1["position"]
		owner_node.rpg.vida               = Global.game_data1["vida"]
		owner_node.rpg.nivel              = Global.game_data1["nivel"]
		owner_node.rpg.turnos_restantes   = Global.game_data1["turnos"]
		owner_node.primera_partida        = Global.game_data1["primera_partida"]
	else:
		print("no tienes un guardado")


func _batalla(datos_enemigo: String) -> void:
	print("iniciar combate contra: ", datos_enemigo)
	owner_node.maquina.cambiar_estado("StateBATALLA")

func _regresar_clicker() -> void:
	owner_node.maquina.cambiar_estado("StateCLICKER")
