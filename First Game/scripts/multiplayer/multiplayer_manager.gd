extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var multiplayer_scene = preload("res://scenes/multiplayer_player.tscn")

var _players_spawn_node
var host_mode_enabled = false
var multiplayer_mode_enabled = false

func become_host():
	print("Become host pressed")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	var multiplayer_mode_enabled = true
	host_mode_enabled = true
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)

	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_connected.disconnect(_del_player)

	_remove_single_player()
	_add_player_to_game(1)

func join_as_player():
	print("Player Joining")
	var multiplayer_mode_enabled = true
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)

	multiplayer.multiplayer_peer = client_peer	
	_remove_single_player()

func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)

	_players_spawn_node.add_child(player_to_add, true)

func _del_player(id: int):
	print("Player %s has left the game!" % id)

func _remove_single_player():
	print("Remove single player")
	var player_to_remove = get_tree().get_current_scene().get_node("Player")
	player_to_remove.queue_free()
