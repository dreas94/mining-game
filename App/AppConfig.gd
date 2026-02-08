class_name AppConfig
extends Resource
## Game Config Resource
##
## A simple resource which can be loaded in various parts of your app to apply configurations.
## The default location is res://app_config.tres.

@export_category("Saving")
@export var save_file_format_version: int = 1
@export_category("Settings")
@export var settings_file_version: int = 1
