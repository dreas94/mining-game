extends GameMode

@export var breakable_tile_map_layer: BreakableTileMapLayer
@export var campfire: CampFire
@export var cave_generator: CaveGenerator

var player: iPlayer

var player_scene: PackedScene = preload("uid://cr7vr5ke2lgfn")


func _init() -> void:
	visible = false


func _enabled() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(-20.8, 40.0)
	player.mine_attempt.connect(_attempt_to_clear_cell_from_position)
	campfire.enabled = true
	App.music.play(DefaultMusic.BEYOND)
	visible = true
	enabled.emit()


func _disabled() -> void:
	player.mine_attempt.disconnect(_attempt_to_clear_cell_from_position)
	player.queue_free()


func _attempt_to_clear_cell_from_position(damage: int, rid: RID):
	breakable_tile_map_layer.attempt_to_clear_cell_from_position(damage, rid, player.position)
