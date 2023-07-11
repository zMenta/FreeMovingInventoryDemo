extends Area2D
class_name Item

@onready var texture_rect := $TextureRect
@onready var stack_label := $TextureRect/StackCountLabel

@export var item_type: ItemType
@export var is_stackable := false
@export_range(1, 1000, 1) var max_stack : int = 1

enum States {VALID, INVALID, FOCUS}
var state := States.VALID : set = _set_state
var is_selected := false
var has_focus := false
var current_stack : int = 1 : set = set_current_stack

func set_current_stack(new_value: int) -> void:
	current_stack = clampi(new_value, 1, max_stack)
	if current_stack == 1:
		stack_label.hide()
	else:
		stack_label.show()
		stack_label.text = str(current_stack)

func _set_state(new_state: States) -> void:
	state = new_state
	match state:
		States.VALID:
			texture_rect.material.set_shader_parameter("color_intensity", 0.0)
			texture_rect.material.set_shader_parameter("color", Color.WHITE)
		States.INVALID:
			texture_rect.material.set_shader_parameter("color_intensity", 0.25)
			texture_rect.material.set_shader_parameter("color", Color.RED)
		States.FOCUS:
			texture_rect.material.set_shader_parameter("color_intensity", 0.08)
			texture_rect.material.set_shader_parameter("color", Color.WHITE)
			

func _process(delta: float) -> void:
	if not is_selected:
		if state == States.INVALID:
			Globals.on_item_invalid_placement.emit(self)
		return

	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if Input.is_action_pressed("rotate_left"):
		rotation_degrees += 100 * delta
	elif Input.is_action_pressed("rotate_right"):
		rotation_degrees -= 100 * delta
	elif Input.is_action_just_pressed("rotate_step"):
		if int(rotation_degrees) % 90 != 0:
			rotation_degrees = 0
		else:
			rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0


func _validate_area() -> void:
	var overlap_amount : int = get_overlapping_areas().size()
	if overlap_amount > 1 or overlap_amount == 0:
		state = States.INVALID
	else:
		state = States.VALID

	for area in get_overlapping_areas():
		if area is Item:
			state = States.INVALID

			if scene_file_path == area.scene_file_path and is_stackable:
				state = States.VALID
				print("can stack")


func _on_area_entered(_area:Area2D) -> void:
	_validate_area()

func _on_area_exited(_area:Area2D) -> void:
	_validate_area()

func _on_mouse_entered() -> void:
	if state == States.INVALID:
		return
	state = States.FOCUS
	has_focus = true
	Globals.on_item_focus.emit(self)

func _on_mouse_exited() -> void:
	Globals.on_item_unfocus.emit()
	has_focus = false
	_validate_area()

func _on_tree_entered() -> void:
	await get_tree().create_timer(0.1).timeout
	if texture_rect.get_rect().has_point(get_local_mouse_position()):
		_on_mouse_entered()

