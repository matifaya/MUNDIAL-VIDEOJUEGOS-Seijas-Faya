# Proyecto: El Hincha Invasor
# Alumno: Matias Faya
# Instituto Politécnico Modelo (IPM)

extends Area2D

@export var escala_jugador: Vector2 = Vector2(0.5, 0.5)
@export var velocidad_camara: float = 120.0
@export var offset_inicial_camara: float = 300.0
@export var distancia_paso: int = 48

const LIMITE_IZQ: float = 64.0
const LIMITE_DER: float = 1888.0
const MITAD_ALTO_PANTALLA: float = 640.0
const LIMITE_CAMARA_Y: float = -3470.0
const TIEMPOS_COOLDOWN: Dictionary = {
	"Argentina": 4.0,
	"Brasil": 6.0,
	"Japon": 8.0,
	"Inglaterra": 5.0,
	"Alemania": 7.0
}

var inicio_y: float = 0.0
var en_movimiento: bool = false
var esta_muerto: bool = false
var tiene_escudo: bool = false
var es_intangible: bool = false
var es_invulnerable: bool = false
var habilidad_lista: bool = true
var interpolacion_actual: Tween = null
var camara: Camera2D = null

func _ready() -> void:
	scale = escala_jugador
	inicio_y = global_position.y
	area_entered.connect(_al_colisionar)
	area_exited.connect(_al_salir)
	camara = get_node("Camera2D")
	camara.set_as_top_level(true)
	camara.position_smoothing_enabled = false
	camara.limit_top = -10000000
	camara.limit_bottom = 10000000
	camara.global_position = global_position
	camara.global_position.y -= offset_inicial_camara

func _process(delta: float) -> void:
	if esta_muerto:
		return
	if camara.global_position.y > LIMITE_CAMARA_Y:
		camara.global_position.y -= velocidad_camara * delta
	else:
		camara.global_position.y = LIMITE_CAMARA_Y
	var borde_inferior: float = camara.global_position.y + MITAD_ALTO_PANTALLA
	if global_position.y > borde_inferior:
		_morir("arrestado")
		return
	_leer_habilidad()
	_leer_movimiento()

func _leer_habilidad() -> void:
	if Input.is_action_just_pressed("ui_accept") and habilidad_lista and not en_movimiento:
		_activar_habilidad()

func _leer_movimiento() -> void:
	if en_movimiento:
		return
	var direccion := Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"):
		direccion = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		direccion = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		direccion = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direccion = Vector2.RIGHT
	if direccion != Vector2.ZERO:
		mover(direccion)

func mover(direccion: Vector2) -> void:
	en_movimiento = true
	var destino: Vector2 = global_position + direccion * distancia_paso
	destino.x = clamp(destino.x, LIMITE_IZQ, LIMITE_DER)
	destino.y = min(destino.y, inicio_y)
	if direccion == Vector2.UP and destino.y < global_position.y:
		GameManager.agregar_punto()
		$AnimatedSprite2D.play("caminando")
	elif direccion == Vector2.DOWN:
		$AnimatedSprite2D.play("pasoparaatras")
	elif direccion == Vector2.LEFT:
		$AnimatedSprite2D.play("default")
	elif direccion == Vector2.RIGHT:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("caminando")
	interpolacion_actual = create_tween()
	interpolacion_actual.tween_property(self, "global_position", destino, 0.1)
	await interpolacion_actual.finished
	en_movimiento = false
	$AnimatedSprite2D.play("default")

func _activar_habilidad() -> void:
	habilidad_lista = false
	match GameManager.pais_seleccionado:
		"Argentina":
			_avalancha()
		"Brasil":
			_amague()
		"Japon":
			_limpieza()
		"Inglaterra":
			_empujon()
		"Alemania":
			_maquina()
	_iniciar_enfriamiento()

func _iniciar_enfriamiento() -> void:
	var duracion: float = TIEMPOS_COOLDOWN.get(GameManager.pais_seleccionado, 5.0)
	GameManager.progreso_habilidad = 0.0
	var tw := create_tween()
	tw.tween_property(GameManager, "progreso_habilidad", 1.0, duracion)
	await tw.finished
	habilidad_lista = true

func _avalancha() -> void:
	en_movimiento = true
	es_invulnerable = true
	var destino: Vector2 = global_position + Vector2.UP * distancia_paso * 2
	destino.x = clamp(destino.x, LIMITE_IZQ, LIMITE_DER)
	destino.y = min(destino.y, inicio_y)
	GameManager.agregar_punto()
	GameManager.agregar_punto()
	$AnimatedSprite2D.play("caminando")
	interpolacion_actual = create_tween()
	interpolacion_actual.tween_property(self, "global_position", destino, 0.15)
	await interpolacion_actual.finished
	es_invulnerable = false
	en_movimiento = false
	$AnimatedSprite2D.play("default")

func _amague() -> void:
	es_intangible = true
	await get_tree().create_timer(2.0).timeout
	es_intangible = false

func _limpieza() -> void:
	tiene_escudo = true

func _empujon() -> void:
	var objetivo_pos: Vector2 = Vector2(global_position.x, global_position.y - distancia_paso)
	var obstaculos := get_tree().get_nodes_in_group("obstaculos")
	var objetivo: Node2D = null
	var distancia_min: float = INF
	for obs in obstaculos:
		if not obs is Node2D:
			continue
		var d: float = objetivo_pos.distance_to(obs.global_position)
		if d < distancia_min:
			distancia_min = d
			objetivo = obs
	if is_instance_valid(objetivo):
		objetivo.queue_free()

func _maquina() -> void:
	for grupo in ["calle", "grada", "cancha"]:
		for obs in get_tree().get_nodes_in_group(grupo):
			if obs.has_method("reducir_velocidad"):
				obs.reducir_velocidad()
	await get_tree().create_timer(3.0).timeout
	for grupo in ["calle", "grada", "cancha"]:
		for obs in get_tree().get_nodes_in_group(grupo):
			if obs.has_method("restaurar_velocidad"):
				obs.restaurar_velocidad()

func _al_colisionar(area: Area2D) -> void:
	if es_intangible or es_invulnerable or esta_muerto:
		return
	if "puerta" in area.name.to_lower():
		visible = false
		return
	if "arbitro" in area.name.to_lower():
		get_tree().change_scene_to_file("res://Escenas/ganaste.tscn")
		return
	if tiene_escudo:
		tiene_escudo = false
		area.queue_free()
		return
	var animacion: String = "atropellado"
	if area.is_in_group("grada") or area.is_in_group("cancha"):
		animacion = "arrestado"
	_morir(animacion)

func _al_salir(area: Area2D) -> void:
	if "puerta" in area.name.to_lower():
		visible = true

func _morir(animacion: String) -> void:
	esta_muerto = true
	if is_instance_valid(interpolacion_actual):
		interpolacion_actual.kill()
	set_deferred("monitoring", false)
	$AnimatedSprite2D.play(animacion)
	await $AnimatedSprite2D.animation_finished
	get_tree().get_root().find_child("PanelGameOver", true, false).show()
