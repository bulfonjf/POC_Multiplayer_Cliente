extends Node2D

onready var vboxgeneral = $Panel/VBoxContainer
onready var boton_lista_equipos = $Panel/VBoxContainer/HBoxContainer/lista_equipos
onready var boton_lista_facciones = $Panel/VBoxContainer/HBoxContainer/lista_facciones
onready var nombre_edit = $Panel/VBoxContainer/HBoxContainer/nombre_edit
onready var boton_conectar = $Panel/VBoxContainer/Button_Conectar

signal conectar_a_servidor

var _ignore 


func _ready() -> void:
	_ignore = Gamestate.connect("lobby_mostrar_jugadores", self, "crear_label_jugadores")
	_ignore = Gamestate.connect("jugador_desconectado", self, "borrar_label_jugadores")
	_ignore = Gamestate.connect("connection_succeeded", self, "bloquear_boton_conectar")
	_ignore = Gamestate.connect("connection_failed", self, "desbloquear_boton_conectar")
	_ignore = Gamestate.connect("server_disconnected", self, "desbloquear_boton_conectar")
	_ignore = Gamestate.connect("lobby_registrar_equipos", self, "registrar_equipos")
	_ignore = Gamestate.connect("lobby_registrar_facciones", self, "registrar_facciones")
	pass # Replace with function body.

func _on_Button_Conectar_pressed():
	emit_signal("conectar_a_servidor")

func crear_label_jugadores(_id, _nombre_jugador):
	var label = Label.new();
	label.name = str(_id)
	label.text = "cliente" + str(_nombre_jugador) + " con id:" + str(_id);
	vboxgeneral.add_child(label);

func borrar_label_jugadores(_id):
	var nombre_label = str(_id)
	var label = get_tree().get_root().find_node(str(nombre_label) , true, false)
	label.queue_free()
	pass

func bloquear_boton_conectar():
	boton_conectar.disabled = true

func desbloquear_boton_conectar():
	boton_conectar.disabled = false

func registrar_equipos(_equipos):
	boton_lista_equipos.aniadir_equipos(_equipos)

func registrar_facciones(_facciones):
	boton_lista_facciones.aniadir_facciones(_facciones)
