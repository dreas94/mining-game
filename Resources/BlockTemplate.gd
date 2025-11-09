class_name BlockTemplate
extends Resource

@export var name: String
@export var durability: Vector2 = Vector2.ZERO
@export var color: Color

func get_file_name() -> String:
	return resource_path.get_file().get_basename()
