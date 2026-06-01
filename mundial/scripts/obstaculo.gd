extends Area2D

@export var tipo_zona: String = "calle"
@export var direccion: int = 1
var velocidad: float = 200.0
var velocidad_original: float = 0.0

func _ready() -> void:
	velocidad_original = velocidad
	add_to_group("obstaculos")
	add_to_group(tipo_zona)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(delta: float) -> void:
	position.x += velocidad * direccion * delta

func reducir_velocidad() -> void:
	velocidad = velocidad_original * 0.5

func restaurar_velocidad() -> void:
	velocidad = velocidad_original
