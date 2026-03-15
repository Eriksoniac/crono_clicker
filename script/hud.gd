extends CanvasLayer

signal iniciar_press
signal continuar_press
signal opciones_press
signal salir_press
signal guardar_press
signal cargar_press
signal accion_selecionada(numero: int)

enum Modo {MENU, PAUSA, RPG, CLICKER, BATALLA, OPCIONES}
@export var modo_actual : Modo
@onready var continuar: Button = $menus/continuar
@onready var iniciar: Button = $menus/iniciar
@onready var opciones: Button = $menus/opciones
@onready var salir: Button = $menus/salir
@onready var guardar: Button = $menus/guardar
@onready var cargar: Button = $menus/cargar
@onready var menus: VBoxContainer = $menus
@onready var rpg: Control = $IU_RPG
@onready var batallas: Control = $BATALLAS
@onready var botones:Array = [$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 1",
$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 2",
$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 3",
$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 4",
$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 5",
$"BATALLAS/PanelContainer/MarginContainer/GridContainer/accion 6"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rpg.visible = false
	batallas.visible = false
	_set_modo(modo_actual)
	for i in botones.size():
		botones[i].pressed.connect(boton_presionado.bind(i+1))


func _set_modo(modo: Modo) -> void:
	modo_actual = modo
	print("hud: ", modo_actual)
	
	match modo_actual:
		Modo.MENU:
			iniciar.visible = true
			continuar.visible = false
			cargar.visible = false
			guardar.visible = false
			opciones.visible = true
		Modo.PAUSA:
			rpg.visible = false
			batallas.visible = false
			menus.visible = true
			iniciar.visible = false
			continuar.visible = true
			cargar.visible = false
			guardar.visible = false
			opciones.visible = true
		Modo.RPG:
			menus.visible = false
			rpg.visible = true
			batallas.visible = false
		Modo.BATALLA:
			menus.visible = false
			rpg.visible = false
			batallas.visible = true
		Modo.OPCIONES:
			iniciar.visible = false
			continuar.visible = false
			opciones.visible = false
			cargar.visible = true
			guardar.visible = true
		Modo.CLICKER:
			menus.visible = false
			rpg.visible = false
			batallas.visible = false


func boton_presionado(numero: int) -> void:
	emit_signal("accion_selecionada",numero)
	print(numero)


func _on_continuar_pressed() -> void:
	continuar_press.emit()
	print("continuar")


func _on_salir_pressed() -> void:
	salir_press.emit()
	print("salir")


func _on_iniciar_pressed() -> void:
	iniciar_press.emit()
	print("iniciar")


func _on_opciones_pressed() -> void:
	opciones_press.emit()
	print("opciones")


func _on_guardar_pressed() -> void:
	guardar_press.emit()
	print("guardar")


func _on_cargar_pressed() -> void:
	cargar_press.emit()
	print("cargar")
