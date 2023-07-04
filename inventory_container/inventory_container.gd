@tool
extends ColorRect

func _on_resized() -> void:
	# Makes the collisionshape the same size as the ColorRect.
	$InventoryArea/CollisionShape2D.shape.size = size
	$InventoryArea/CollisionShape2D.position = size/2

	# Set the border area lengh
	$InventoryBorders/Top.shape.b.x = size.x
	$InventoryBorders/Bottom.shape.b.x = size.x
	$InventoryBorders/Left.shape.b.y = size.y
	$InventoryBorders/Right.shape.b.y = size.y

	# Bottom and right borders positions
	$InventoryBorders/Right.position.x = size.x
	$InventoryBorders/Bottom.position.y = size.y


