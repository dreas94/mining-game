class_name iIdentityMenu
extends Control
const IDENTITY_SCENE: PackedScene = preload("uid://btwucrs8x1cep")

@export var _face_vbox_container: VBoxContainer
@export var _torso_vbox_container: VBoxContainer
@export var _arms_vbox_container: VBoxContainer
@export var _legs_vbox_container: VBoxContainer


func _ready() -> void:
	visible = false
	BodyPartCollection.unlock_added.connect(_on_unlock_added)
	BodyPartCollection.unlock_toggled.connect(_on_unlock_toggled)


func enable() -> void:
	visible = true


func disable() -> void:
	visible = false


func _on_unlock_added(unlock_id: String) -> void:
	var template: BodyPartTemplate = Content.get_unlock_template(unlock_id)
	if template is HeadTemplate:
		iIdentityButton.new(_face_vbox_container, template.name, template.get_body_part_id())
	elif template is TorsoTemplate:
		iIdentityButton.new(_torso_vbox_container, template.name, template.get_body_part_id())
	elif template is ArmsTemplate:
		iIdentityButton.new(_arms_vbox_container, template.name, template.get_body_part_id())
	elif template is LegsTemplate:
		iIdentityButton.new(_legs_vbox_container, template.name, template.get_body_part_id())


func _on_unlock_toggled(_unlock_id: String, previous_unlock_id: String) -> void:
	if previous_unlock_id == "":
		return
	var template: BodyPartTemplate = Content.get_unlock_template(previous_unlock_id)
	if template is HeadTemplate:
		for id_btn: iIdentityButton in _face_vbox_container.get_children():
			if id_btn.id != previous_unlock_id:
				continue
			id_btn.button_pressed = false
	elif template is TorsoTemplate:
		for id_btn: iIdentityButton in _torso_vbox_container.get_children():
			if id_btn.id != previous_unlock_id:
				continue
			id_btn.button_pressed = false
	elif template is ArmsTemplate:
		for id_btn: iIdentityButton in _arms_vbox_container.get_children():
			if id_btn.id != previous_unlock_id:
				continue
			id_btn.button_pressed = false
	elif template is LegsTemplate:
		for id_btn: iIdentityButton in _legs_vbox_container.get_children():
			if id_btn.id != previous_unlock_id:
				continue
			id_btn.button_pressed = false
