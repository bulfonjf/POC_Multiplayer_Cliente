extends "contexto.gd"


func dispose():
	self.data_contexto = {}
	self.acciones = []
	self.desactivar_contexto()
	self.base_dispose()	
	
	
func activar_contexto():
	self.activo = true;
	
