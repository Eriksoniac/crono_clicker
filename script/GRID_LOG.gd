extends TileMapLayer

@export var gen_log: NoiseTexture2D
@export var altura: int
@export var ancho: int

var pack_val: Dictionary = {}


func _ready() -> void:
	await gen_log.changed
	gen_val()
	paint()

func gen_val() -> void:
	var image: Image = gen_log.get_image()
	for y in altura:
		for x in ancho:
			pack_val[Vector2i(x, y)] = image.get_pixel(x, y).r

func paint() -> void:
	for coord: Vector2 in pack_val:
		var valor: float = pack_val[coord]
		var atlas_coord: Vector2i
		if valor < gen_log.color_ramp.get_offset(0):
			atlas_coord = Vector2i(0, 1)  # agua
		elif valor < gen_log.color_ramp.get_offset(1):
			atlas_coord = Vector2i(2, 0)  # arena
		else:
			atlas_coord = Vector2i(1, 0)  # pasto
		set_cell(coord, 1, atlas_coord)
