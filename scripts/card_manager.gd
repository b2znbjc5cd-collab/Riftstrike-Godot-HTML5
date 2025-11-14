extends Node

# Minimal card manager: deck, hand, draw timer, play card hooks
@export var deck_path := "res://data/cards.json"
@export var hand_size := 5
@export var draw_interval := 8.0

var deck := []
var hand := []
var draw_timer := 0.0

func _ready():
    _load_deck()
    _shuffle_deck()
    for i in range(hand_size):
        _draw_card()
    draw_timer = draw_interval
    set_process(true)

func _process(delta):
    draw_timer -= delta
    if draw_timer <= 0:
        _draw_card()
        draw_timer = draw_interval

func _load_deck():
    var f = FileAccess.open(deck_path, FileAccess.ModeFlags.READ)
    if not f:
        push_error("Could not open deck file: %s" % deck_path)
        return
    var text = f.get_as_text()
    var parsed = JSON.parse_string(text)
    if parsed.error != OK:
        push_error("JSON parse error: %s" % parsed.error_string)
        return
    deck = parsed.result.duplicate()
    f.close()

func _shuffle_deck():
    deck.shuffle()

func _draw_card():
    if deck.empty():
        return
    var c = deck.pop_back()
    hand.append(c)
    print("Drew card: ", c.get("name", "unnamed"))

func play_card(index):
    if index < 0 or index >= hand.size():
        return
    var card = hand[index]
    print("Playing card:", card.get("name", "unnamed"), "type:", card.get("type",""))
    hand.remove_at(index)
    # connect this to spawn logic in the scene
