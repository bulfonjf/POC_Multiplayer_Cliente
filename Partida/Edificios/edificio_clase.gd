extends Reference
class_name Edificio

var faccion = ""
var data = {}

func _init(edificio_partida): 
	self.data = Data.edificios[edificio_partida.nombre]
	self.faccion = edificio_partida.faccion

func set_faccion(faccion_nombre):
	self.faccion = faccion_nombre

func obtener_data():
	return data

func obtener_faccion():
	return faccion