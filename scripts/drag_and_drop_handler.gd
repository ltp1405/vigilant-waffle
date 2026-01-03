extends Control

var is_dragging = false
var drag_offset = Vector2.ZERO
var original_position: Vector2
var original_rotation: float

@export var hand_parent: Control # Reference to the Hand node
@export var card: Control

func _process(_delta: float) -> void:
	if is_dragging:
		var target_position = get_global_mouse_position() - drag_offset
		card.global_position = target_position
		card.rotation = 0
		$"..".card_dragged_to_position.emit(card, target_position)
		
func _restore():
	is_dragging = false
	# 5. Check for Drop Zone
	#check_drop_zone()
	
	# 6. Reset z_index and return to Hand parent
	self.z_index = 0
	card.get_parent().remove_child(card)
	hand_parent.add_child(card)
	card.position = original_position
	card.rotation = original_rotation
	#hand_parent.move_child(self, get_index_in_hand(self))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_released() && is_dragging:
			$"..".card_dropped_at_position.emit(card, card.global_position)
			_restore()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				# 1. Record state to start drag
				is_dragging = true
				# Calculate offset so the card doesn't jump to the cursor center
				drag_offset = get_global_mouse_position() - card.global_position
				
				# 2. Store original position and parent
				original_position = card.position
				original_rotation = card.rotation
				hand_parent = card.get_parent()
				
				# 3. Lift the card (move it to the top layer)
				var scene_root = get_tree().root
				hand_parent.remove_child(card)
				scene_root.add_child(card) # Move card to the scene root (top layer)
				card.z_index = 100 # Ensure it draws over everything
				
				# Accept the event to prevent parent controls from handling it
				accept_event() 
		else:
			# 4. Stop Drag (when button is released)
			if is_dragging:
				pass
				
