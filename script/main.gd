extends Node

@onready var hud: CanvasLayer = $HUD
@onready var clicker: seccionclicker = $seccion_clicker
@onready var rpg: seccionRPG = $seccion_rpg
@onready var camera: Camera2D = $seccion_rpg/personaje/Camera2D
@onready var personaje: CharacterBody2D = $seccion_rpg/personaje
@onready var maquina: StateMachine = $StateMachine

var primera_partida := true
var pausado: bool = false

func _ready() -> void:
	#señales del hud
	hud.iniciar_press.connect(maquina.get_node("StateMENU")._iniciar_press)
	hud.continuar_press.connect(cerrar_pausa)
	hud.opciones_press.connect(abrir_opciones)
	hud.salir_press.connect(salir_press)
	hud.guardar_press.connect(maquina.get_node("StateRPG")._guardar_press)
	hud.cargar_press.connect(maquina.get_node("StateRPG")._cargar_press)
	hud.accion_selecionada.connect(maquina.get_node("StateBATALLA")._batalla)
	#señales del clicker
	clicker.iniciar_rpg.connect(maquina.get_node("StateCLICKER")._iniciar_rpg)
	#señales del clicker
	rpg.iniciar_batalla.connect(maquina.get_node("StateRPG")._batalla)
	rpg.regresar_clicker.connect(maquina.get_node("StateRPG")._regresar_clicker)
	#estado inicial
	maquina.cambiar_estado("StateMENU")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("can"):
		if not pausado:
			abrir_pausa()
		else:
			cerrar_pausa()

func abrir_pausa() -> void:
	pausado = true
	get_tree().paused = true
	hud.visible = true
	hud._set_modo(hud.Modo.PAUSA)


func cerrar_pausa() -> void:
	pausado = false
	get_tree().paused = false
	match maquina.estado_actual.name:
		"StateRPG": hud._set_modo(hud.Modo.RPG)
		"StateCLICKER": hud._set_modo(hud.Modo.CLICKER)
		"StateMENU": hud._set_modo(hud.Modo.MENU)

func abrir_menu_pausa() -> void:
	abrir_pausa()


func abrir_opciones() -> void:
	maquina.cambiar_estado("StateOPCIONES")


func salir_press() -> void:
	print(maquina.estado_actual.name)
	print(pausado)
	#si estamos en opciones, regresar al estado anterior
	if maquina.estado_actual.name == "StateOPCIONES":
		maquina.get_node("StateOPCIONES")._salir_press()
	#si estamos en menu salir del juego
	else:
		get_tree().quit()

func des_camera_rpg() -> void:
	camera.enabled = false


func act_camera_rpg() -> void:
	camera.enabled = true
