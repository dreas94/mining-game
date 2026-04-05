@tool
class_name UpgradeTemplate
extends Resource

@export var upgrade_name: String = "Upgrade"
@export var information: String = "Information"
@export_category("Costs")
@export var number_of_costs: int:
	get():
		var largest_num: int = 0
		for num: int in [cost_id.size(), cost_value.size()]:
			if largest_num != 0 and largest_num <= num:
				continue
			largest_num = num
		return largest_num
@export var cost_id: Array[String] = []
@export var cost_value: Array[int] = []
@export_category("Upgrade")
@export var number_of_upgrade: int:
	get():
		var largest_num: int = 0
		for num: int in [upgrade_type.size(), upgrade_value_type.size(), upgrade_value.size()]:
			if largest_num != 0 and largest_num <= num:
				continue
			largest_num = num
		return largest_num
@export var upgrade_type: Array[UpgradeConstants.TYPE] = []
@export var upgrade_value_type: Array[UpgradeConstants.VALUE_TYPE] = []
@export var upgrade_value: Array[float] = []


func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_upgrade_id() -> String:
	return get_file_name()
