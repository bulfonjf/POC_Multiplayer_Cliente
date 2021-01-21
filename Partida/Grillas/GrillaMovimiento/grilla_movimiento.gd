extends TileMap

var tiles_resaltados

func _ready():
	pass 

#Highlaitea un tile de movimiento dispoible
#Es llamada por orquestador.mostrar_movimiento_disponible():
func resaltar_tile(ubicacion: Vector2):
	self.set_cellv(ubicacion, 0)

#Highlaitea una lista de tiles de movimiento disponible:
func resaltar_celdas(lista_celdas: Array):
	for celda in lista_celdas:
		self.resaltar_tile(celda.vector)

#Borra los tiles highlaiteados:
func quitar_celdas_resaltadas():
	var tiles_resaltados = get_used_cells_by_id (0) #TODO revisar si se tiene que pisar tiles_resaltados o se crea una variable nueva
	for tile in tiles_resaltados:
		self.set_cellv(tile, -1)
