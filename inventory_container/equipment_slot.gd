@tool
extends ColorRect
class_name Slot

@export var item_type: ItemType
@export var normal_color: Color
@export var focus_color: Color

@onready var texture_rect : TextureRect = $TextureRect

var has_mouse_focus := false
var stored_item: Item 

func _ready() -> void:
	Globals.on_item_unfocus.connect(_on_item_unfocu)
	Globals.on_item_focus.connect(_on_item_focus)

func _on_resized() -> void:
	# Makes the collisionshape the same size as the ColorRect.
	$InventoryArea/CollisionShape2D.shape.size = size
	$InventoryArea/CollisionShape2D.position = size/2


func _on_item_focus(item: Item) -> void:
	if item_type.type == item.item_type.type:
		color = focus_color

func _on_item_unfocu() -> void:
	color = normal_color


func _on_inventory_area_mouse_entered() -> void:
	has_mouse_focus = true
	Globals.on_slot_mouse_entered.emit(self)


func _on_inventory_area_mouse_exited() -> void:
	has_mouse_focus = false

