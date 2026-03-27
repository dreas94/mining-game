class_name UpgradeHandler
extends Node2D

var _upgrades: Array[Upgrade]

func _ready() -> void:
	pass


func _add_upgrade_to_total(new_upgrade: Upgrade) -> void:
	for upgrade: Upgrade in _upgrades:
		if upgrade.upgrade_type != new_upgrade.upgrade_type:
			continue
		if upgrade.upgrade_value_type != new_upgrade.upgrade_value_type:
			continue
		
		upgrade.value += new_upgrade.value
		return
	
	_upgrades.append(Upgrade.new(new_upgrade.upgrade_type, new_upgrade.upgrade_value_type, new_upgrade.value))
	
