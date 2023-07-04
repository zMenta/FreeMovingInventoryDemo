extends Area2D
class_name Item

@onready var color_filter := $TextureRect/Filter

enum States {VALID, INVALID, FOCUS}
var state := States.VALID : set = _set_state
var is_selected := false
var has_focus := false

func _set_state(new_state: States) -> void:
	state = new_state
	match state:
		States.VALID:
			color_filter.color = Color(Color.WHITE, 0)
		States.INVALID:
			color_filter.color = Color(Color.RED, 0.3)
		States.FOCUS:
			color_filter.color = Color(Color.WHITE, 0.1)
			

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left_click") and has_focus and not is_selected:
		is_selected = true
		state = States.VALID
		return

	if not is_selected:
		return
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("mouse_left_click") and state == States.VALID:
		is_selected = false
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


func _on_area_entered(_area:Area2D) -> void:
	_validate_area()

func _on_area_exited(_area:Area2D) -> void:
	_validate_area()

func _on_mouse_entered() -> void:
	if state == States.INVALID:
		return
	state = States.FOCUS
	has_focus = true

func _on_mouse_exited() -> void:
	has_focus = false
	_validate_area()

