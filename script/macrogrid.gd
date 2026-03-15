extends Node2D
class_name Macrogrid

enum bioma {PASTIZAL, NIEVE, DESIERTO, PANTANO, MONTAÑA, DEMONIACO}

@export var bioma_actual: bioma

@onready var pastizal: genedualgrid = $pastizal

func _ready() -> void:
	match bioma:
		bioma.PASTIZAL:
			pass
		bioma.NIEVE:
			pass
		bioma.DESIERTO:
			pastizal.free()
