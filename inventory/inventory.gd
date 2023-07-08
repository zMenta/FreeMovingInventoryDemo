extends MarginContainer

var held_item: Item
var current_item: Item 
var current_slot: Slot

func _ready() -> void:
	Globals.on_item_focus.connect(_on_item_focus)
	Globals.on_item_invalid_placement.connect(_on_item_invalid_placement)
	Globals.on_slot_mouse_entered.connect(_on_slot_mouse_entered)


func _process(_delta: float) -> void:
	if current_item == null:
		return
	if Input.is_action_just_pressed("mouse_left_click") and not current_item.is_selected and held_item == null and current_item.has_focus:
		_hold_item(current_item)
		return

	if held_item == null:
		return
	if Input.is_action_just_pressed("mouse_left_click") and (held_item.state == Item.States.VALID or held_item.state == Item.States.FOCUS):
		_place_item(held_item)

	if Input.is_action_just_pressed("mouse_left_click") and current_slot != null:
		print(current_slot.has_mouse_focus)


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


func _on_item_focus(item: Item) -> void:
	current_item = item

func _on_item_invalid_placement(item: Item) -> void:
	current_item = item
	_hold_item(item)

func _on_slot_mouse_entered(slot: Slot) -> void:
	current_slot = slot
