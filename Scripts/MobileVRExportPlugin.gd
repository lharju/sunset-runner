@tool
extends EditorExportPlugin
class_name MobileVRExportPlugin

func _get_android_manifest_element_contents(_platform, _debug) -> String:
	var contents: String = ""
	contents += "    <uses-permission android:name=\"android.permission.HIGH_SAMPLING_RATE_SENSORS\"/>"
	return contents


func _export_end() -> void:
	print("Exported with manifest for mobile VR")
