extends MarginContainer

var held_item: Item
var current_item: Item 
var current_slot: Slot
var current_container: PanelContainer

func _ready() -> void:
	Globals.on_item_focus.connect(_on_item_focus)
	Globals.on_item_invalid_placement.connect(_on_item_invalid_placement)
	Globals.on_slot_mouse_entered.connect(_on_slot_mouse_entered)
	Globals.on_container_mouse_entered.connect(_on_container_mouse_entered)

func _process(_delta: float) -> void:
	if current_item != null:
		if Input.is_action_just_pressed("mouse_left_click") and not current_item.is_selected and held_item == null and current_item.has_focus:
			_hold_item(current_item)
			return

	if held_item != null:
		if current_slot != null:
			_check_slot_is_valid()
			if Input.is_action_just_pressed("mouse_left_click"):
				if current_slot.has_mouse_focus and current_slot.item_type.type == held_item.item_type.type:
					if current_slot.stored_item == null:
						current_slot.stored_item = held_item.duplicate()
						current_slot.texture_rect.texture = held_item.texture_rect.texture
						held_item.queue_free()
						held_item = null
					else:
						var temporary_item: Item = held_item.duplicate()
						current_slot.texture_rect.texture = held_item.texture_rect.texture
						held_item.queue_free()
						held_item = null
						add_child(current_slot.stored_item)
						_hold_item(current_slot.stored_item)
						held_item.rotation = 0
						current_slot.stored_item = temporary_item
					return

		if Input.is_action_just_pressed("mouse_left_click") and (held_item.state == Item.States.VALID or held_item.state == Item.States.FOCUS):
			_place_item(held_item)
			return

	elif Input.is_action_just_pressed("mouse_left_click") and current_slot != null:
		if current_slot.has_mouse_focus and current_slot.stored_item != null:
			current_slot.texture_rect.texture = null
			add_child(current_slot.stored_item)
			_hold_item(current_slot.stored_item)
			held_item.rotation = 0
			current_slot.stored_item = null
			


func _place_item(item: Item) -> void:
	item.is_selected = false
	item.state = Item.States.FOCUS
	held_item.z_index = 0
	held_item = null


func _hold_item(item: Item) -> void:
	if held_item != null:
		return

	held_item = item
	held_item.z_index = 10
	held_item.is_selected = true
	held_item.state = Item.States.VALID

func _check_slot_is_valid() -> void:
	if current_slot != null and held_item != null:
		if current_slot.item_type.type == held_item.item_type.type and current_slot.has_mouse_focus:
			held_item.state = Item.States.VALID


func _on_item_focus(item: Item) -> void:
	current_item = item

func _on_item_invalid_placement(item: Item) -> void:
	current_item = item
	_hold_item(item)

func _on_slot_mouse_entered(slot: Slot) -> void:
	current_slot = slot
	_check_slot_is_valid()

func _on_container_mouse_entered(container: PanelContainer) -> void:
	current_container = container
	print(current_container)

