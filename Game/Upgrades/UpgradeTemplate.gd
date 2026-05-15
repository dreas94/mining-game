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
@export_category("Added Stats")
@export var mining_power: float = 0.0
@export var mining_speed: float = 0.0
@export var health: float = 0.0
@export var durability: float = 0.0
@export var jump_height: float = 0.0
@export_category("Multiplied Stats")
@export var mining_power_mult: float = 0.0
@export var mining_speed_mult: float = 0.0
@export var health_mult: float = 0.0
@export var durability_mult: float = 0.0
@export var jump_height_mult: float = 0.0

func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_upgrade_id() -> String:
	return get_file_name()
