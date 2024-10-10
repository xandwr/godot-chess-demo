class_name Piece extends Node3D

@export var static_body: StaticBody3D

var is_hovered: bool = false
var is_dragging: bool = false


func _ready() -> void:
	static_body.mouse_entered.connect(_on_mouse_entered)
	static_body.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	is_hovered = true


func _on_mouse_exited():
	is_hovered = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_LEFT and is_hovered:
			is_dragging = true
		
		if event.button_mask != MOUSE_BUTTON_LEFT:
			is_dragging = false
	
	if event is InputEventMouseMotion and is_dragging:
		drag(event)


func drag(event: InputEventMouseMotion):
	# Get the current camera
	var camera = get_viewport().get_camera_3d()
	
	# Cast a ray from the camera to the mouse position
	var ray_origin = camera.project_ray_origin(event.position)
	var ray_direction = camera.project_ray_normal(event.position) * 1000  # Ray length
	
	# Define the intersection plane (XZ plane at y=0)
	var plane = Plane(Vector3(0, 1, 0), 0)  # Y=0 plane
	
	# Check where the ray intersects with the XZ plane
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	
	# Move the piece to the intersection point
	if intersection:
		global_position = global_position.lerp(intersection, 0.1)
