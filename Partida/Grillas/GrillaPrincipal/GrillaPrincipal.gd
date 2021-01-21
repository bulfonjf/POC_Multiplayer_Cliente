extends TileMap

#Variables:
var celdas_ocupadas : Array


#Devuelve las celdas_ocupadas
func obtener_celdas_ocupadas():
	return celdas_ocupadas

#Marcar celda como desocupada:
func marcar_celda_como_libre(posicion: Pixel):
	var celda_a_liberar : Celda = self.pixeles_a_celda(posicion)
	for celda in celdas_ocupadas:
		if celda._eq(celda_a_liberar):
			celdas_ocupadas.erase(celda)
		
#Marcar celda como ocupada
func marcar_celda_como_ocupada(posicion: Pixel):
	var celda : Celda = self.pixeles_a_celda(posicion)
	if not celda._in(celdas_ocupadas):
		celdas_ocupadas.append(celda)
	
#Obtiene las celdas adyacentes a una celda
func obtener_celdas_adyacentes(celda : Celda) -> Array:
	var celda_derecha : Celda = Convertir.celda(celda.vector + Vector2.RIGHT)
	var celda_izquierda : Celda = Convertir.celda(celda.vector + Vector2.LEFT)
	var celda_superior : Celda =  Convertir.celda(celda.vector + Vector2.UP)
	var celda_inferior : Celda = Convertir.celda(celda.vector + Vector2.DOWN)
	var celdas_adyacentes : Array = [celda_derecha, celda_izquierda, celda_inferior, celda_superior]
	return celdas_adyacentes

func obtener_celdas_ocupadas_adyacentes(celda: Celda) -> Array:
	var celdas_adyacentes : Array = self.obtener_celdas_adyacentes(celda)
	var celdas_ocupadas : Array = self.obtener_celdas_ocupadas()
	var celdas_ocupadas_adyacentes : Array 
	for celda in celdas_adyacentes:
		if celda._in(celdas_ocupadas):
			celdas_ocupadas_adyacentes.append(celda)
	return celdas_ocupadas_adyacentes

#Devuelve posicion de los nodos hijos en formato grilla (te da la ubicacion de la celda en la grilla) (devuelve un Vector2)
func obtener_posicion_grilla(nodo : Node2D)-> Celda:
	var posicion = nodo.position
	var celda : Celda = Convertir.celda(world_to_map(posicion))
	return celda

#Devuelve posicion en celdas de un formato pixels (devuelve formato Celda)
func pixeles_a_celda(posicion : Pixel)-> Celda:
	var celda : Celda = Convertir.celda(world_to_map(posicion.vector))
	return celda

#Devuelve posicion de las celdas en formato pixels (devuelve un Pixel)
func celdas_a_pixeles(posicion : Celda)-> Pixel:
	var pixeles = map_to_world(posicion.vector)
	return pixeles

#Devuelve posicion de las celdas en formato pixels (devuelve un Vector2)
func obtener_posicion_pixels(celdas: Celda)-> Array:
	var posiciones : Array
	for celda in celdas:
		posiciones.append(map_to_world(celda.vector))
	return posiciones

func convertir_a_celda_y_obtener_centro(posicion : Vector2):
	var celda = Convertir.celda(posicion)
	var centro = self.obtener_centro_celda(celda)
	var pixel_centro = Convertir.pixel(centro)
	return pixel_centro

#Dado una posicion en pixeles, devuelve el centro de la celda en pixeles.
func obtener_centro_celda_desde_un_pixel(posicionEnPixeles : Pixel) -> Vector2:
	var celda = pixeles_a_celda(posicionEnPixeles)
	return obtener_centro_celda(celda)

#Dada una celda, devuelve su centro en pixeles
func obtener_centro_celda(celda : Celda)-> Vector2:
	var esquina_superior_izquierda_pixeles = celdas_a_pixeles(celda)
	return esquina_superior_izquierda_pixeles + self.get_cell_size() / 2

#Devuelve la data de una celda
func obtener_info_de_celda(ubicacion_celda: Celda):
	var tile_id = self.get_cellv(ubicacion_celda.vector)
	if(tile_id == -1):
		return Data.terrenos["empty"]
	var tile_name = self.tile_set.tile_get_name(tile_id)
	return Data.terrenos[tile_name]
	
#Devuelve el tamaño de la grilla en pixeles
func obtener_limites():
		var celda_size = self.get_cell_size()
		var celda = self.get_used_cells()[-1]
		var limites =  celda * celda_size.x + celda_size # cantidad de celdas * tamanio en pixeles + 1 celda mas porquue las coordenadas son de  la esquina superior izquierda
		return limites
		
