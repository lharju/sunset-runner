extends Label3D

func _ready() -> void:
	var dir := DirAccess.open("user://")
	if dir == null: 
		printerr("Could not open folder")
		return
	var temp = ""
	for file: String in dir.get_files():
		temp += file + "\n"
		
	#var Context: JavaClass
	#var WindowManager: JavaClass
	#var DisplayMetrics: JavaClass
	#if OS.has_feature("android"):
	#	Context = JavaClassWrapper.wrap("android.content.Context")
	#	WindowManager = JavaClassWrapper.wrap("android.view.WindowManager")
	#	DisplayMetrics = JavaClassWrapper.wrap("android.util.DisplayMetrics")
	#	var context = Context.Context()
	#	var dm = DisplayMetrics.DisplayMetrics()
	#	temp = temp + str(dm.xdpi) + ":" + str(dm.ydpi)
	
	var a: Vector2 = DisplayServer.screen_get_size() / float(DisplayServer.screen_get_dpi())
	text = temp + str(a) + "\n" + str(AndroidManager.screen_size)
	
	
	return
	# Retrieve the AndroidRuntime singleton.
	if OS.has_feature("android"):

		var android_runtime = Engine.get_singleton("AndroidRuntime")
		if android_runtime:
			# Retrieve the Android Activity instance.
			var activity = android_runtime.getActivity()
	
			# Create a Godot Callable to wrap the toast display logic.
			var toast_callable = func():
				# Use JavaClassWrapper to retrieve the android.widget.Toast class, then make and show a toast using the class APIs.
				var ToastClass = JavaClassWrapper.wrap("android.widget.Toast")
				ToastClass.makeText(activity, "This is a test", ToastClass.LENGTH_LONG).show()
	
			# Wrap the Callable in a Java Runnable and run it on the Android UI thread to show the toast.
			activity.runOnUiThread(android_runtime.createRunnableFromGodotCallable(toast_callable))
			
			# Retrieve the Android Vibrator system service and check if the device supports it.
			var vibrator_service = android_runtime.getApplicationContext().getSystemService("vibrator")
			if vibrator_service and vibrator_service.hasVibrator():
				# Configure and run a VibrationEffect.
				var VibrationEffect = JavaClassWrapper.wrap("android.os.VibrationEffect")
				var effect = VibrationEffect.createOneShot(10000, VibrationEffect.DEFAULT_AMPLITUDE)
				vibrator_service.vibrate(effect)
		
		
func _process(_delta: float) -> void:
	text = str(AndroidManager.get_screen_size())
	
