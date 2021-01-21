extends "res://UI/Componentes/categoria.gd"

#Menu lateral mapa llama a esta funcion, le pasa el actor activo.
func init_unidad(unidad : Unidad):
	var titulo = unidad.clase.nombre
	var dic = {
		"vida": unidad.vida,
		"ataque": unidad.get_ataque(),
		"defensa": unidad.get_defensa(),
		"items": "",
		"movimientos": ""

	}
	self.init_categoria(dic, titulo)

func _ready():
	pass
