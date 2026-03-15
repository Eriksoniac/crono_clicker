extends Node
class_name seccionclicker

signal iniciar_rpg(turnos:int)

@onready var boton: Button = $iniciar_aventura

var clicks :int = 0
var autoclicks :int = 0
@export var multiplicador :int = 1
@export var meta: int = 100

func _ready() -> void:
	boton.pressed.connect(iniciar_aventura)
	_actualizar_ui()

func _process(delta: float) -> void:
	if autoclicks > 0:
		clicks += autoclicks * delta * multiplicador
	if Input.is_action_just_pressed("click izq"):
		clicks += 1 * multiplicador
	_actualizar_ui()

func iniciar_aventura() -> void:
	if clicks >= meta:
		iniciar_rpg.emit(int(clicks))
		clicks = 0

func _actualizar_ui() -> void:
	boton.text = "Clicks: %d" % int(clicks)
	boton.disabled = clicks < meta
