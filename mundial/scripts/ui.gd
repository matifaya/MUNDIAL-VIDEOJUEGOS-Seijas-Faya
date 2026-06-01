extends CanvasLayer

@onready var etiqueta_puntos: Label = $PuntosLabel
@onready var panel_game_over: Panel = $PanelGameOver

func _ready() -> void:
	panel_game_over.visible = false
	$PanelGameOver/BotonReiniciar.pressed.connect(_al_reiniciar)
	$PanelGameOver/BotonMenu.pressed.connect(_al_menu)

func _process(_delta: float) -> void:
	etiqueta_puntos.text = str(GameManager.puntuacion_actual)
	$HabilidadCooldown.value = GameManager.progreso_habilidad * 100.0

func _al_reiniciar() -> void:
	panel_game_over.visible = false
	GameManager.reiniciar()

func _al_menu() -> void:
	GameManager.puntuacion_actual = 0
	get_tree().change_scene_to_file("res://Escenas/MenuPrincipal.tscn")
