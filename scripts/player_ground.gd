extends Node2D

var units: Array[Unit] = []
@export var max_unit_width: int = 100;
@export var board_width: int = 1000;
@export var unit_gap: int = 10;

var UNIT_SCENE = preload("res://scenes/Unit.tscn")

func place_card(card: Card):
	var data = card.data
	var unit: Unit = UNIT_SCENE.instantiate()
	unit.set_data(data)
	add_child(unit)
	units.push_back(unit)
	_reorganize_card()

func add_card(card: Card) -> void:
	var data = card.data
	var unit: Unit = UNIT_SCENE.instantiate()
	unit.set_data(data)
	add_child(unit)
	units.push_back(unit)
	_reorganize_card()
	
func _reorganize_card() -> void:
	var count = units.size();
	var gap_count = count - 1;
	var unit_width = min((board_width - (gap_count * unit_gap)) / count, max_unit_width)
	var board_mid = board_width / 2
	var unit_mid = unit_width / 2
	var occupied_width = unit_width * count + gap_count * unit_gap
	var start_x = board_mid - occupied_width / 2
	for ix in range(units.size()):
		var unit = units[ix]
		var x = start_x + (ix-1) * unit_gap + unit_width * ix
		unit.position.x = x
		unit.position.y = position.y
