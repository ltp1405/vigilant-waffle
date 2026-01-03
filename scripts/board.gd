extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_cards = get_tree().get_nodes_in_group("Playable Cards")
	for card in all_cards:
		_connect_card_signal(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_card_dropped(card: Card, drop_position: Vector2) -> void:
	var rect = Rect2(global_position, $DropBoundary.size)
	if rect.has_point(drop_position):
		$PlayerGround.place_card(card)

func _on_card_dragged(card: Card, drag_position: Vector2) -> void:
	var rect = Rect2(global_position, $DropBoundary.size)
	if rect.has_point(drag_position):
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false

func _on_hand_card_added(card: Card) -> void:
	_connect_card_signal(card)

func _connect_card_signal(card: Object):
	if card.has_signal("card_dropped_at_position"):
		card.card_dropped_at_position.connect(_on_card_dropped)
	if card.has_signal("card_dragged_to_position"):
		card.card_dragged_to_position.connect(_on_card_dragged)
