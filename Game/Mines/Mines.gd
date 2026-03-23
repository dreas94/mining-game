extends GameMode

@export var breakable_tile_map_layer: BreakableTileMapLayer
@export var cave_generator: CaveGenerator
@export var tile_handler: TileHandler

var player: iPlayer
var health: Health = Health.new()
var player_scene: PackedScene = preload("uid://cr7vr5ke2lgfn")


func _init() -> void:
	visible = false 


func _ready() -> void:
	health.current_changed.connect(_on_current_health_changed)


func _enabled() -> void:
	cave_generator.generate(breakable_tile_map_layer)
	player = player_scene.instantiate()
	add_child(player)
	player.light.enabled = true
	player.global_position = Vector2(8.0, -8.0)
	player.mine_attempt_by_rid.connect(_attempt_to_clear_cell)
	App.music.play(DefaultMusic.BEYOND)
	visible = true
	enabled.emit()


func lose() -> void:
	player.light.enabled = false
	App.sfx.play(DefaultSoundEffects.DEATH)
	App.music.stop()
	player.alive = false
	App.state.enter_state(AppStateLose.new())


func _disabled() -> void:
	visible = false
	tile_handler.clear_handler()
	breakable_tile_map_layer.clear_tilemaps()
	player.mine_attempt_by_rid.disconnect(_attempt_to_clear_cell)
	player.queue_free()
	health.reset_health()


func _attempt_to_clear_cell(damage: int, rid: RID):
	breakable_tile_map_layer.attempt_to_clear_cell(damage, rid, player.position)


func _on_current_health_changed(_previous: float, current: float) -> void:
	if current > 0.0:
		return
	lose()
