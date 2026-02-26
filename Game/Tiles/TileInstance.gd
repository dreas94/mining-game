class_name TileInstance
extends Node2D

var tile_visuals_scene: PackedScene = load("res://Content/TileVisual/TileVisual.tscn")

var tile_ref: WeakRef
var tile_attributes: TileAttributes
var tile_visuals: TileVisuals


func _init(_tile_attributes: TileAttributes) -> void:
	tile_attributes = _tile_attributes
	
	tile_visuals = tile_visuals_scene.instantiate()
	tile_visuals.tile_attributes = tile_attributes
