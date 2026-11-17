@tool
class_name Body
extends Node2D

@export var head: BodyPartHead
@export var arms: BodyPartArms
@export var legs: BodyPartLegs
@export var torso: BodyPartTorso

var _pda: BodyPDA = BodyPDA.new(self)


func _physics_process(delta: float) -> void:
	if _pda == null:
		return
		
	_pda.physics_update(delta)
