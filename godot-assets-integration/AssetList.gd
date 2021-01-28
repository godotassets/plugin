extends Control

onready var _service: Service = load("res://Service.gd").new()

const AssetResource = preload("res://Asset.tscn")

func _ready():
	for i in range(20):
		var instance = AssetResource.instance()
		$Layout/Scroll/Content/List.add_child(instance)


func _on_LogoutButton_pressed():
	_service.logout()
	get_tree().change_scene("res://Login.tscn")
