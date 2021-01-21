extends Node2D

var edificio_clase = load("res://Partida/Edificios/edificio_clase.gd")
var edificio : Edificio

func init(edificio_partida, posicion : Pixel, faccion : String):
	self.edificio = edificio_clase.new(edificio_partida)
	self.position = posicion.vector
	self.add_to_group(faccion)
	self.add_to_group("Edificio")
	
func obtener_info():
	return self.edificio
func _ready():
	pass # Replace with function body.
