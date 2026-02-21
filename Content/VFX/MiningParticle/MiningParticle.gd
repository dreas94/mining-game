class_name iMiningParticles
extends Node2D

@export var particles: CPUParticles2D


func _ready() -> void:
	particles.finished.connect(_on_particles_finished)
	particles.emitting = true


func _on_particles_finished() -> void:
	queue_free()
