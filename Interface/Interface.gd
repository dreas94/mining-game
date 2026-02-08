# Interface Autoload Script
extends Node

const UI_CANVAS_LAYER: int = 2
const MAIN_MENU_SCENE: PackedScene = preload("uid://cedfub537lkht")

var _root_canvas_layer: CanvasLayer

var layer_hud: Control:
	get: return _layer_hud
var _layer_hud: Control

var layer_main: Control:
	get: return _layer_main
var _layer_main: Control

var layer_popup: Control:
	get: return _layer_popup
var _layer_popup: Control

var layer_postprocessing: Control:
	get: return _layer_postprocessing
var _layer_postprocessing: Control

# MAIN
var main_menu: iMainMenu:
	get: return _main_menu
var _main_menu: iMainMenu


@warning_ignore("untyped_declaration")
func _set_readonly(_value) -> void:
	Logger.error(self, _set_readonly, "This property can not be set outside initalization.")


func _init() -> void:
	_root_canvas_layer = CanvasLayer.new()
	add_child(_root_canvas_layer)
	_root_canvas_layer.layer = UI_CANVAS_LAYER
	
	_layer_hud = Layer.new(_root_canvas_layer, "Hud")
	_layer_main = Layer.new(_root_canvas_layer, "Main")
	_layer_popup = Layer.new(_root_canvas_layer, "Popup")
	_layer_postprocessing = Layer.new(_root_canvas_layer, "PostFx")
	
	#MAIN
	_main_menu = _instance_to_layer(MAIN_MENU_SCENE, _layer_main)


func _new_to_layer(script: Script, layer: Layer) -> Object:
	var i: Node = script.new()
	layer.add_child(i)
	return i


func _instance_to_layer(scene: PackedScene, layer: Layer) -> Object:
	var i: Node = scene.instantiate()
	layer.add_child(i)
	return i


class Layer extends Control:
	
	func _init(parent: Node, new_name: String) -> void:
		parent.add_child(self)
		name = new_name
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		focus_mode = Control.FOCUS_NONE
