extends HBoxContainer

var asset_id: String
var asset_name: String
var image_path: String
var publisher: String
var service: Service

func _ready():
	$ButtonContainer/InstallButton.visible = false
	$Padding/Content/Name.text = asset_name
	$Padding/Content/Publisher.text = publisher
	
	_load_image()
	
func _load_image():
	var image = yield(service.load_image_from_url(image_path), "completed")
	
	if image == null:
		return
		
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	$Image.texture = texture


func _on_DownloadButton_pressed():
	$ButtonContainer/DownloadButton.disabled = true
	
	var result = yield(service.download_asset(asset_id, asset_name), "completed")
	
	$ButtonContainer/DownloadButton.disabled = false
	$ButtonContainer/InstallButton.visible = result != null
