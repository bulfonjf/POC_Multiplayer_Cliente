extends Node

# Game port and ip
const ip = "127.0.0.1"
const DEFAULT_PORT = 44444

# Signal to let GUI know whats up
signal connection_failed()
signal connection_succeeded()
signal server_disconnected()
signal players_updated()

var _ignore
var my_name = "Client"

# Players dict stored as id:name
var players = {}

func _ready():
	_ignore = get_tree().connect("connected_to_server", self, "_connected_ok")
	_ignore = get_tree().connect("connection_failed", self, "_connected_fail")
	_ignore = get_tree().connect("server_disconnected", self, "_server_disconnected")
	_ignore = get_tree().connect("network_peer_connected", self, "registrar_jugador")
	_ignore = get_tree().connect("network_peer_disconnected", self,"unregister_jugador")
	

func connect_to_server():
	print("conectando al servidor")
	var host = NetworkedMultiplayerENet.new()
	var connection = host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	print("create_client result", connection)


# Callback from SceneTree, called when connect to server
func _connected_ok():
	emit_signal("connection_succeeded")

	# Register ourselves with the server
	# rpc_id(1, "register_player", my_name)

# Callback from SceneTree, called when server disconnect
func _server_disconnected():
	players.clear()
	emit_signal("server_disconnected")

	# Try to connect again
	connect_to_server()

# Callback from SceneTree, called when unabled to connect to server
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")

	# Try to connect again
	connect_to_server()

remote func registrar_jugador(id): 
	print("Everyone sees this.. adding this id to your array! ", id) # everyone sees this
	#the server will see this... better tell this guy who else is already in...
	#if !(id in players):
	players[id] = ""
	
	
remote func update_player_list():
		for x in players:
			print(x)

remote func unregister_jugador(id):
	players.erase(id)
	emit_signal("players_updated")

# Returns list of player names
func get_player_list():
	return players.values()

func _on_Button_Conectar_pressed():
	connect_to_server()

remote func iniciar_partida(_partida):
	var EscenaPrincipal = load("res://Orquestador/EscenaPrincipal.tscn").instance()
	EscenaPrincipal.init(_partida)
	get_node("/root").add_child(EscenaPrincipal)
	

