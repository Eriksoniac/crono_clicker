extends Node2D

@export var altura_ruido_texto : NoiseTexture2D
var ruido : Noise
var altura :int = 100
var ancho :int = 100
@onready var visual_layer: TileMapLayer = $logicLayer/visual_layer


var id_fuente = 2
var pasto_bald = []
var terreno_pasto_int = 1
var tierra_bald = []
var terreno_tierra_int = 0

func _ready() -> void: 
	ruido = altura_ruido_texto.noise
	_generar_mapa()

func _generar_mapa():
	for x in range(ancho):
		for y in range(altura):
			var valor_ruido :float = ruido.get_noise_2d(x,y)
			if valor_ruido <= -0.1:
				#genera agua
				pass
			elif valor_ruido >-0.1:
				#generar tierra
				pass
			elif valor_ruido > 0.0 and valor_ruido <= 0.2:
				#genera pasto
				pass
			elif  valor_ruido > 0.2:
				#generar montaña
				pass
