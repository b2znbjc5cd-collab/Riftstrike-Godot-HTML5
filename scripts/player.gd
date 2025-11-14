extends Node2D
# Player basic movement and aiming for prototype

@export var speed := 240.0
@export var aim_radius := 400.0

var velocity := Vector2.ZERO

func _ready():
    set_process(true)
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
    _handle_input(delta)
    _update_aim_indicator()

func _handle_input(delta):
    velocity = Vector2.ZERO
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        position += velocity * delta

func _update_aim_indicator():
    # placeholder for aim visuals; implement Line2D or other indicator in scene
    pass

func fire_primary():
    print("FIRE at ", get_global_mouse_position())
