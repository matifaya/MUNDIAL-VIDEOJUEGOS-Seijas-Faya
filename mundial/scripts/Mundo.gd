extends Node2D

const ALTO_PANTALLA: float = 1280.0

func _ready() -> void:
	$FondoNivel.texture = load("res://assets/calleMapa.png")
	$FondoNivel.z_index = -10
	$FondoNivel.centered = false
	$FondoNivel.position = Vector2(0.0, ALTO_PANTALLA - $FondoNivel.texture.get_height())
	var fondo_superior := Sprite2D.new()
	fondo_superior.texture = load("res://assets/tribunaCanchaMapa.png")
	fondo_superior.centered = false
	fondo_superior.z_index = -10
	fondo_superior.position = Vector2(0.0, $FondoNivel.position.y - fondo_superior.texture.get_height())
	add_child(fondo_superior)
