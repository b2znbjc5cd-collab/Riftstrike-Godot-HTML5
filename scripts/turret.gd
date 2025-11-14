extends Node2D

@export var life := 50
@export var damage := 10
var owner_id := 0

func _ready():
    set_process(true)

func _process(delta):
    # placeholder: could auto-fire at nearby enemies
    pass

func take_damage(amount: int) -> void:
    life -= amount
    if life <= 0:
        queue_free()