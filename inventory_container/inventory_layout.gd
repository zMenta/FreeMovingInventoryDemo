extends PanelContainer


func _on_mouse_entered() -> void:
	Globals.on_container_mouse_entered.emit(self)

