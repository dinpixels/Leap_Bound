extends Node2D
class_name MovingBridge


export (int, -1, 1) var direction := 0
export (float, 10.0, 50.0, 5.0) var speed := 15.0


func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction
