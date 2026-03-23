#ItemCollection Autoload Script
extends Node

signal item_added(item_id: String, new_quantity: int)
signal item_removed(item_id: String, new_quantity: int)

#Key = ItemId, data = quantity
var _items: Dictionary = {} 


func clear() -> void:
	_items = {}


func add_item(item_id: String, quantity: int = 1) -> void:
	if item_id in _items:
		_items[item_id] += quantity
	else:
		_items[item_id] = quantity
	
	item_added.emit(item_id, _items[item_id])


func remove_item(item_id: String, quantity: int = 1) -> void:
	if item_id in _items:
		_items[item_id] -= quantity
		if _items[item_id] <= 0:
			_items.erase(item_id)
	item_removed.emit(item_id, _items[item_id] if item_id in _items else 0)


func remove_exact_quantity(item_id: String, exact_quantity: int = 1)  -> bool:
	if not check_has_equal_or_more_quantity(item_id, exact_quantity):
		return false
	
	remove_item(item_id, exact_quantity)
	return true


func check_has_equal_or_more_quantity(item_id: String, exact_quantity: int = 1) -> bool:
	if not item_id in _items:
		return false
	
	if _items[item_id] < exact_quantity:
		return false
	
	return true


func get_number_of_items_by_id(item_id: String) -> int:
	if not item_id in _items:
		return 0
	
	return _items[item_id]
