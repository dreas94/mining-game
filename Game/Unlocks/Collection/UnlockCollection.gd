#BodyPartCollection Autoload Script
extends Node
signal unlock_added(unlock_id: String)
signal unlock_toggled(unlock_id: String, previous_unlock_id: String)
signal unlock_removed(unlock_id: String)

#Key = unlockId, data = is active?
var _unlocks: Dictionary[String, BodyPartUnlock] = {} 


func clear() -> void:
	_unlocks = {}


func add_unlock(unlock_id: String, type: BodyPartConstants.TYPE) -> void:
	if _unlocks.get(unlock_id) != null:
		return
	_unlocks[unlock_id] = BodyPartUnlock.new(type)
	unlock_added.emit(unlock_id)


func toggle_unlock(unlock_id: String) -> void:
	var previous_unlock_id: String = ""
	for key: String in _unlocks:
		if _unlocks[key].type != _unlocks[unlock_id].type:
			continue
		if not _unlocks[key].toggled:
			continue
		if unlock_id != key:
			previous_unlock_id = key
		break
	
	_unlocks[unlock_id].toggled = true
	unlock_toggled.emit(unlock_id, previous_unlock_id)


func remove_unlock(unlock_id: String) -> void:
	if _unlocks.get(unlock_id) == null:
		return
	
	_unlocks.erase(unlock_id)
	unlock_removed.emit(unlock_id)


func get_unlocks() -> Dictionary[String, bool]:
	return _unlocks.duplicate()


func get_toggled_unlocks() -> Array[String]:
	var toggled_array: Array[String] = []
	for key: String in _unlocks:
		if not _unlocks[key].toggled:
			continue
		
		toggled_array.append(key)
	
	return toggled_array


class BodyPartUnlock:
	var toggled: bool
	var type: BodyPartConstants.TYPE
	
	func _init(t: BodyPartConstants.TYPE) -> void:
		toggled = false
		type = t
		
