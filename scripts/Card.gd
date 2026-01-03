extends Control

class_name Card

signal card_dragged_to_position(card_node, current_position)
signal card_dropped_at_position(card_node, drop_position)

var data: CardData
var is_in_hand := false

func set_data(card_data: CardData):
	data = card_data
	$Cost.text = str(data.cost)
	$Attack.text = str(data.attack)
	$Health.text = str(data.health)
	$Artwork.texture = data.art
