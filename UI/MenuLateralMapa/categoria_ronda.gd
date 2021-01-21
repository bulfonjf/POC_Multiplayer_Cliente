extends "res://UI/Componentes/categoria.gd"

func init():
	var titulo = "Ronda: " + str(Ronda.obtener_total_rondas())
	var dic = {
		"facciones": Ronda.obtener_facciones()
	}
	self.init_categoria(dic, titulo)

