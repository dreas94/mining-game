extends GameMode

@export var tile_map: TileMapLayer
@export var mining_area: Area2D
@export var abandoned_house: iBuilding

var player: iPlayer
var player_scene: PackedScene = preload("uid://cr7vr5ke2lgfn")

func _init() -> void:
	visible = false


func _ready() -> void:
	tile_map.enabled = false


func _enabled() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.light.enabled = true
	player.global_position = Vector2(8.0, -8.0)
	visible = true
	tile_map.enabled = true
	mining_area.body_entered.connect(_on_body_entered_mining_area)
	abandoned_house.player_entered.connect(_on_player_entered_abandoned_house)
	abandoned_house.player_exited.connect(_on_player_exited_abandoned_house)


func _disabled() -> void:
	visible = false
	mining_area.body_entered.disconnect(_on_body_entered_mining_area)
	abandoned_house.player_entered.disconnect(_on_player_entered_abandoned_house)
	abandoned_house.player_exited.disconnect(_on_player_exited_abandoned_house)
	player.queue_free()
	tile_map.enabled = false


func _on_body_entered_mining_area(body: Node2D) -> void:
	if not visible:
		return
	if not body is iPlayer:
		return
	
	Game.state.enter_state(GameStateMines.new())


func _on_player_entered_abandoned_house() -> void:
	if not visible:
		return
	Interface.upgrade_menu.enable()


func _on_player_exited_abandoned_house() -> void:
	if not visible:
		return
	Interface.upgrade_menu.disable()
