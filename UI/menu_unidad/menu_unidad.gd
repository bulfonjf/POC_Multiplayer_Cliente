extends "res://componentes/componente_controlador.gd"

onready var ataque_boton : Button = $ContenedorV/Atacar
onready var mover_boton : Button = $ContenedorV/Mover
onready var borrar_boton : Button = $ContenedorV/Borrar
onready var contenedor_vertical : VBoxContainer = $ContenedorV

var _unused
const mostrar_componente = "mostrar"
const deshabilitar = "deshabilitar"

# Signals
signal click_atacar(accion)
signal click_mover(accion)
signal click_borrar(accion)

# Ready
func _ready():
	_unused = CreadorVista.connect("mostrar_menu_unidad_signal", self, "aplicar_configuracion")

	var orquestador = get_tree().get_root().get_node("Orquestador")
	_unused = self.connect("click_atacar", orquestador, "_on_click_atacar")
	_unused = self.connect("click_mover", orquestador, "_on_click_mover")
	_unused = self.connect("click_borrar", orquestador, "_on_click_borrar")

	self.agregar_hijo(ataque_boton.get_instance_id())
	self.agregar_hijo(mover_boton.get_instance_id())
	self.agregar_hijo(borrar_boton.get_instance_id())
	
	# Preparar la configuracion por defecto de los hijos
	self.configuracion[ataque_boton.name.to_lower()] = {
        mostrar_componente: true,
        deshabilitar: false
    }
	self.configuracion[mover_boton.name.to_lower()] = {
        mostrar_componente: true,
        deshabilitar: false
	}
	
	self.configuracion[borrar_boton.name.to_lower()] = {
        mostrar_componente: true,
        deshabilitar: false
    }
	
#Funcion que se ejecuta cuando se hace click en el boton "Mover"
func _on_Mover_pressed():
	var accion = {
        "accion": "mover"
    }
	emit_signal("click_mover", accion)

func _on_Atacar_pressed():
	var accion = {
        "accion": "atacar"
    }
	emit_signal("click_atacar", accion)

func _on_Borrar_pressed():
	var accion = {
        "accion": "borrar"
    }
	emit_signal("click_borrar", accion)
