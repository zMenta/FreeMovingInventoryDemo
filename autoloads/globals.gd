extends Node

# Inventory related signals
signal on_item_focus(item: Item)
signal on_item_unfocus
signal on_item_invalid_placement(item: Item)
signal on_container_mouse_entered(inventory: PanelContainer)
signal on_slot_mouse_entered(slot: Slot)
