extends Control

onready var _service: Service = load("res://Service.gd").new()

const AssetResource = preload("res://Asset.tscn")

func _ready():
	add_child(_service)
	_refresh_list()

func _on_LogoutButton_pressed():
	_service.logout()
	get_tree().change_scene("res://Login.tscn")
	
func _refresh_list():
	$Layout/Padding/Header/RefreshButton.disabled = true
	
	var assets = yield(_service.get_list(), "completed")
	
	for asset in assets:
		var instance = AssetResource.instance()
		$Layout/Scroll/Content/List.add_child(instance)
		
		instance.get_node("Padding/Content/Name").text = asset["asset"]["name"]
		instance.get_node("Padding/Content/Publisher").text = asset["asset"]["publisher"]
		
		var image = yield(_service.load_image_from_url(asset["asset"]["imagePath"]), "completed")
		
		if image == null:
			continue
			
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		
		instance.get_node("Image").texture = texture
	
	$Layout/Padding/Header/RefreshButton.disabled = false


func _on_RefreshButton_pressed():
	var list = $Layout/Scroll/Content/List
	
	for n in list.get_children():
		list.remove_child(n)
		n.queue_free()
		
	_refresh_list()
