class_name iItemWindow
extends Control

@export var v_box_container: VBoxContainer

var _open: bool = false:
	set(value):
		_open = value


var shown_items: Dictionary = {}


func _ready() -> void:
	visible = false
	Game.state.changed.connect(_on_game_state_changed)
	ItemCollection.item_added.connect(_on_item_added_to_collection)
	ItemCollection.item_removed.connect(_on_item_removed_from_collection)


func _on_item_added_to_collection(item_id: String, new_quantity: int) -> void:
	if not shown_items.has(item_id):
		var template: ItemTemplate = Content.get_item_template(item_id)
		var graphic: Texture2D = null
		if template != null:
			graphic = template.item_graphic
		else:
			graphic = load("uid://86nj8vqd82sj")
		var item_info: iItemInfo = create_item_info(graphic, new_quantity)
		v_box_container.add_child(item_info)
		item_info.label.text = str(new_quantity)
		shown_items[item_id] = item_info
	
	shown_items[item_id].label.text = str(new_quantity)


func _on_item_removed_from_collection(item_id: String, new_quantity: int) -> void:
	if new_quantity >= 0:
		shown_items[item_id].queue_free()
		shown_items.erase(item_id)
	shown_items[item_id] = new_quantity


func _on_game_state_changed(_old: SimpleState, new: SimpleState) -> void:
	visible = false
	if new.get_script() in [GameStateTest]:
		visible = true


func create_item_info(texture: Texture2D, value: int) -> iItemInfo:
	var item_info_scene: PackedScene = load("uid://cnkynamme1287")
	var item_info: iItemInfo = item_info_scene.instantiate()
	item_info.fill_data(texture, value)
	return item_info
