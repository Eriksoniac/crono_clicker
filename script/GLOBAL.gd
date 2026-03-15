extends Node

#datos de guardado
var save_path:String = "user://save_game.dat"
var save_data:String = "user://save_data.dat"

var game_data1 : Dictionary = {
	"estado" : null,
	"vida" : 100,
	"nivel" : 1,
	"position" : Vector2.ZERO,
	"turnos": 0,
	"primera_partida":true
	}
var game_data2 : Dictionary = {
	"estado" : null,
	"vida" : 100,
	"nivel" : 1,
	"position" : Vector2.ZERO,
	"turnos": 0,
	"primera_partida":true
	}
var game_data3 : Dictionary = {
	"estado" : null,
	"vida" : 100,
	"nivel" : 1,
	"position" : Vector2.ZERO,
	"turnos": 0,
	"primera_partida":true
	}
var data_values: Dictionary = {
	"p_e_active" = Vector2i.ZERO,
	"map_active" = "atlas"
	}


func save_game() -> void:
	var save_file:FileAccess = FileAccess.open(save_path,FileAccess.WRITE)
	save_file.store_var(game_data1) #guardamos las variables
	save_file = null #cerrar archivo


func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var save_file:FileAccess = FileAccess.open(save_path,FileAccess.READ)
		game_data1 = save_file.get_var() #cargar las variables
		save_file = null #cerrar el archivo
