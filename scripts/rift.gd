extends Area2D

signal captured(rift, owner_id)

@export var capture_rate := 1
var owner_id := 0

func _ready():
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    if body.has_method("get_owner_id"):
        var id = body.get_owner_id()
        if id != owner_id:
            owner_id = id
            emit_signal("captured", self, owner_id)