@tool
class_name UpgradeTemplate
extends Resource

@export var upgrade_name: String = "Upgrade"
@export var information: String = "Information"
@export var cost: int = 20
@export_category("Stats")
@export var number_of_stats: int:
	get():
		var largest_num: int = 0
		for num: int in [stats_type.size(), stats_value_type.size(), stats_value.size()]:
			if largest_num != 0 and largest_num <= num:
				continue
			largest_num = num
		return largest_num
@export var stats_type: Array[StatsConstants.TYPE] = []
@export var stats_value_type: Array[StatsConstants.VALUE_TYPE] = []
@export var stats_value: Array[float] = []


func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_upgrade_id() -> String:
	return get_file_name()
