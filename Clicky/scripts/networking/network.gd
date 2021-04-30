extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 2

var server = null
var client = null

var ipAddress = ""

func _ready():
	if OS.get_name() == "Windows":
		ipAddress = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ipAddress = IP.get_local_addresses()[0]
	else:
		ipAddress = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with("192.168.1"):
			ipAddress = ip
	
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	
func createServer():
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
#	assert(get_tree().is_network_server())
#	print(get_tree().get_network_unique_id())
	
func joinServer():
	client = NetworkedMultiplayerENet.new()
	client.create_client(ipAddress, DEFAULT_PORT)
	get_tree().set_network_peer(client)
#	print(get_tree().get_network_unique_id())
	
func _connected_to_server():
	print("connected to server")

func _server_disconnected():
	print("disconnected to server")
	
func _connection_failed():
	print("connection failed bro")
	
func _player_connected(id):
	print("Player " + str(id) + " has connected")

func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected")
