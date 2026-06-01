extends Node2D

@export var escenas_calle: Array[PackedScene]
@export var escenas_grada: Array[PackedScene]
@export var limite_calle_y: float = -67.0
@export var cantidad_por_spawn: int = 4
@export var margen_spawn_x: float = 300.0

var temporizador: Timer
var tamano_grilla: float = 32.0
var velocidad_base: float = 150.0
var intervalo_min: float = 0.2
var intervalo_max: float = 0.7

func _ready() -> void:
	temporizador = Timer.new()
	add_child(temporizador)
	temporizador.wait_time = randf_range(intervalo_min, intervalo_max)
	temporizador.timeout.connect(_spawnear)
	temporizador.start()

func _spawnear() -> void:
	temporizador.wait_time = randf_range(intervalo_min, intervalo_max)
	var camara := get_viewport().get_camera_2d()
	var camara_x: float = 0.0
	var camara_y: float = 0.0
	if camara != null:
		camara_x = camara.global_position.x
		camara_y = camara.global_position.y
	var mitad_ancho: float = get_viewport_rect().size.x / 2.0
	for i in cantidad_por_spawn:
		var pos_y: float = camara_y + randf_range(-600.0, 600.0)
		pos_y = snapped(pos_y, tamano_grilla)
		var zona := "calle"
		var escena: PackedScene = null
		if pos_y <= limite_calle_y:
			zona = "grada"
			escena = escenas_grada.pick_random()
		else:
			escena = escenas_calle.pick_random()
		if escena == null:
			continue
		var obstaculo = escena.instantiate()
		obstaculo.tipo_zona = zona
		var va_derecha: bool = randi() % 2 == 0
		obstaculo.velocidad = velocidad_base + randf() * 60.0
		obstaculo.direccion = 1.0 if va_derecha else -1.0
		var pos_x: float = camara_x - mitad_ancho - margen_spawn_x if va_derecha else camara_x + mitad_ancho + margen_spawn_x
		obstaculo.position = Vector2(pos_x, pos_y)
		get_parent().add_child(obstaculo)
