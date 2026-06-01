extends Control

func _ready() -> void:
	GameManager.puntuacion_actual = 0
	$BotonesPaises/Argentina.pressed.connect(_al_seleccionar_argentina)
	$BotonesPaises/Brasil.pressed.connect(_al_seleccionar_brasil)
	$BotonesPaises/Japon.pressed.connect(_al_seleccionar_japon)
	$BotonesPaises/Inglaterra.pressed.connect(_al_seleccionar_inglaterra)
	$BotonesPaises/Alemania.pressed.connect(_al_seleccionar_alemania)
	$BotonJugar.pressed.connect(_al_jugar)

func _al_seleccionar_argentina() -> void:
	GameManager.pais_seleccionado = "Argentina"

func _al_seleccionar_brasil() -> void:
	GameManager.pais_seleccionado = "Brasil"

func _al_seleccionar_japon() -> void:
	GameManager.pais_seleccionado = "Japon"

func _al_seleccionar_inglaterra() -> void:
	GameManager.pais_seleccionado = "Inglaterra"

func _al_seleccionar_alemania() -> void:
	GameManager.pais_seleccionado = "Alemania"

func _al_jugar() -> void:
	if GameManager.pais_seleccionado == "":
		GameManager.pais_seleccionado = "Argentina"
	get_tree().change_scene_to_file("res://Escenas/Mundo.tscn")
