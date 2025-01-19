tool
extends Sprite

# Tool enabled to update the sprite when parent's values are adjusted on the editor


func _on_viewport_entered(_viewport) -> void:
	owner.set_allow_spawn(true)
	owner.spawn()


func _on_viewport_exited(_viewport) -> void:
	if not OS.is_debug_build():
		queue_free()
