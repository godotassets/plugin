extends Control
class_name Page

signal change_scene(scene)

func navigate(scene: String):
	emit_signal("change_scene", scene)
