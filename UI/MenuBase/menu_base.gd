extends Control


var clase_unidad = ""
var equipamiento_defensa = []
var equipamiento_ataque = []

signal crear_unidad_en_base_signal(clase_unidad, equipamiento_defensa, equipamiento_ataque)


func _ready():
	pass 
	
func _on_FigtherTB_pressed():
	self.clase_unidad = "fighter"

func _on_CaballeroTB_pressed():
	self.clase_unidad = "caballero"
	
func _on_RangoTB_pressed():
	self.clase_unidad = "rango"

func _on_CrearUnidadBtn_pressed():
	emit_signal("crear_unidad_en_base_signal", self.clase_unidad, self.equipamiento_defensa, self.equipamiento_ataque)

func _on_CerrarBtn_pressed():
	self.visible = false

func obtener_clase_unidad():
	return self.clase_unidad

func obtener_equipamiento_defensa():
	return equipamiento_defensa

func obtener_equipamiento_ataque():
	return equipamiento_ataque
