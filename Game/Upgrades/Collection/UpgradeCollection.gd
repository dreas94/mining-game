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


func get_upgrades_of_type(type: UpgradeConstants.TYPE) -> Array[Upgrade]:
	var _typed_upgrades: Array[Upgrade]
	for key: String in _upgrades:
		if _upgrades[key].upgrade_type != type:
			continue
		_typed_upgrades.append(_upgrades[key])
	return _typed_upgrades


func calculate_upgrades(type: UpgradeConstants.TYPE) -> Variant:
	var all_upgrades_of_type: Array[Upgrade] = get_upgrades_of_type(type)
	var all_generic_upgrades_of_type: Array[Upgrade] = all_upgrades_of_type.filter(_is_generic_upgrade)
	var all_percentage_upgrades_of_type: Array[Upgrade] = all_upgrades_of_type.filter(_is_percentage_upgrade)
	
	var generic_upgrade_total: float = 0.0
	for upgrade: Upgrade in all_generic_upgrades_of_type:
		generic_upgrade_total += upgrade.value
	
	var percentage_upgrade_total: float = 1.0
	for upgrade: Upgrade in all_percentage_upgrades_of_type:
		percentage_upgrade_total += upgrade.value
	
	match type:
		UpgradeConstants.TYPE.DAMAGE:
			if Mines.player == null:
				return 0.0
			return (UpgradeConstants.DAMAGE_BASE + generic_upgrade_total) * percentage_upgrade_total
		UpgradeConstants.TYPE.HEALTH:
			return (UpgradeConstants.HEALTH_BASE + generic_upgrade_total) * percentage_upgrade_total
		UpgradeConstants.TYPE.MINING_SPEED:
			return (UpgradeConstants.MINING_SPEED_SCALE_BASE + generic_upgrade_total) * (percentage_upgrade_total)
		UpgradeConstants.TYPE.JUMP_HEIGHT:
			return -(UpgradeConstants.JUMP_HEIGHT_BASE + generic_upgrade_total) * percentage_upgrade_total
	
	return 0.0


func _is_generic_upgrade(upgrade: Upgrade) -> bool:
	return upgrade.upgrade_value_type == UpgradeConstants.VALUE_TYPE.GENERIC


func _is_percentage_upgrade(upgrade: Upgrade) -> bool:
	return upgrade.upgrade_value_type == UpgradeConstants.VALUE_TYPE.PERCENTAGE
