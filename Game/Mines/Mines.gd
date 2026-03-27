extends GameMode

@export var breakable_tile_map_layer: BreakableTileMapLayer
@export var cave_generator: CaveGenerator
@export var tile_handler: TileHandler

var player: iPlayer
var player_scene: PackedScene = preload("uid://cr7vr5ke2lgfn")


func _init() -> void:
	visible = false 


func _enabled() -> void:
	cave_generator.generate(breakable_tile_map_layer)
	player = player_scene.instantiate()
	add_child(player)
	player.light.enabled = true
	player.global_position = Vector2(8.0, -8.0)
	player.mine_attempt_by_rid.connect(_attempt_to_clear_cell)
	Health.reset_health(Health.maximum)
	Health.current_changed.connect(_on_current_health_changed)
	App.music.play(DefaultMusic.BEYOND)
	visible = true
	enabled.emit()


func _physics_process(_delta: float) -> void:
	if breakable_tile_map_layer == null:
		return
	if player == null:
		return
	var player_cell: Vector2i = breakable_tile_map_layer.local_to_map(breakable_tile_map_layer.to_local(player.global_position))
	if player_cell.x >= cave_generator.min_width and player_cell.x <= cave_generator.max_width and player_cell.y >= cave_generator.min_height and player_cell.y <= cave_generator.max_height:
		return
	Health.set_health(0)


func lose() -> void:
	player.light.enabled = false
	App.sfx.play(DefaultSoundEffects.DEATH)
	App.music.stop()
	player.alive = false
	App.state.enter_state(AppStateLose.new())


func _disabled() -> void:
	visible = false
	Health.current_changed.disconnect(_on_current_health_changed)
	tile_handler.clear_handler()
	breakable_tile_map_layer.clear_tilemaps()
	player.mine_attempt_by_rid.disconnect(_attempt_to_clear_cell)
	player.queue_free()
	Health.reset_health()


func _attempt_to_clear_cell(damage: int, rid: RID):
	breakable_tile_map_layer.attempt_to_clear_cell(damage, rid, player.position)


func _on_current_health_changed(_previous: float, current: float) -> void:
	if current > 0.0:
		return
	lose()
