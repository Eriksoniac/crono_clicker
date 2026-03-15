extends Node
class_name seccionRPG

signal regresar_clicker
signal iniciar_batalla
signal consu_turno

@onready var owner_node: Node = $".."
@onready var personaje: CharacterBody2D = $personaje
@export var turnos_restantes: int

var vida : int
var nivel : int = 1
var arma : float = 1
var ataque : float = arma * nivel

func _ready() -> void:
	Global.game_data1["turnos"] = turnos_restantes
	print(Global.game_data1["turnos"])
	Global.save_game()
	vida = 100
	ataque = 1

func iniciar_partida(turnos:int) -> void:
	turnos_restantes = turnos
	print("partida iniciada con %d turnos" % turnos)

func consumir_turno() -> void:
	turnos_restantes -= 1
	print("turnos restantes: ",turnos_restantes)
	consu_turno.emit()
	if turnos_restantes <= 0:
		game_over()

func game_over() -> void:
	print("se acabaron los turnos")
	regresar_clicker.emit()

func _procesar_enemigo(enemigo: String) -> void:
	print("recibido en rpg: ",enemigo)
