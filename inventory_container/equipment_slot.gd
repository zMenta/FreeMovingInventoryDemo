@tool
extends ColorRect

func _on_resized() -> void:
	# Makes the collisionshape the same size as the ColorRect.
	$InventoryArea/CollisionShape2D.shape.size = size
	$InventoryArea/CollisionShape2D.position = size/2
