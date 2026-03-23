# Content Autoload Script
extends Node

const CONTENT_DIR: String = "res://Content/"
const RESOURCE_EXTENSIONS: Array[String] = ["tres", "res"]
const SCENE_EXTENSIONS: Array[String] = ["tscn", "scn"]
const SCRIPT_EXTENSIONS: Array[String] = ["gd", "gdc"]

const ITEM_TEMPLATE_DIR: String = CONTENT_DIR + "ItemTemplates"
const UPGRADE_TEMPLATE_DIR: String = CONTENT_DIR + "UpgradeTemplates"

var item_templates: ResourceProvider = ResourceProvider.new(
		ITEM_TEMPLATE_DIR, RESOURCE_EXTENSIONS)

var upgrade_templates: ResourceProvider = ResourceProvider.new(
	UPGRADE_TEMPLATE_DIR,  RESOURCE_EXTENSIONS)


func _init() -> void:
	Logger.hint(self, _init, "Discovered %s ItemTemplates" % item_templates.get_count())


func get_item_template(file_name_without_extension: String) -> ItemTemplate:
	return item_templates.get_resource(file_name_without_extension) as ItemTemplate


func get_upgrade_template(file_name_without_extension: String) -> UpgradeTemplate:
	return upgrade_templates.get_resource(file_name_without_extension) as UpgradeTemplate
