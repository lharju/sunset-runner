@tool
extends EditorPlugin

const ExportPlugin = preload("res://Scripts/MobileVRExportPlugin.gd")
var export_plugin = ExportPlugin.new()

func _enter_tree():
	add_export_plugin(export_plugin)

func _exit_tree():
	remove_export_plugin(export_plugin)
