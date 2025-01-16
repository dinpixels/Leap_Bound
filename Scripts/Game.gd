extends Node


var current_level = null

onready var levels := [
	preload("res://Scenes/Levels/Level.tscn"),
]
onready var world := $World
onready var player := $World/Player


func _ready() -> void:
	# Every restart, play the transition here
	# print("reloaded scene")
	_change_level(levels[0].instance())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart_level()


func _change_level(next_level) -> void:
	world.add_child(next_level)

	# Get level's values for player spawn point and camera limits
	set_spawn_point(next_level.get_spawn_point())
	set_camera(
		next_level.get_camera_limits_top_left(),
		next_level.get_camera_limits_bottom_right(),
		next_level.get_camera_initial_offset()
	)

	current_level = next_level


func _restart_level() -> void:
	get_tree().reload_current_scene()


func set_spawn_point(spawn_point: Vector2) -> void:
	player.spawn(spawn_point)


func set_camera(top_left: Vector2, bottom_right: Vector2, initial_offset: Vector2) -> void:
	player.set_camera_limits(top_left, bottom_right)
	player.set_camera_offset(initial_offset)
