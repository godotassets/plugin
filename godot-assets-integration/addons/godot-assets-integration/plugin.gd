tool
extends EditorPlugin

var instance

func _enter_tree():
	self.connect("main_screen_changed", self, "_main_screen_changed")
	
	make_visible(false)

func _exit_tree():
	if instance:
		instance.queue_free()
	
func has_main_screen():
	return true
	
func make_visible(visible):
	if instance:
		instance.visible = visible
	
func get_plugin_name():
	return "Godot Assets Integration"
	
func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
	
func _main_screen_changed(screen_name):
	if screen_name == get_plugin_name():
		if instance == null:
			_on_change_scene("res://addons/godot-assets-integration/AssetList.tscn")
		else:
			get_editor_interface().get_editor_viewport().add_child(instance)
	else:
		get_editor_interface().get_editor_viewport().remove_child(instance)
	
func _on_change_scene(scene: String):
	if instance:
		get_editor_interface().get_editor_viewport().remove_child(instance)
		instance.queue_free()
	
	instance = load(scene).instance()
	instance.connect("change_scene", self, "_on_change_scene")
	get_editor_interface().get_editor_viewport().add_child(instance)
