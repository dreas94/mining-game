#UpgradeCollection Autoload Script
extends Node

signal upgrade_added(upgrade_id: String)
signal upgrade_removed(upgrade_id: String)

#Key = upgradeId, data = quantity
var _upgrades: Array[String]


func clear() -> void:
	_upgrades = []


func add_upgrade(upgrade_id: String) -> void:
	_upgrades.append(upgrade_id)
	
	upgrade_added.emit(upgrade_id)


func remove_upgrade(upgrade_id: String) -> void:
	if not upgrade_id in _upgrades:
		return
	
	_upgrades.erase(_upgrades.find(upgrade_id))
	upgrade_removed.emit(upgrade_id)


func get_upgrades() -> Array[String]:
	return _upgrades.duplicate()
