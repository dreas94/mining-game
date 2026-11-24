class_name iBody
extends Node2D

@export var head: BodyPartHead
@export var arms: BodyPartArms
@export var legs: BodyPartLegs
@export var torso: BodyPartTorso
@export var flip_h: bool:
	set(value):
		if head == null:
			return
		if arms == null:
			return
		if legs == null:
			return
		if torso == null:
			return
		
		head.body_part_flip_h(value)
		arms.body_part_flip_h(value)
		legs.body_part_flip_h(value)
		torso.body_part_flip_h(value)
		flip_h = value


var player_ref: WeakRef

func _ready() -> void:
	player_ref = weakref(get_parent())
	BodyPartCollection.unlock_toggled.connect(on_unlock_toggled)
	for unlock_id: String in BodyPartCollection.get_toggled_unlocks():
		on_unlock_toggled(unlock_id, "")
	


func on_unlock_toggled(new_unlock_id: String, _previous_unlock_id: String) -> void:
	var template: BodyPartTemplate = Content.get_unlock_template(new_unlock_id)
	if template is HeadTemplate:
		head.setup_body_part(new_unlock_id, template.head_texture, template.torso_connection)
	elif template is TorsoTemplate:
		torso.setup_body_part(new_unlock_id, template.torso_texture, template.head_connection_position, template.torso_position, template.arm_connection_position_left, template.arm_connection_position_right, template.legs_connection_position_left, template.legs_connection_position_right)
	elif template is ArmsTemplate:
		arms.setup_body_part(new_unlock_id, template.arms_texture_left, template.arms_texture_right, template.torso_connection_left, template.torso_connection_right)
	elif template is LegsTemplate:
		legs.setup_body_part(new_unlock_id, template.legs_texture_left, template.legs_texture_right, template.torso_connection_left, template.torso_connection_right)
