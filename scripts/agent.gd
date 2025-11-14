extends CharacterBody2D

@export var speed := 120.0
var owner_id := 0
var life := 100

func _ready():
    set_process(true)

func _process(delta):
    # minimal AI: move randomly when no target
    pass

func take_damage(amount: int) -> void:
    life -= amount
    if life <= 0:
        queue_free()