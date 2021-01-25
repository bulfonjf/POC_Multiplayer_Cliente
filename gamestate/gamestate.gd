extends Node

# Game port and ip
const ip = "127.0.0.1"
const DEFAULT_PORT = 44444

# Signal to let GUI know whats up
signal connection_failed()
signal connection_succeeded()
signal server_disconnected()
signal jugador_desconectado(id)
signal lobby_mostrar_jugadores(jugador_id, jugador_nombre)
signal lobby_registrar_equipos(equipos)
signal lobby_registrar_facciones(facciones)
var nombre = "nombre_gamestate"
var _ignore
var my_name = "Client"
# Players dict stored as id:name
var players = {}

func _ready():
	_ignore = get_tree().connect("connected_to_server", self, "_connected_ok")
	_ignore = get_tree().connect("connection_failed", self, "_connected_fail")
	_ignore = get_tree().connect("server_disconnected", self, "_server_disconnected")
	#_ignore = get_tree().connect("network_peer_connected", self, "registrar_jugador")
	_ignore = get_tree().connect("network_peer_disconnected", self,"unregister_jugador")
	_ignore = get_tree().get_root().get_node("Lobby").connect("conectar_a_servidor", self, "connect_to_server")
	_ignore = get_tree().get_root().get_node("Lobby/Panel/VBoxContainer/HBoxContainer/nombre_edit").connect("updatear_nombre", self, "updatear_nombre")
	
	
	
func connect_to_server():
	var host = NetworkedMultiplayerENet.new()
	var connection = host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	print("create_client result", connection)
	
# Callback from SceneTree, called when connect to server
func _connected_ok():
	#esta señal es tomada por el "boton conectar", para bloquearse una vez que el cliente se conecta
	emit_signal("connection_succeeded")

# Callback from SceneTree, called when server disconnect
func _server_disconnected():
	#primero borra las labels de los jugadores conectados
	var jugadores = players.keys()
	for jugador in jugadores:
		emit_signal("jugador_desconectado", jugador)
	#luego se borra la lista jugadores
	players.clear()
	#esta señal es tomada por el "boton conectar", para desbloquearse si falla la coneccion
	emit_signal("server_disconnected")

	# Try to connect again
	#connect_to_server()

# Callback from SceneTree, called when unabled to connect to server
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	#esta señal es tomada por el "boton conectar", para desbloquearse si falla la coneccion
	emit_signal("connection_failed")

	# Try to connect again
	#connect_to_server()

remote func registrar_jugador(_id, _nombre_jugador): 
	players[_id] = _nombre_jugador
	emit_signal("lobby_mostrar_jugadores", _id, _nombre_jugador)	
	
func updatear_nombre(_nombre):
	nombre = _nombre
	
remote func unregister_jugador(id):
	players.erase(id)
	emit_signal("jugador_desconectado", id)

# Returns list of player names
func get_player_list():
	return players.values()

remote func obtener_nombre():
	rpc_id(1, "registrar_nombre", nombre)

remote func obtener_equipos(_equipos):
	
	emit_signal("lobby_registrar_equipos", _equipos)

remote func obtener_facciones(_facciones):
	emit_signal("lobby_registrar_facciones", _facciones)

remote func iniciar_partida(_partida):
	var EscenaPrincipal = load("res://Orquestador/EscenaPrincipal.tscn").instance()
	EscenaPrincipal.init(_partida)
	get_node("/root").add_child(EscenaPrincipal)
	



