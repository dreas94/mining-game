class_name ItemInstance
extends Node2D

var item_visuals_scene: PackedScene = load("res://Content/ItemVisual/ItemVisual.tscn")

var item_ref: WeakRef
var item_attributes: ItemAttributes
var item_visuals: ItemVisuals

var _area2D: PreppedArea2D


func _init(_item_attributes: ItemAttributes, _item_template: ItemTemplate) -> void:
	item_attributes = _item_attributes
	
	item_visuals = item_visuals_scene.instantiate()
	item_visuals.item_attributes = item_attributes
	_area2D = PreppedArea2D.new(Vector2(5.0, 5.0))


func _ready() -> void:
	_area2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body != World.player:
		return
