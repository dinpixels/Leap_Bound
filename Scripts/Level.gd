extends Node2D


export (Vector2) var spawn_point := Vector2.ZERO
export (Vector2) var camera_limits_top_left := Vector2.ZERO
export (Vector2) var camera_limits_bottom_right := Vector2.ZERO
export (Vector2) var camera_initial_offset := Vector2.ZERO


func get_spawn_point() -> Vector2:
	return spawn_point


func get_camera_limits_top_left() -> Vector2:
	return camera_limits_top_left


func get_camera_limits_bottom_right() -> Vector2:
	return camera_limits_bottom_right


func get_camera_initial_offset() -> Vector2:
	return camera_initial_offset
