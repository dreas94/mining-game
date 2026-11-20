@tool
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

var _pda: BodyPDA = BodyPDA.new(self)


func _physics_process(delta: float) -> void:
	if _pda == null:
		return
		
	_pda.physics_update(delta)
