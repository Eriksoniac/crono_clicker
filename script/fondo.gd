extends ColorRect

var color_objetivo := Color(randf(),randf(),randf())
@export var color_velocidad := 1
var frames := 0

func _ready() -> void:
	color = Color(randf(),randf(),randf())
	cambiar_color()

func _process(delta: float) -> void:
	color = color.lerp(color_objetivo,color_velocidad*delta)

func cambiar_color() -> void:
	while true:
		color_objetivo = Color(randf(),randf(),randf())
		await get_tree().create_timer(1).timeout
