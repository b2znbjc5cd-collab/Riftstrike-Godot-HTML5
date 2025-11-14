extends Node

# Simple ENet-based network manager for Godot 4 (prototype)
# Provides start_server(port) and connect(address, port)
# Note: Godot 4 Multiplayer API used (ENetMultiplayerPeer).

var peer = null
var is_server := false

func start_server(port: int=4242, max_clients: int=2) -> void:
    peer = ENetMultiplayerPeer.new()
    var err = peer.create_server(port, max_clients)
    if err != OK:
        push_error("Failed to create ENet server: %s" % err)
        return
    get_tree().multiplayer.multiplayer_peer = peer
    is_server = true
    print("Server started on port %d" % port)

func connect_to_server(address: String, port: int=4242) -> void:
    peer = ENetMultiplayerPeer.new()
    var err = peer.create_client(address, port)
    if err != OK:
        push_error("Failed to create ENet client: %s" % err)
        return
    get_tree().multiplayer.multiplayer_peer = peer
    is_server = false
    print("Connected to server %s:%d" % [address, port])

func is_server_running() -> bool:
    return is_server

# High level helpers
func send_spawn_request(card_id: String, position: Vector2) -> void:
    # Client asks server to spawn a unit (server should validate cost)
    if get_tree().multiplayer.get_multiplayer_peer() == null:
        return
    rpc_id(1, "_rpc_request_spawn", get_tree().get_multiplayer().get_unique_id(), card_id, position)

@rpc
func _rpc_request_spawn(requester_id: int, card_id: String, position: Vector2) -> void:
    # only process on server
    if not is_server:
        return
    var gm = get_node_or_null("/root/Main/GameManager")
    if gm:
        gm.handle_spawn_request(requester_id, card_id, position)