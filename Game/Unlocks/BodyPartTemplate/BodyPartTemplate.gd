@tool
class_name BodyPartTemplate
extends Resource

@export var name: String = ""

func get_file_name() -> String:
	return resource_path.get_file().get_basename()


func get_body_part_id() -> String:
	return get_file_name()
