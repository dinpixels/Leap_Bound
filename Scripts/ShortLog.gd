tool
extends MovingBridge

# WARNING: Use MovingBridge (e.g. ShortLog and LongLog) to waters without any safe tiles only!

# Otherwise, the player would jump to nowhere upon leaving the MovingBridge, as the MovingBridge doesn't have any tiles to detect on, thus nothing to base the coordinates with which the player needs to jump onto


func set_direction(new_direction: int) -> void:
	direction = new_direction


func get_direction() -> int:
	return direction


func set_speed(new_speed: float) -> void:
	speed = new_speed


func get_speed() -> float:
	return speed


func _on_viewport_exited(_viewport) -> void:
	queue_free()
