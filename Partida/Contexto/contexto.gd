extends Node

var activo = false
var data_contexto = {}
var finalizar_contexto = {}
var acciones = []
	

func base_dispose():
	for metodo_a_ejecutar in finalizar_contexto.keys():
		#var argumentos = finalizar_contexto[metodo_a_ejecutar]["argumentos"]
		finalizar_contexto[metodo_a_ejecutar]["dispose"].call_func()
	self.finalizar_contexto = {}

func desactivar_contexto():
	self.activo = false

func agregar_dispose(funcion):
	self.finalizar_contexto[len(self.finalizar_contexto)] = {
		"dispose" : funcion
	}
