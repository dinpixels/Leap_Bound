extends Area2D

var local_position := Vector2.ZERO
var map_position := Vector2.ZERO
var tile_global := Vector2.ZERO

var up_tile_neighbor := Vector2.ZERO
var down_tile_neighbor := Vector2.ZERO
var left_tile_neighbor := Vector2.ZERO
var right_tile_neighbor := Vector2.ZERO

var tilemap = null


func _ready() -> void:
	if not is_connected("body_entered", self, "_on_body_entered"):
		connect("body_entered", self, "_on_body_entered")


func _physics_process(_delta: float) -> void:
	#if tilemap is TileMap:
	#	if overlaps_body(tilemap) == true:
	#		local_position = tilemap.to_local(global_position)
	#		map_position = tilemap.world_to_map(local_position)
	#		tile_global = tilemap.map_to_world(map_position) + tilemap.cell_size / 2
			#var tile_global_pos = tilemap.to_global(tile_global)

	#		up_tile_neighbor = tile_global + Vector2.UP
	#		down_tile_neighbor = tile_global + Vector2.DOWN
	#		left_tile_neighbor = tile_global + Vector2.LEFT
	#		right_tile_neighbor = tile_global + Vector2.RIGHT
	pass


func _on_body_entered(body) -> void:
	if body is TileMap:
		local_position = body.to_local(global_position)
		map_position = body.world_to_map(local_position)
		tile_global = body.map_to_world(map_position) + body.cell_size / 2

		up_tile_neighbor = tile_global + Vector2.UP
		down_tile_neighbor = tile_global + Vector2.DOWN
		left_tile_neighbor = tile_global + Vector2.LEFT
		right_tile_neighbor = tile_global + Vector2.RIGHT

		# Check first if it's 'danger' collision layer
		match body.collision_layer:
			2:
				match body.get_cellv(map_position):
					0: tilemap = body
