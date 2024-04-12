extends Camera2D

var last_mouse_pos = Vector2.ZERO
var zoom_speed = 0.05
var max_zoom = 2.0
var min_zoom = 0.5

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		var current_mouse_pos = get_viewport().get_mouse_position()
		var mouse_delta = current_mouse_pos - last_mouse_pos
		last_mouse_pos = current_mouse_pos
		position += -mouse_delta / zoom.x
	else:
		last_mouse_pos = get_viewport().get_mouse_position()
	
	if Input.is_action_just_released("mouse_wheel_up"):
		if zoom.x < max_zoom:
			zoom.x += zoom_speed
			zoom.y += zoom_speed
	
	if Input.is_action_just_released("mouse_wheel_down"):
		if zoom.x > min_zoom:
			zoom.x -= zoom_speed
			zoom.y -= zoom_speed
