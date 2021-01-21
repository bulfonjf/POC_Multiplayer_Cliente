extends "res://addons/gut/test.gd"

var sut = null

func after_each():
	autoqfree(sut)
	sut = null
""" 	assert_no_new_orphans() """


func test_crear_unidad():
	var partida_data ={
				"clase" : "fighter",
				"equipamiento" : ["pechera de cuero", "espada"], #// ojo, usar los mismos nombres que items
			}

	var equipo = {}
	sut = load("res://Partida/Unidades/unidad_clase.gd").new(partida_data, equipo)
	
	assert_is(sut, Unidad, "verifica que el new de Unidad cree una instancia de la clase Unidad")
	
func test_clase_puede_equipar():
	var partida_data ={
				"clase" : "fighter",
				"equipamiento" : [], 
			}

	var equipo = {}
	var item = { 
			"nombre": "pechera de cuero",
			"clases" : ["armadura_ligera"],
			"slots": ["pecho"],
			"modificadores": {
				"defensa_base" : 5,
				"movimiento" : -1,
			}
		}
	
	sut = load("res://Partida/Unidades/unidad_clase.gd").new(partida_data, equipo)
	var result = sut.clase_pude_equipar_item(item)
	assert_true(result, "Verifica que un figther pueda equipar una pechera de cuero, debe devolver true")

func test_puede_equipar():
	var partida_data ={
				"clase" : "fighter",
				"equipamiento" : ["pechera de cuero", "espada"], #// ojo, usar los mismos nombres que items
			}

	var equipo = {}
	sut = load("res://Partida/Unidades/unidad_clase.gd").new(partida_data, equipo)

	assert_eq_deep(sut.equipamiento, partida_data.equipamiento)

func test_set_equipamiento():
	var partida_data ={
				"clase" : "fighter",
				"equipamiento" : ["pechera de cuero", "espada"], #// ojo, usar los mismos nombres que items
			}

	var equipo = {}
	sut = load("res://Partida/Unidades/unidad_clase.gd").new(partida_data, equipo)
	
	var resultado_esperado = {"pecho" : {"ocupado" : true }, "mano_izquierda" : {"ocupado" : true }, "mano_derecha" : {"ocupado" : true }}
	
	assert_eq_deep(sut.slots, resultado_esperado)