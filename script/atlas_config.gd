extends  Resource
class_name Atlasconfig

@export var orden_rellenos: Array[int] = [1, 2, 3, 4]
@export var principales_diagonal: Array[int] = [4, 2, 1, 3]  # pasto, arena, agua, tierra
@export var principales_esquina:  Array[int] = [0, 1, 2, 3, 4]  # vacio, agua, arena, tierra, pasto
@export var principales_borde:    Array[int] = [1, 2, 3, 4]# agua, arena, tierra, pasto
@export var col_relleno:   int = 0
@export var col_diagonal:  int = 1
@export var col_esquina:   int = 5
@export var col_borde:     int = 10

@export var diagonal_alt_id: int = 1
