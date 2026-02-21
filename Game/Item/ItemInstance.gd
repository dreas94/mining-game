class_name ItemInstance
extends Node2D

var item_visuals_scene: PackedScene = load("res://Content/ItemVisual/ItemVisual.tscn")

var item_ref: WeakRef
var item_attributes: ItemAttributes
var item_visuals: ItemVisuals

var _area: PreppedRigidBody2D


func _init(_item_attributes: ItemAttributes) -> void:
	item_attributes = _item_attributes
	
	item_visuals = item_visuals_scene.instantiate()
	item_visuals.item_attributes = item_attributes
	_area = PreppedRigidBody2D.new(Vector2(5.0, 5.0))
	add_child(_area)
	_area.add_child(item_visuals)


func _ready() -> void:
	_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	App.sfx.play(DefaultSoundEffects.PICKUP)
	ItemCollection.add_item(item_attributes.template.get_item_id())
	if World.breakable_tile_map_layer.active_items.has(item_ref.get_ref()):
		World.breakable_tile_map_layer.active_items.erase(item_ref.get_ref())
	queue_free()
