#WARNING: renombrar y organizar, ver si ronda esta en la carpeta correcta y si es un tipo de contexto nuevo crear la abstraccion
extends Node #TODO cambiar por Reference

var total_rondas = 1
var facciones = []
var faccion_activa : String = ""

func init(facciones_param : Array, faccion_activa_param : String):
	self.facciones = facciones_param 
	self.iniciar_turno(faccion_activa_param)

func iniciar_turno(faccion_param : String):
	if faccion_param in self.facciones:
		self.faccion_activa = faccion_param

func terminar_turno():
	var proxima_faccion = self.obtener_proxima_faccion()
	self.incrementar_ronda_si_corresponde()
	var faccion_proximo_turno = self.facciones[proxima_faccion]
	self.iniciar_turno(faccion_proximo_turno)

func obtener_proxima_faccion():
	var index_faccion_param = self.facciones.find(self.obtener_faccion_activa())
	var ultima_faccion = index_faccion_param == facciones.size() -1
	var faccion_not_found = index_faccion_param == -1
	if faccion_not_found:
		print("ERROR: se quiso terminar el turno de una faccion que no esta en el array de facciones de rondas.gd")
		#si la faccion no se encontro, el turno no se termina, pero ver si esto genera un problema, tipo el jugador nunca puede terminar la ronda
		return
	elif ultima_faccion:
		return 0
	else:
		return index_faccion_param + 1

func incrementar_ronda_si_corresponde():
		var faccion_index = self.facciones.find(self.obtener_faccion_activa())
		var si_es_ultima_faccion = faccion_index == self.facciones.size() -1
		if si_es_ultima_faccion:
			self.total_rondas += 1

# Indica si la faccion pasada por parametro es la faccion activa
func is_activa(faccion_param : String) -> bool:
	return self.obtener_faccion_activa() == faccion_param

func obtener_faccion_activa() -> String:
	return self.faccion_activa

func obtener_total_rondas():
	return self.total_rondas

func obtener_facciones():
	return self.facciones

func ya_jugo(faccion_param : String) -> bool:
	var index_faccion_param = self.facciones.find(faccion_param)
	var index_faccion_activa = self.facciones.find(self.obtener_faccion_activa())
	return index_faccion_param < index_faccion_activa 

func no_jugo(faccion_param : String) -> bool:
	return not (self.ya_jugo(faccion_param) or self.is_activa(faccion_param)) 
