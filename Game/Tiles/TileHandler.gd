class_name TileHandler
extends Node2D

var _tiles: Array[Tile] = []


func instance_tile_to_grid_position(tile: Tile, global_pos: Vector2 = Vector2.ZERO) -> void:
	Logger.hint(self, instance_tile_to_grid_position)
	
	if tile.get_tile_instance().get_parent() != null:
		Logger.error(self, instance_tile_to_grid_position, "tile instance already part of a tile handler" + (get_path() as String))
		return
	
	_tiles.append(tile)
	tile.set_tile_to_handler(self)
	
	var tile_instance: TileInstance = tile.get_tile_instance()
	add_child(tile_instance)
	
	tile_instance.global_position = global_pos


func instance_template_to_grid_position(template: TileTemplate, global_pos: Vector2 = Vector2.ZERO) -> Tile:
	Logger.hint(self, instance_template_to_grid_position)
	
	var tile: Tile = Tile.new(template)
	
	_tiles.append(tile)
	tile.set_tile_to_handler(self)
	
	var tile_instance: TileInstance = tile.get_tile_instance()
	add_child(tile_instance)
	
	tile_instance.global_position = global_pos
	return tile
