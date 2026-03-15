extends CharacterBody2D

enum estado {QUIETO, MOVIMIENTO, DELAY, BATALLA}

@export var estado_actual : estado
@export var casilla_tamaño := 64
@onready var tilemap : TileMapLayer = get_tree().get_first_node_in_group("world_tilemap")
@onready var rpg := get_parent()

var is_moving : bool
var comentarios_malos := ["ESO DOLIO!!", "CASI ME CAIGO!!" ,"PORQUE HAY UNA PARED AQUI??" ,"HOY NO ES MI DIA DE SUERTE YnY" ,"AUN NO PUEDO ATRAVESAR PAREDES" ,"NO SOY TAN FUERTE PARA PASAR POR AHI"]
var direction: Vector2
var delay :float = 0.0

func _ready() -> void:
	position = tilemap.map_to_local(tilemap.local_to_map(position))

func _physics_process(_delta: float) -> void:
	match estado_actual:
		estado.QUIETO:
			var direccion: Vector2 = Input.get_vector("izq","der","arr","aba")
			if direccion != Vector2.ZERO:
				direction = direccion
				estado_actual = estado.MOVIMIENTO
		estado.MOVIMIENTO:
			var movimiento: Vector2 = direction * casilla_tamaño
			var collision: KinematicCollision2D = move_and_collide(movimiento)
			if collision:
				var collider: CollisionObject2D = collision.get_collider()
				move_and_collide(movimiento)
				if collider.is_in_group("enemigos"):
					estado_actual = estado.BATALLA
				else:
					tropiezo(movimiento)
					estado_actual = estado.DELAY
				rpg.consumir_turno()
				return
			var celda: Vector2i = tilemap.local_to_map(position)
			position = tilemap.map_to_local(celda)
			rpg.consumir_turno()
			estado_actual= estado.DELAY
		estado.DELAY:
			delay += _delta
			if delay >= 0.5:
				delay = 0.0
				estado_actual = estado.QUIETO
		estado.BATALLA:
			pass

func tropiezo(direccion: Vector2) -> void:
	var empuje: Vector2 = direccion * 4
	var tween: Tween = create_tween()
	tween.tween_property(self,"position",position + empuje, 0.1)
	tween.tween_property(self,"position",position,0.05)
	await  tween.finished
	var comentario: String = comentarios_malos[randi() % comentarios_malos.size()]
	print(comentario)

func game_over() -> void:
	print("se acabaron los turnos")


#func _enemigo_detectado(body: Node2D):
	#is_moving = false
	#if body.is_in_group("enemigo"):
		#emit_signal("enemigo_detectado", body)
		#print(body.tipo_enemigo)
		#print("Detectado:", body) 
		#print("Grupos:", body.get_groups())
