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