class_name Body
extends Node2D

@export var head: iBodyPartHead
@export var torso: iBodyPartTorso
@export var arms: iBodyPartArms
@export var legs: iBodyPartLegs


func _physics_process(delta: float) -> void:
	head.physics_update(delta)
	torso.physics_update(delta)
	arms.physics_update(delta)
	legs.physics_update(delta)
