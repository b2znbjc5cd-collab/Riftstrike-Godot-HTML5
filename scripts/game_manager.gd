extends Node

# Authoritative game manager: manages rifts, adrenalina resource, spawning, and game state

@export var rift_scene := preload("res://scenes/Rift.tscn")
@export var agent_scene := preload("res://scenes/Agent.tscn")
@export var turret_scene := preload("res://scenes/Turret.tscn")

var players := {}
var rifts := []

func _ready():
    if Engine.is_editor_hint():
        return
    # register existing Rift nodes
    for r in get_tree().get_nodes_in_group("Rift"):
        r.connect("captured", Callable(self, "_on_rift_captured"))
        rifts.append(r)

func register_player(id, node):
    players[id] = {"node": node, "adrenalina": 0}

func unregister_player(id):
    players.erase(id)

# Called when a rift is captured: start giving resource to owner
func _on_rift_captured(rift, owner_id):
    if players.has(owner_id):
        players[owner_id]["adrenalina"] += rift.capture_rate

func spend_adrenalina(player_id, amount) -> bool:
    if not players.has(player_id):
        return false
    if players[player_id]["adrenalina"] < amount:
        return false
    players[player_id]["adrenalina"] -= amount
    return true

func spawn_agent(owner_id, position):
    var a = agent_scene.instantiate()
    a.owner_id = owner_id
    a.global_position = position
    add_child(a)
    return a

func spawn_turret(owner_id, position):
    var t = turret_scene.instantiate()
    t.owner_id = owner_id
    t.global_position = position
    add_child(t)
    return t

# Handle spawn requests from network manager (server side)
func handle_spawn_request(requester_id, card_id, position):
    # validate cost using internal players table and card list
    var cm = get_node_or_null("/root/Main/World/CardManager")
    if cm == null:
        return
    var card = cm.find_card_by_id(card_id)
    if card == null:
        return
    var cost = card.get("cost", 0)
    if not spend_adrenalina(requester_id, cost):
        # insufficient resource
        return
    match card.get("type", ""):
        "agent":
            spawn_agent(requester_id, position)
        "turret":
            spawn_turret(requester_id, position)
        _:
            # other types: fields, tactics, gambits handled later
            pass
