extends TextureRect

func _ready() -> void:
	$BotonMenu.pressed.connect(_al_menu)

func _al_menu() -> void:
	GameManager.puntuacion_actual = 0
	get_tree().change_scene_to_file("res://Escenas/MenuPrincipal.tscn")
