class_name Faccion

var nombre : String
var recursos : Dictionary 
var tropas : Array

func _init(partida_data):
    self.nombre = partida_data.nombre
    
func agregar_unidad(tropa):
    tropas.append(tropa)

func _eq(la_otra_faccion : Faccion) -> bool:
    return self.nombre == la_otra_faccion.nombre