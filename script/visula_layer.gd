extends Node
class_name genedualgrid

@onready var layer_agua: TileMapLayer = $layer_agua
@onready var layer_arena: TileMapLayer = $layer_arena
@onready var layer_tierra: TileMapLayer = $layer_tierra
@onready var layer_pasto: TileMapLayer = $layer_pasto


@export var ancho: int
@export var altura : int
@export var ruido_agua: float
@export var ruido_arena: float
@export var ruido_tierra: float
@export var ruido_pasto: float
@export var atlas_config: Atlasconfig

const VACIO: int = 0
const ARENA: int = 1
const PASTO: int = 2
const AGUA: int = 3
const  TIERRA: int = 4

const casilla: int = 64
const SECUNDARIOS: Dictionary = {
	VACIO: [AGUA, ARENA, TIERRA, PASTO],
	AGUA: [VACIO, ARENA, TIERRA, PASTO],
	ARENA: [VACIO, AGUA, TIERRA, PASTO],
	TIERRA: [VACIO, AGUA, ARENA, PASTO],
	PASTO: [VACIO, AGUA, ARENA, TIERRA],
}
const MASCARAS_DIAGONAL: Array = [0b1001,0b0110]
const MASCARAS_ESQUINA: Array = [0b1110, 0b1101, 0b1011, 0b0111]
const MASCARAS_BORDE: Array = [0b0011, 0b0101, 0b1010, 0b1100]
const MASCARA_ALT_ID: Dictionary = {
	 # esquinas salientes
	0b1110: 0,
	0b1101: 1,
	0b1011: 2,
	0b0111: 3,
	# bordes
	0b0011: 0,
	0b0101: 1,
	0b1010: 2,
	0b1100: 3,
	# diagonal
	0b1001: 0,
	0b0110: 1,  # rotación
}
const ATLAS_COLUMNAS: Array = [
	[0,  -1,     "relleno" ],
	[1,  PASTO,  "diagonal"],
	[2,  ARENA,  "diagonal"],
	[3,  AGUA,   "diagonal"],
	[4,  TIERRA, "diagonal"],
	[5,  VACIO,  "esquina" ],
	[6,  AGUA,   "esquina" ],
	[7,  ARENA,  "esquina" ],
	[8,  TIERRA, "esquina" ],
	[9,  PASTO,  "esquina" ],
	[10, AGUA,   "borde"   ],
	[11, ARENA,  "borde"   ],
	[12, TIERRA, "borde"   ],
	[13, PASTO,  "borde"   ],
]

var grid_log: Array = []
var atlas_calculado: Dictionary = {}

func _build_atlas() -> void:
	atlas_calculado.clear()
	var cfg := atlas_config
	# --- rellenos ---
	for fila in cfg.orden_rellenos.size():
		var terreno: int = cfg.orden_rellenos[fila]
		if not atlas_calculado.has([terreno, -1]):
			atlas_calculado[[terreno, -1]] = {}
		atlas_calculado[[terreno, -1]][0b1111] = Vector2i(cfg.col_relleno, fila)
	# --- diagonales ---
	for i in cfg.principales_diagonal.size():
		var principal: int = cfg.principales_diagonal[i]
		var col: int = cfg.col_diagonal + i
		var secundarios: Array = SECUNDARIOS[principal]
		for fila in secundarios.size():
			var secundario: int = secundarios[fila]
			var par := [principal, secundario]
			if not atlas_calculado.has(par):
				atlas_calculado[par] = {}
			# máscara base
			atlas_calculado[par][MASCARAS_DIAGONAL[0]] = Vector2i(col, fila)
			# máscara rotada — mismo tile, alternative_id distinto
			atlas_calculado[par][MASCARAS_DIAGONAL[1]] = Vector2i(col, fila)
			# nota: la rotación se maneja en _paint_cell con alt_id
	# --- esquinas ---
	for i in cfg.principales_esquina.size():
		var principal: int = cfg.principales_esquina[i]
		var col: int = cfg.col_esquina + i
		var secundarios: Array = SECUNDARIOS[principal]
		for fila in secundarios.size():
			var secundario: int = secundarios[fila]
			var par := [principal, secundario]
			if not atlas_calculado.has(par):
				atlas_calculado[par] = {}
			# las 4 rotaciones de esquina comparten columna
			# se diferencian por alternative_id en _paint_cell
			for m in MASCARAS_ESQUINA.size():
				atlas_calculado[par][MASCARAS_ESQUINA[m]] = Vector2i(col, fila)
	# --- bordes ---
	for i in cfg.principales_borde.size():
		var principal: int = cfg.principales_borde[i]
		var col: int = cfg.col_borde + i
		var secundarios: Array = SECUNDARIOS[principal]
		for fila in secundarios.size():
			var secundario: int = secundarios[fila]
			var par := [principal, secundario]
			if not atlas_calculado.has(par):
				atlas_calculado[par] = {}
			for m in MASCARAS_BORDE.size():
				atlas_calculado[par][MASCARAS_BORDE[m]] = Vector2i(col, fila)

func _ready() -> void:
	var PARES_POR_CAPA: Array = [
		[layer_agua,  AGUA,  VACIO],
		[layer_arena, ARENA, VACIO],
		[layer_arena, ARENA, AGUA ],
		[layer_tierra, TIERRA,VACIO],
		[layer_tierra, TIERRA,AGUA],
		[layer_tierra, TIERRA,ARENA],
		[layer_tierra, TIERRA,PASTO],
		[layer_pasto, PASTO, VACIO],
		[layer_pasto, PASTO, AGUA],
		[layer_pasto, PASTO, ARENA],
		[layer_pasto, PASTO, TIERRA],
	]
	_setup_alternatives()
	_build_atlas()
	_gen_log_grid_cell()
	_pnt_vis_grid(PARES_POR_CAPA)

func _setup_alternatives() -> void:
	var source := layer_pasto.tile_set.get_source(0) as TileSetAtlasSource
# 	rotaciones necesarias por tipo
# 	[mascara_base, [alt_id, flip_h, flip_v, transpose]]
	var ROTACIONES := {
		"esquina": [
			[0b1110, 0, false, false, false],
			[0b1101, 1, true,  false, false],
			[0b1011, 2, false, true,  false],
			[0b0111, 3, true,  true,  false],
		],
		"borde": [
			[0b0011, 0, false, false, false],
			[0b0101, 1, false, false, true ],
			[0b1010, 2, true,  false, true ],
			[0b1100, 3, false, true,  false],
		],
		"diagonal": [
			[0b1001, 0, false, false, false],
			[0b0110, 1, false, true, false ],
		],
	}
	for entry: Array in ATLAS_COLUMNAS:
		var col: int = entry[0]
		var tipo: String = entry[2]
		if tipo == "relleno":
			continue
		var secundarios: Array = SECUNDARIOS[entry[1]]
		for fila in secundarios.size():
			var coords := Vector2i(col, fila)
			var rotaciones: Array = ROTACIONES[tipo]
			for rot: Array in rotaciones:
				var alt_id: int = rot[1]
				if alt_id == 0:
					continue
				if not source.has_alternative_tile(coords, alt_id):
					source.create_alternative_tile(coords, alt_id)
				var tile_data := source.get_tile_data(coords, alt_id)
				tile_data.flip_h    = rot[2]
				tile_data.flip_v    = rot[3]
				tile_data.transpose = rot[4]

func gen_noise() -> void:
	#	generar ruido
	for y in altura:
		grid_log.append([])
		for x in ancho:
			var val:float = randf()
			if val < ruido_agua:
				grid_log[y].append(AGUA)
			else:
				grid_log[y].append(PASTO)

func _gen_log_grid_cell() -> void:
	gen_noise()
#	borde solido
	for y in altura:
		grid_log[y][0] = PASTO
		grid_log[y][ancho - 1] = PASTO
	for x in ancho:
		grid_log[0][x] = ARENA
		grid_log[altura - 1][x] = PASTO
#	ARENA solo donde hay vecinos AGUA
	for  y in range(1,altura-1):
		for x in range(1,ancho-1):
			if grid_log[y][x] != AGUA:
				for dy: int in [-1,0,1]:
					for dx: int in [-1,0,1]:
						if get_log_cell(x + dx, y + dy) == AGUA:
							if randf() < ruido_arena:
								grid_log[y][x] = ARENA
								break
	_suavizar_grid()
	for y in altura:
		for x in ancho:
			if grid_log[y][x] == VACIO:
				print("VACIO encontrado en (", x, ",", y, ")")

func _count_neighbors(x: int, y: int) -> int:
	var conteo: int= 0
	for dy: int in [-1, 0, 1]:
		for dx: int in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			if get_log_cell(x + dx, y + dy):
				conteo += 1
	return conteo

func get_log_cell(x: int,y: int) -> int:
	if x < 0 or x >= ancho or y < 0 or y >= altura:
		return VACIO
	return grid_log[y][x]

func _pnt_vis_grid(pares:Array) -> void:
	layer_agua.clear()
	layer_arena.clear()
	layer_pasto.clear()
	layer_tierra.clear()
	for vy in altura + 1:
		for vx in ancho + 1:
			_paint_relleno(vx,vy)
			_paint_cell(vx,vy,pares)

func _paint_relleno(vx: int,vy: int) -> void:
	var rellenos := {
		AGUA: [layer_agua, [AGUA,-1]],
		ARENA: [layer_arena, [ARENA,-1]],
		TIERRA: [layer_tierra, [TIERRA,-1]],
		PASTO:  [layer_pasto,  [PASTO,-1]],
	}
	for terreno: int in rellenos:
		var mask := get_mask(vx, vy, terreno)
		if mask != 0b1111:
			continue
		var entry : Array = rellenos[terreno]
		var layer: TileMapLayer = entry[0]
		var par: Array = entry[1]
		if not atlas_calculado.has(par):
			continue
		var coords: Vector2i = atlas_calculado[par][0b1111]
		layer.set_cell(Vector2i(vx, vy), 0, coords, 0)

func _paint_cell(vx: int, vy: int, pares: Array) -> void:
	for entry: Array in pares:
		var layer:  TileMapLayer = entry[0]
		var tipo_a: int = entry[1]
		var tipo_b: int = entry[2]
		var par := [tipo_a, tipo_b]
		if not atlas_calculado.has(par):
			continue
		var mask   := get_mask(vx, vy, tipo_a)
		var mask_b := get_mask(vx, vy, tipo_b)
		if mask == 0b0000:
			continue
		if mask == 0b1111:
			continue
		if mask_b == 0b0000:
			continue
		if not atlas_calculado[par].has(mask):
			continue
		var coords: Vector2i = atlas_calculado[par][mask]
		var alt_id: int = MASCARA_ALT_ID.get(mask, 0)
		layer.set_cell(Vector2i(vx, vy), 0, coords, alt_id)

func get_mask (vx: int, vy: int, tipo_a: int) -> int:
	var TL:= int(get_log_cell(vx-1,vy-1) == tipo_a)
	var TR:= int(get_log_cell(vx,vy-1) == tipo_a)
	var BL:= int(get_log_cell(vx-1,vy) == tipo_a)
	var BR:= int(get_log_cell(vx,vy) == tipo_a)
	return (TL << 3) | (TR << 2) | (BL << 1) | (BR << 0)

func _suavizar_grid() -> void:
	for _pass in 3:
		var next: Array = []
		for y in altura:
			next.append(grid_log[y].duplicate())
		for y in range(1, altura - 1):
			for x in range(1, ancho - 1):
				# contar vecinos de cada tipo
				var conteo := {}
				for dy: int in [-1, 0, 1]:
					for dx: int in [-1, 0, 1]:
						if dx == 0 and dy == 0:
							continue
						var t: int = get_log_cell(x + dx, y + dy)
						conteo[t] = conteo.get(t, 0) + 1
				# encontrar el tipo más frecuente entre los vecinos
				var tipo_max: int = grid_log[y][x]
				var max_count: int = 0
				for tipo: int in conteo:
					if conteo[tipo] > max_count:
						max_count = conteo[tipo]
						tipo_max = tipo
				# solo reemplazar si hay mayoría clara (5+ de 8 vecinos)
				if max_count >= 5 and tipo_max != VACIO:
						next[y][x] = tipo_max
		grid_log = next
