#UpgradeCollection Autoload Script
extends Node

signal upgrade_added(upgrade_id: String, upgrade: Upgrade)
signal upgrade_removed(upgrade_id: String, upgrade: Upgrade)

#Key = upgradeId, data = quantity
var _upgrades: Dictionary[String, Upgrade] = {} 


func clear() -> void:
	_upgrades = {}


func add_upgrade(upgrade_id: String, new_upgrade: Upgrade) -> void:
	_upgrades[upgrade_id] = new_upgrade
	
	upgrade_added.emit(upgrade_id, _upgrades[upgrade_id])


func remove_upgrade(upgrade_id: String) -> void:
	if not upgrade_id in _upgrades:
		return
	
	var upgrade: Upgrade = _upgrades[upgrade_id]
	_upgrades.erase(upgrade_id)
	upgrade_removed.emit(upgrade_id, upgrade)


func get_upgrades() -> Dictionary[String, Upgrade]:
	return _upgrades.duplicate()
