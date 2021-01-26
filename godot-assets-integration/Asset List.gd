extends Control

onready var list = get_node("Layout/Scroll/Content/List")
const AssetResource = preload("res://Asset.tscn")

func _ready():
	for i in range(20):
		var instance = AssetResource.instance()
		list.add_child(instance)
