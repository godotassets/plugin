extends Control

const TokenStore = preload("res://TokenStore.gd")
onready var token_store = TokenStore.new()

func _ready():
	add_child(token_store);
	token_store.get_id_token()
	var token = token_store.get_value()
	
	if token != null:
		get_tree().change_scene("res://Asset List.tscn")
		return
		
	$HTTPRequest.connect("request_completed", self, "_on_HttpRequest_completed")


func _on_LoginButton_pressed():
	var url = "http://127.0.0.1:7071/api/plugin/login"
	var headers = ["Content-Type: application/json"]
	var json = JSON.print({
		"type": "custom",
		"token": $CenterColumn/TokenInput.text
	})
	
	$HTTPRequest.request(url, headers, true, HTTPClient.METHOD_POST, json)
	
func _on_HttpRequest_completed(result, response_code, headers, body):
	
	if (response_code != 200):
		# display an error message if we failed to login
		return
		
	var data = JSON.parse(body.get_string_from_utf8()).result


# disable login button if no token entered
# store refresh/id tokens after receiving
# switch to Asset List scene after login AND on ready if we have a refresh token stored
