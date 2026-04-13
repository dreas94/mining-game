class_name Upgrade
extends RefCounted

var upgrade_type: UpgradeConstants.TYPE
var upgrade_value_type: UpgradeConstants.VALUE_TYPE
var value: float


func _init(new_upgrade_type: UpgradeConstants.TYPE, new_upgrade_value_type: UpgradeConstants.VALUE_TYPE, new_value: float) -> void:
	upgrade_type = new_upgrade_type
	upgrade_value_type = new_upgrade_value_type
	value = new_value


func get_upgrade_as_string() -> String:
	var string_name: String = ""
	match upgrade_type:
		UpgradeConstants.TYPE.DAMAGE:
			string_name = "Damage"
		UpgradeConstants.TYPE.HEALTH:
			string_name = "Health"
		UpgradeConstants.TYPE.MINING_SPEED:
			string_name = "Mining Speed"
	
	var post_value_string: String = ""
	var formated_value: float = value
	
	match upgrade_value_type:
		UpgradeConstants.VALUE_TYPE.PERCENTAGE:
			post_value_string = "%"
			formated_value *= 100.0
		_:
			post_value_string = ""
	if value > 0:
		return string_name + " +" + str(formated_value) + post_value_string
	else:
		return string_name + " -" + str(formated_value) + post_value_string
