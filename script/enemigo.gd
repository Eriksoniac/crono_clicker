extends AnimatableBody2D

enum tipo {DUMMY,RATA,LOBO,GOBLIN,ORCO,ESQUELETO,DRAGON,SLIME,JEFE}
enum estado {patrullar, perseguir}

@onready var tilemap : TileMapLayer = get_tree().get_first_node_in_group("world_tilemap")
@onready var area_deteccion: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var radar_radis: CollisionShape2D = $Area2D/CollisionShape2D
@onready var maquina: StateMachine = $StateMachine


const casilla : int = 64

@export var tipo_enemigo : tipo = tipo.DUMMY
@export var estado_actual : estado = estado.patrullar
@export var pasos_direccion : int 

var mov: Array = ["arr", "aba", "der", "izq"]
var direccion: Vector2 = Vector2.ZERO
var pasos_restantes: int
var jugador: CharacterBody2D = null
var vida : int
var ataque : int
var deteccion: int = 64
var tipo_ia : String
var velocidad : int = 1

func _ready() -> void:
	configurar_enemigo()
	radar_radis.shape.radius = deteccion
	area_deteccion.body_entered.connect(_on_body_entered)
	area_deteccion.body_exited.connect(_on_body_exited)
	get_parent().consu_turno.connect(_on_turno)
	maquina.cambiar_estado("StatePatrullar")

func _process(_delta: float) -> void:
	pass

func configurar_enemigo() -> void:
	match tipo_enemigo:
		tipo.RATA:
			vida = 10 
			ataque = 5
			deteccion = deteccion * 2
			tipo_ia = "rata"
			velocidad = 1
		tipo.GOBLIN:
			vida = 20 
			ataque = 10
			deteccion = deteccion * 4
			tipo_ia = "goblin"
			velocidad = 1
		tipo.LOBO:
			vida = 30
			ataque = 15
			deteccion = deteccion * 6
			tipo_ia = "lobo"
			velocidad = 2
		tipo.ORCO:
			vida = 50
			ataque = 25
			deteccion = deteccion * 3
			tipo_ia = "orco"
			velocidad = 1
		tipo.ESQUELETO:
			vida = 70
			ataque = 10
			deteccion = deteccion * 1
			tipo_ia = "esqueleto"
			velocidad = 1
		tipo.DRAGON:
			vida = 200
			ataque = 50
			deteccion = deteccion * 10
			tipo_ia = "dragon"
			velocidad = 3
		tipo.SLIME:
			vida = 15
			ataque = 10
			tipo_ia = "slime"
			deteccion = deteccion * 5
			velocidad = 2
		tipo.JEFE:
			vida = 1000
			ataque = 100
			tipo_ia = "jefe"
			velocidad = 3
		tipo.DUMMY:
			vida = 9999999999
			ataque = 0
			tipo_ia = "dummy"
			deteccion = deteccion * 3
			velocidad = 0
	print(vida , "- ", ataque, "- ", tipo_ia, "- ", deteccion, "- ", velocidad)

func datos_enemigo() -> Dictionary:
	return {"tipo": tipo_enemigo,
	"vida": vida,
	"ataque": ataque,
	"ia": tipo_ia}

func _on_turno() -> void:
	if maquina.estado_actual.has_method("en_turno"):
		maquina.estado_actual.en_turno()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		jugador = body
		print("persiguiendo", tipo_enemigo)
		maquina.cambiar_estado("StatePerseguir")

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		jugador = null
		print("patrullando", maquina.estado_actual.name)
		maquina.cambiar_estado("StatePatrullar")
