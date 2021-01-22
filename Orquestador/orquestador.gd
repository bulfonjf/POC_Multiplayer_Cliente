extends Node

# COMPONENTES
onready var menu_lateral_mapa : Control = $CanvasLayer/UI/MargenUI/Panel/MenuLateralMapa
onready var menu_unidad : Control = $CanvasLayer/MenuUnidad
onready var menu_base : Control = $CanvasLayer/MenuBase
onready var grilla_principal: TileMap = $GrillaPrincipal
onready var grilla_movimiento: TileMap = $GrillaMovimiento
onready var algoritmo_movimiento: Node2D = $GrillaPrincipal/AlgoritmoMovimiento
onready var partida : Script = load("res://Partida/partida.gd")
onready var faccion = load("res://Partida/Facciones/faccion_nodo.gd")
onready var edificio = load("res://Partida/Edificios/Edificio.tscn")
onready var edificio_base = load("res://Partida/Edificios/Base.tscn")
onready var celda_seleccion : Node2D = $CeldaSeleccion
onready var camara2D: Node2D = $Camera2D
onready var panel_superiorHbox: Control = $CanvasLayer/UI/Panel_superior/Panel/HBoxPanelSuperior
# VARIABLES
onready var tamanio_de_celda : Vector2 = grilla_principal.get_cell_size()
onready var celdas_con_nodos = {}
#SEÑALES
var partida2 
# READY

func init(_partida):
	partida2 = _partida
	pass

func _ready():
	preparar_camara()
	preparar_ronda(partida2)
	preparar_facciones(partida2)
	preparar_edificios(partida2)

func preparar_camara():
	var limites = grilla_principal.obtener_limites()
	var viewport_limites = get_viewport().get_size()
	camara2D.init(limites, viewport_limites)

func preparar_ronda(_partida):
	var facciones_nombres = []
	for _faccion in _partida.facciones: # reemplazar con list comprehension o algo asi
		facciones_nombres.append(_faccion.nombre)

	Ronda.init(facciones_nombres, partida.facciones[0].nombre)
	menu_lateral_mapa.mostrar_info_ronda()
	panel_superiorHbox.actualizar_panel(Ronda.obtener_faccion_activa())

func preparar_facciones(_partida):
	for faccion_data in _partida.facciones:
		var faccion_nodo = faccion.new(faccion_data)
		faccion_nodo.name = faccion_nodo.get_faccion().nombre
		self.add_child(faccion_nodo)
		faccion_nodo.connect("guardar_celda_signal", self, "guardar_celda_nodo")
		for unidad in faccion_data.tropas:
			agregar_unidad(unidad, faccion_nodo)

func agregar_unidad(unidad, faccion_nodo):
	var posicion : Vector2 = unidad.posicion
	var posicionUnidadEnCeldas : Celda = Convertir.celda(posicion)
	var posicionUnidad_Vector : Vector2 = grilla_principal.obtener_centro_celda(posicionUnidadEnCeldas)
	var posicionUnidad_Pixel : Pixel = Convertir.pixel(posicionUnidad_Vector)
	faccion_nodo.agregar_unidad(unidad, posicionUnidad_Pixel)
	grilla_principal.marcar_celda_como_ocupada(posicionUnidad_Pixel)

func preparar_edificios(_partida):
	for faccion_data in _partida.facciones:
		for edificio_data in _partida.edificios:
			
			if edificio_data.nombre == "base":
				var base = edificio_base.instance()
				self.add_child(base)
				var pixel_centro_celda = grilla_principal.convertir_a_celda_y_obtener_centro(edificio_data.posicion)
				var faccion = faccion_data.nombre
				base.init(edificio_data, pixel_centro_celda, faccion)
				self.guardar_celda_nodo(base)
				
			else:
				var nuevo_edificio = edificio.instance()
				self.add_child(nuevo_edificio)
				var pixel_centro_celda = grilla_principal.convertir_a_celda_y_obtener_centro(edificio_data.posicion)
				var faccion = faccion_data.nombre
				nuevo_edificio.init(edificio_data, pixel_centro_celda, faccion)
				grilla_principal.marcar_celda_como_ocupada(pixel_centro_celda)
				self.guardar_celda_nodo(nuevo_edificio)
		
#La Unidad llama a esta funcion cuando es clickeado #Setea el contexto de seleccion de tropa
#Muestra el MenuLateral en la posicion del tropa
func click_en_tropa(tropa, posicion_click):
		SeleccionTropa.dispose()	
		SeleccionTropa.activar_contexto()
		SeleccionTropa.set_actor_activo(tropa)
		SeleccionTropa.add_dispose_menu(self.menu_lateral)
		SeleccionTropa.add_dispose_menu_mapa(self.menu_lateral_mapa)
		var adyacentes : Array = grilla_principal.obtener_celdas_ocupadas_adyacentes(grilla_principal.obtener_posicion_grilla(tropa))
		menu_lateral.mostrar(posicion_click, adyacentes)
		menu_lateral_mapa.mostrar_info_unidad()

#Highlaitea las grillas de movimiento disponibles
#la llama menu_lateral cuando hacen click en mover [func _on_Mover_pressed():]
func mostrar_movimiento_disponible(): #WARNING Validad que el contexto sea el correcto. Si el jugador está atacando, no puede mover. 
	SeleccionTropa.add_dispose_grilla_movimiento(grilla_movimiento)
	SeleccionTropa.activar_accion_movimiento()
	SeleccionTropa.add_dispose_acciones()
	var actor_activo = SeleccionTropa.get_actor_activo()
	var celdas_de_movimiento = algoritmo_movimiento.obtener_celdas_donde_se_puede_mover(actor_activo)
	SeleccionTropa.set_celdas_de_movimiento(celdas_de_movimiento)
	grilla_movimiento.resaltar_celdas(celdas_de_movimiento)
	
func mostrar_menu_base():
	self.menu_base.visible = true

#Grilla llama a esta funcion cuando es clickeada:
#Llama a mover_actor_actual, la funcion de abajo
func click_en_grilla(celda_clickeada):
	var celda = grilla_principal.pixeles_a_celda(Convertir.pixel(celda_clickeada))
	if SeleccionTropa.si_movimiento_activado():
		if SeleccionTropa.si_celda_resaltada(celda): 
			mover_actor_activo(celda_clickeada)
		else:
			SeleccionTropa.dispose()
	

#Mueve al actor a la celda de destino:
#La llama "click_en_grilla"[orquestador.click_en_grilla]
func mover_actor_activo(posicion_final : Vector2):
	var actor_activo = SeleccionTropa.get_actor_activo()
	grilla_principal.marcar_celda_como_libre(Convertir.pixel(actor_activo.position))
	var posicion_en_pixeles : Vector2 = grilla_principal.obtener_centro_celda_desde_un_pixel(Convertir.pixel(posicion_final))
	actor_activo.set_position(posicion_en_pixeles)
	grilla_principal.marcar_celda_como_ocupada(Convertir.pixel(actor_activo.position))
	self.guardar_celda_nodo(actor_activo)
	SeleccionTropa.dispose()

#Agrega un actor en la grilla_principal
func agregar_actor(actor: Node2D, posicion: Vector2):
	actor.set_position(posicion)
	grilla_principal.add_child(actor)
	grilla_principal.marcar_celda_como_ocupada(Convertir.pixel(actor.position))	 

#La llama menu_lateral cuanndo se hace click en atacar
func atacar():
	SeleccionTropa.activar_ataque()
	SeleccionTropa.add_dispose_acciones()
	SeleccionTropa.add_dispose_menu(self.menu_lateral)
	

func crear_unidad_en_base(clase_unidad, equipamiento_defensa, equipamiento_ataque):
	var posicion = Vector2(4,6)
	var unidad = {
		"clase": clase_unidad,
		"equipamiento": [],
		"posicion": posicion
	}
	var faccion_nodo = self.get_node(Ronda.obtener_faccion_activa())
	self.agregar_unidad(unidad, faccion_nodo)

func _unhandled_input(event): #to-do, demasiada conversiones de formato(pixel,celda) coordinar con la funcion de abajo y con celda_seleccion
	if event is InputEventMouseButton && !event.is_pressed():
		var posicion = event.position * camara2D.zoom + camara2D.position  #toma la posicion del clickeo en pixeles
		var click_en_pixel =Convertir.pixel(posicion)
		var centro_de_celda = grilla_principal.obtener_centro_celda_desde_un_pixel(click_en_pixel)
		celda_seleccion.mover(centro_de_celda)
		self.click_en_pantalla(centro_de_celda, event.position)
		get_tree().set_input_as_handled()

func guardar_celda_nodo(nodo: Node2D):
	var posicion_pixel =Convertir.pixel(nodo.position)
	var posicion_celda = grilla_principal.pixeles_a_celda(posicion_pixel)
	celdas_con_nodos[nodo.get_instance_id()] = posicion_celda.vector
	
	
func obtener_nodo_en_celda(celda_vector2: Vector2) -> Node2D:
	var celda = Convertir.celda(celda_vector2)
	for nodo_id in celdas_con_nodos.keys():
		if celdas_con_nodos[nodo_id] == celda.vector:
			return nodo_id
	return null

func click_en_pantalla(centro_celda_clickeada : Vector2, evento_posicion):	#to-do, demasiada conversiones de formato(pixel,celda), coordinar con la funcion de arriba
	var click_en_pixel =Convertir.pixel(centro_celda_clickeada)				#Todo, ver como distribuir esto en distintos componentes
	var click_formato_celda = grilla_principal.pixeles_a_celda(click_en_pixel)
	var nodo_en_celda = self.obtener_nodo_en_celda(click_formato_celda.vector)
	if nodo_en_celda:
		var nodo = instance_from_id(nodo_en_celda)
		var info_nodo = nodo.obtener_info()
		
		if info_nodo is Edificio and info_nodo.obtener_data().nombre == "base":
			if info_nodo.obtener_faccion() == Ronda.obtener_faccion_activa():
				self.mostrar_menu_base()
		elif info_nodo is Unidad:
			if info_nodo.obtener_faccion() == Ronda.obtener_faccion_activa():
				self.click_en_tropa(nodo, evento_posicion)
			else:
				var actor_activo = SeleccionTropa.data_contexto.get("actor_activo")
				if  "atacando" in SeleccionTropa.get_acciones():
						actor_activo.animar()
						var danio = Ataque.calcular_danio(actor_activo, nodo)
						nodo.actualizar_vida(danio)
						SeleccionTropa.dispose()
	else:
		self.click_en_grilla(centro_celda_clickeada)


func borrar_nodo_en_celda(nodo) :
	celdas_con_nodos.erase(nodo.get_instance_id()) 

func borrar():
	var actor_activo = SeleccionTropa.get_actor_activo()
	self.borrar_nodo_en_celda(actor_activo)
	grilla_principal.marcar_celda_como_libre(Convertir.pixel(actor_activo.position))
	actor_activo.queue_free()
	SeleccionTropa.dispose()
	print(actor_activo.unidad)




	# --------------------------------------------------
	# ---------------- Orquestador 2.0 -----------------
	# --------------------------------------------------

func _on_click_unidad(accion):
	Gamestate.enviar_al_servidor(accion)

func _on_click_atacar(accion):
	Gamestate.enviar_al_servidor(accion)
