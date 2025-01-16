tool
extends Node2D


export (bool) var safe := true setget set_safe_type, is_safe
export (int, 0, 1) var no := 0 setget set_item_no, get_item_no
export (int, -1, 1) var direction := -1
export (float, 10.0, 50.0, 5.0) var speed := 15.0
export (float, 4.0, 6.0, 0.5) var seconds := 4.0

onready var scenes := [
	preload("res://Scenes/World/ShortLog.tscn"),
	preload("res://Scenes/World/LongLog.tscn"),
]

onready var timer := $Timer


func _ready() -> void:
	#if not OS.is_debug_build():
		_spawn()


func _spawn() -> void:
	timer.start(seconds)

	var obj = scenes[no].instance()
	obj.set_direction(direction)
	obj.set_speed(speed)
	obj.global_position = self.global_position
	owner.call_deferred("add_child", obj, true)


func set_safe_type(type: bool) -> void:
	safe = type
	if OS.is_debug_build():
		match type:
			true: $Sprite.region_rect.position.x = 0
			false: $Sprite.region_rect.position.x = 16


func is_safe() -> bool:
	return safe


func set_item_no(number: int) -> void:
	no = number
	if OS.is_debug_build():
		match number:
			0: set_safe_type(true)
			1: set_safe_type(true)


func get_item_no() -> int:
	return no


func _on_timeout() -> void:
	#if not OS.is_debug_build():
		_spawn()
