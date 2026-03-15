extends Node
class_name StateMachine

var estado_actual: StateBase= null

const trancisiones: Array =[
	["StateMENU",    "StateRPG"],
	["StateRPG",     "StateCLICKER"],
	["StateCLICKER", "StateRPG"],
]

func _ready() -> void:
	#asignar owner node a todos los estados hijo
	for hijo in get_children():
		if hijo is StateBase:
			hijo.owner_node = get_parent()

func _process(delta: float) -> void:
	if estado_actual:
		estado_actual.update(delta)

func _physics_process(delta: float) -> void:
	if estado_actual:
		estado_actual.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if estado_actual:
		estado_actual.handle_input(event)

func cambiar_estado(nombre: String) -> void:
	var nuevo_estado := get_node_or_null(nombre) as StateBase
	if nuevo_estado == null:
		push_error("Estado no encontrado " + nombre)
		return
	var desde: String = str(estado_actual.name) if estado_actual != null else ""
	if _necesita_fade(desde, nombre):
		await _fade_con_secciones(desde, nombre)
	if estado_actual:
		estado_actual.exit()
	if nuevo_estado.has_method("_set_estado_previo"):
		nuevo_estado._set_estado_previo(desde)
	estado_actual = nuevo_estado
	estado_actual.enter()

func _necesita_fade(desde: String, hacia: String) -> bool:
	for par: Array in trancisiones:
		if par[0] == desde and par[1] == hacia:
			return true
	return false

func _fade_con_secciones(desde: String, hacia: String) -> void:
	var main_node := get_parent()
	# mapeo de estado → seccion visual
	var seccion_map: Dictionary = {
		"StateMENU":    null,
		"StateRPG":     main_node.rpg,
		"StateCLICKER": main_node.clicker,
	}
	var origen:  CanvasItem = seccion_map.get(desde, null)
	var destino: CanvasItem = seccion_map.get(hacia, null)
	if origen != null and destino != null:
		await _trancision(origen, destino)

func _trancision(origen: CanvasItem, destino: CanvasItem) -> void:
	var tween := create_tween()
	tween.tween_property(origen, "modulate:a", 0.0, 0.4)
	await tween.finished
	origen.visible = false
	destino.visible = true
	destino.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(destino, "modulate:a", 1.0, 0.4)
	await tween.finished
