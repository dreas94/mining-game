class_name iBackground
extends Node2D

@export_group("Background")
@export var tile_map: TileMapLayer
@export var camp_fire: CampFire
@export var canvas_modulate: CanvasModulate


func toggle_stuff(toggle: bool) -> void:
	tile_map.enabled = toggle
	camp_fire.enabled = toggle
	canvas_modulate.visible = toggle
