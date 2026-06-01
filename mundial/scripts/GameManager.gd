# Proyecto: El Hincha Invasor
# Alumno: Matias Faya
# Instituto Politécnico Modelo (IPM)

extends Node

var puntuacion_actual: int = 0
var pais_seleccionado: String = ""
var progreso_habilidad: float = 1.0

func agregar_punto() -> void:
	puntuacion_actual += 1

func reiniciar() -> void:
	puntuacion_actual = 0
	progreso_habilidad = 1.0
	get_tree().reload_current_scene()
