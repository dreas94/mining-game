class_name TileHandler
extends Node2D

var _grid_array: Array[Vector2i]
var _tiles: Dictionary = {}


func instance_tile_to_grid_position(tile: Tile, grid_position: Vector2i = Vector2i.ZERO, global_pos: Vector2 = Vector2.ZERO) -> void:
	Logger.hint(self, instance_tile_to_grid_position)
	
	if tile.get_tile_instance().get_parent() != null:
		Logger.error(self, instance_tile_to_grid_position, "tile instance already part of a tile handler" + (get_path() as String))
		return
	
	if _grid_array.has(grid_position):
		Logger.error(self, instance_tile_to_grid_position, "grid position, already filled" + (get_path() as String))
		return
	
	_grid_array.append(grid_position)
	_tiles[grid_position] = tile
	tile.set_tile_to_handler(self)
	
	var tile_instance: TileInstance = tile.get_tile_instance()
	add_child(tile_instance)
	
	tile_instance.global_position = global_pos


func instance_template_to_grid_position(template: TileTemplate, grid_position: Vector2i = Vector2i.ZERO, global_pos: Vector2 = Vector2.ZERO) -> Tile:
	Logger.hint(self, instance_template_to_grid_position)
	
	if _grid_array.has(grid_position):
		Logger.error(self, instance_tile_to_grid_position, "grid position, already filled" + (get_path() as String))
		return
	
	var tile: Tile = Tile.new(template)
	_grid_array.append(grid_position)
	_tiles[grid_position] = tile
	tile.set_tile_to_handler(self)
	
	var tile_instance: TileInstance = tile.get_tile_instance()
	add_child(tile_instance)
	
	tile_instance.global_position = global_pos
	return tile


func remove_tile_from_handler(tile: Tile) -> void:
	Logger.hint(self, remove_tile_from_handler)
	
	if not tile:
		return
	
	if _tiles.has(tile):
		_tiles.erase(tile)
	
	tile.set_tile_to_handler(null)
	
	var i: TileInstance = tile.get_tile_instance()
	i.queue_free()


func clear_handler() -> void:
	Logger.hint(self, clear_handler)
	_tiles.clear()
	for c: Node in get_children():
		if c is TileInstance:
			c.queue_free()
		else:
			Logger.warn(self, clear_handler, "Not a TileInstance -> %s" % c.name)


func get_tiles() -> Dictionary:
	return _tiles.duplicate()


func get_tile_in_grid_position(grid_position: Vector2i) -> Tile:
	return _tiles.get(grid_position)


func has_tile_at_grid_position(grid_position: Vector2i) -> bool:
	return _tiles.has(grid_position)
