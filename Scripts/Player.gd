extends Node2D


const TILE_SIZE := 16

var new_position_x : float
var new_position_y : float

var on_moving_bridge := false
var moving_bridge = null

onready var sfxs := [
	preload("res://Assets/audio/sfx/jump.wav"),
	preload("res://Assets/audio/sfx/coin.wav"),
	preload("res://Assets/audio/sfx/wall.wav"),
]

onready var front_raycast := $WallDetector/Front
onready var down_raycast := $WallDetector/Down
onready var left_raycast := $WallDetector/Left
onready var right_raycast := $WallDetector/Right
onready var camera := $Camera
onready var tween := $Tween
onready var sfx := $SFX


func _ready() -> void:
	randomize()
	# Camera smoothing is disabledNode at first to stop
	# seeing out-of-bounds objects at the start
	yield(get_tree().create_timer(1.0), "timeout")
	camera.smoothing_enabled = true


func _physics_process(_delta: float) -> void:
	if on_moving_bridge == true:
		global_position  = moving_bridge.global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("leap_forward"):
		# Check if some walls block the player
		if not front_raycast.is_colliding() == true:
			# Remove bridge's global position
			if on_moving_bridge == true:
				on_moving_bridge = false
				new_position_x = moving_bridge.up_tile_neighbor.x
				new_position_y = moving_bridge.up_tile_neighbor.y
				moving_bridge = null

			tween_stop()

			# Clamp the values so the player snaps to 16x16 tiles
			new_position_x = global_position.x
			new_position_y = clamp(global_position.y, global_position.y, global_position.y - TILE_SIZE)

			tween_leap()
			play_sfx(0, 1.75, 2.0)


	elif event.is_action_pressed("leap_down"):
		if not down_raycast.is_colliding() == true:
			if on_moving_bridge == true:
				on_moving_bridge = false
				new_position_x = moving_bridge.up_tile_neighbor.x
				new_position_y = moving_bridge.up_tile_neighbor.y
				moving_bridge = null

			tween_stop()

			new_position_x = global_position.x
			new_position_y = clamp(global_position.y, global_position.y + TILE_SIZE, global_position.y)

			tween_leap()
			play_sfx(0, 1.75, 2.0)


	elif event.is_action_pressed("leap_left"):
		if not left_raycast.is_colliding() == true:
			if on_moving_bridge == true:
				on_moving_bridge = false
				new_position_x = moving_bridge.up_tile_neighbor.x
				new_position_y = moving_bridge.up_tile_neighbor.y
				moving_bridge = null

			tween_stop()

			new_position_x = clamp(global_position.x, global_position.x, global_position.x - TILE_SIZE)
			new_position_y = global_position.y
			# clamp(global_position.y, global_position.y, global_position.y - TILE_SIZE)

			tween_leap()
			play_sfx(0, 1.75, 2.0)


	elif event.is_action_pressed("leap_right"):
		if not right_raycast.is_colliding() == true:
			if on_moving_bridge == true:
				on_moving_bridge = false
				new_position_x = moving_bridge.up_tile_neighbor.x
				new_position_y = moving_bridge.up_tile_neighbor.y
				moving_bridge = null

			tween_stop()

			new_position_x = clamp(global_position.x, global_position.x + TILE_SIZE, global_position.x)
			new_position_y = global_position.y

			tween_leap()
			play_sfx(0, 1.75, 2.0)


# For smooth controls of the player and continuous leaping, we'll check first if the tween is active, if it is active, we'll put the previous values immediately & effectively stop the tween, therefore snapping the old values
func tween_stop() -> void:
	if tween.is_active() == true:
		tween.stop_all()
		global_position.x = new_position_x
		global_position.y = new_position_y


func tween_leap() -> void:
	tween.interpolate_property(self, "global_position", global_position, Vector2(new_position_x, new_position_y), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()


func play_sfx(track: int, first: float, last: float) -> void:
	if sfx.playing == true:
		sfx.stop()
	sfx.stream = sfxs[track]
	sfx.pitch_scale = rand_range(first, last)
	sfx.play()


func spawn(spawn_point: Vector2) -> void:
	global_position = spawn_point


func set_camera_limits(top_left: Vector2, bottom_right: Vector2) -> void:
	camera.limit_left = top_left.x
	camera.limit_top = top_left.y
	camera.limit_right = bottom_right.x
	camera.limit_bottom = bottom_right.y


func set_camera_offset(offset: Vector2) -> void:
	camera.position = offset


func _game_over() -> void:
	print("GAME OVER!!!")


func _on_Detector_body_entered(body) -> void:
	# Check what tile the player is on (e.g. water, logs, etc.)

	if body is TileMap:
		# Convert local position to tilemap coordinates
		var local_position = body.to_local(global_position)
		var map_position = body.world_to_map(local_position)

		# 2 = danger
		match body.collision_layer:
			2:  # 0 = water, 5 = cliff
				if not on_moving_bridge == true:
					if body.get_cellv(map_position) == 0 or 5:
						_game_over()



func _on_Detector_area_entered(area) -> void:
	match area.collision_layer:
		32:
			tween_stop()
			on_moving_bridge = true
			moving_bridge = area
