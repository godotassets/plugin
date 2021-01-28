extends Control

onready var _service: Service = load("res://Service.gd").new()

func _ready():
	add_child(_service)
	
	if _service.is_logged_in():
		get_tree().change_scene("res://AssetList.tscn")
		
func _process(delta):
	$CenterColumn/LoginButton.disabled = $CenterColumn/TokenInput.text == ""

func _on_LoginButton_pressed():
	var result = yield(_service.login($CenterColumn/TokenInput.text), "completed")
	
	if result == true:
		get_tree().change_scene("res://AssetList.tscn")

func _on_LinkButton_pressed():
	OS.shell_open("https://github.com/godotassets/plugin/blob/main/README.md")
