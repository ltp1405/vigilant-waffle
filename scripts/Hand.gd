extends Control

signal card_added(card: Card)

# Export properties to customize the fan shape easily in the Inspector
@export var hand_width: float = 800.0   # Max width of the fan
@export var max_rotation_degrees: float = 30.0 # Total rotation from left to right
@export var card_height_offset: float = 100.0 # Max vertical displacement (for the arc)

# Curve resources to define non-linear spacing and rotation
@export var spacing_curve: Curve # Controls horizontal/vertical position over the arc
@export var rotation_curve: Curve # Controls the rotation of each card
var max_cards := 6

func _ready() -> void:
	var scene = preload("res://scenes/Card.tscn")
	var card_data = [preload("res://resources/CardData_Death.tres"),
		preload("res://resources/CardData_Magician.tres")]
	for i in range(0, 4):
		var card = scene.instantiate()
		card.set_data(card_data[i % 2])
		add_card(card)

func add_card(card: Card):
	add_child(card)
	card.is_in_hand = true
	card.add_to_group("Playable Cards")
	card_added.emit(card)
	_sort_hand()
	
func _sort_hand():	
	var cards = get_children() # Assumes cards are direct children
	var num_cards = cards.size()
	if num_cards == 0:
		return

	for i in range(num_cards):
		var card = cards[i]
		
		# 1. Calculate the normalized ratio (0.0 to 1.0)
		# float(i) / (num_cards - 1) gives 0.0 for the first, 1.0 for the last.
		var hand_ratio = 0.5 # Default for 1 card
		if num_cards > 1:
			hand_ratio = float(i) / float(num_cards - 1)
		
		var y_curve_value = spacing_curve.sample(hand_ratio)		
		var rot_curve_value = rotation_curve.sample(hand_ratio)

		var x_pos = (hand_ratio - 0.5) * hand_width
		
		# Y Position: Apply the arc height using the sampled curve value.
		# Negative sign ensures the arc opens upward.
		var y_pos = y_curve_value * -card_height_offset
		
		var target_pos = Vector2(x_pos, y_pos)

		# 4. Calculate Final Rotation
		var target_rotation = deg_to_rad(rot_curve_value * max_rotation_degrees)
		card.rotation = target_rotation
		card.position = target_pos
		# 5. Set Z-index (Draw order)
		# Sets the card's draw order so the rightmost card (highest index) is on top.
		card.z_index = i
