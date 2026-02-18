class_name ItemVisuals
extends Node2D

@export var graphic_sprite: Sprite2D
var item_attributes: ItemAttributes


func _ready() -> void:
	item_attributes.graphic.changed.connect(_on_graphic_changed)
	_configure()


func _configure() -> void:
	_on_graphic_changed(item_attributes.graphic.value)


func _on_graphic_changed(graphic: Texture2D) -> void:
	graphic_sprite.texture = graphic
