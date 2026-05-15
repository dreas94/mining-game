@tool
class_name UnlockTemplate
extends Resource

@export_category("Visuals")
@export var texture: Texture2D = preload("uid://86nj8vqd82sj")

@export_category("Stats")
@export var mining_power: float = 0.0
@export var mining_speed: float = 0.0
@export var health: float = 0.0
@export var durability: float = 0.0
@export var jump_height: float = 0.0


func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_unlock_id() -> String:
	return get_file_name()
