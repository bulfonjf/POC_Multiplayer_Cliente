extends KinematicBody2D


onready var id = "Garett_" + str(RandomNumberGenerator.new())
var unidad_clase = load("res://Partida/Unidades/unidad_clase.gd")
onready var control_vida : Control = load("res://UI/Control_Vida.tscn").instance()
var unidad : Unidad
var _unused

signal click_unidad(accion)

func _ready():
	var orquestador = get_tree().get_root().get_node("Orquestador")
	_unused = self.connect("click_unidad", orquestador, "_on_click_unidad")

	self.add_child(control_vida)
	control_vida.iniciar(self.unidad)

func _on_Unidad_input_event(viewport, event, shape_idx):
	# to-do la unidad podria ser seleccionada con el teclado tamb (mediante celda seleccion como warsong)
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.is_pressed():
		accion = {
			"accion": "click_unidad",
			"id": id,
			}
		emit_signal(click_unidad, accion)
 
func get_unidad() -> Unidad:
	return unidad

func init(tropa, equipo):
	unidad = unidad_clase.new(tropa, equipo)
	
func actualizar_vida(danio : int):
	self.unidad.actualizar_vida(danio)
	self.control_vida.actualizar_vida(unidad)


func mover(posicion : Pixel):
	self.position = posicion.vector
	self.control_vida.actualizar_posicion()
	
func obtener_info():
	return unidad

func animar():
	$AnimationPlayer.play("caminar")
