extends KinematicBody2D


onready var id = "Garett_" + str(RandomNumberGenerator.new())
var unidad_clase = load("res://Partida/Unidades/unidad_clase.gd")
onready var control_vida : Control = load("res://UI/Control_Vida.tscn").instance()
var unidad : Unidad

 
func get_unidad() -> Unidad:
	return unidad

func init(tropa, equipo):
	unidad = unidad_clase.new(tropa, equipo)
	
	
	
func _ready():
	self.add_child(control_vida)
	control_vida.iniciar(self.unidad)
	
	pass 
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
