extends Reference
class_name Unidad

var clase = {}
var equipo 
var equipamiento = []
var slots = {}
var items = {}
var vida = 0

func _init(tropa, equipo_data):
	self.set_clase(tropa.clase)
	self.set_equipamiento(tropa.equipamiento)
	self.set_equipo(equipo_data)
	self.set_vida()
	
func set_clase(clase_data):
	self.clase = Data.clases_unidades[clase_data]
	for slot in clase.slots:
		self.slots[slot] = {"ocupado": false}

func get_clase():
	return self.clase		

func set_equipo(equipo_data):
	self.equipo = equipo_data

func set_equipamiento(equipamiento_data):
	for item in equipamiento_data:
		var item_data = Data.items[item]
		if self.puede_equipar(item_data):
			self.equipamiento.append(item)
			self.ocupar_slots(item_data.slots)

func ocupar_slots(slots_param : Array):
	for slot in slots_param:
		self.slots[slot] = {"ocupado" : true}

func liberar_slots(slots_param : Array):
	for slot in slots_param:
		self.slots[slot] = {"ocupado" : false}

func puede_equipar(item_data) -> bool:
	return clase_pude_equipar_item(item_data) and unidad_dispone_de_slots(item_data)

func clase_pude_equipar_item(item) -> bool:
	return Listas.comparar_arrays(item.clases, self.clase.puede_equipar)

func unidad_dispone_de_slots(item) -> bool:
	# Arrancamos diciendo que puede equiparse el item
	# y buscamos si alguno de los slots que requiere el item esta ocupado/(o no existe) en esta unidad (self)
	var slots_disponibles = true 
	if Listas.comparar_arrays(item.slots, self.slots.keys()):
		for slot in item.slots:
			var slot_ocupado = self.slots[slot].ocupado
			# si el slot esta ocupado, entonces no permitimos equipar el item
			# se puede hacer con menos variables pero estoy priorizando comprension mas rapida del metodo
			if slot_ocupado: 
				slots_disponibles = false
				break
	else:
		slots_disponibles = false
	return slots_disponibles

func get_movimientos():
	var movimientos = self.clase.movimientos
	return movimientos

func get_coste_de_movimiento(tipo_de_terreno):
	var coste_de_movimiento 
	if tipo_de_terreno in self.clase.coste_movimiento.keys(): 
		coste_de_movimiento = clase.coste_movimiento[tipo_de_terreno]
	else:
		coste_de_movimiento = 1000
	return coste_de_movimiento

func set_vida():
	self.vida = self.clase.vida
	
func actualizar_vida(danio : int):
	self.vida = self.vida - danio

func get_ataque():
	return self.clase.ataque

func get_defensa():
	return self.clase.defensa

func obtener_faccion():
	return equipo
