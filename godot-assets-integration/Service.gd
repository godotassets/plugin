extends Node
class_name Service

onready var _req = HTTPRequest.new()

const _path: String = "http://127.0.0.1:7071%s"
const _file_folder = "user://godot-asset-integration/%s"
const _file_path = _file_folder % "token"

var _expires: int = 0
var _id_token: String = ""
var _token_type: String = ""
var _refresh_token: String = ""

func _ready():
	add_child(_req)
	_load_refresh_token()
	
func login(access_token: String):
	_refresh_token = access_token
	_token_type = "custom"
	
	yield(_update_id_token(), "completed")
	
	return _id_token != ""
	
func logout():
	_clear_refresh_token()
	_refresh_token = ""
	_token_type = ""
	
func is_logged_in():
	return _refresh_token != ""
	
func _update_id_token():
	if (OS.get_system_time_secs() < _expires):
		return
	
	var url = _path % "/api/plugin/login"
	var headers = ["Content-Type: application/json"]
	var json = JSON.print({
		"type": _token_type,
		"token": _refresh_token
	})
	
	_req.request(url, headers, true, HTTPClient.METHOD_POST, json)
	
	var result = yield(_req, "request_completed")
	var response_code = result[1]
	var body = result[3]
	
	if (response_code != 200):
		var msg = "godot-assets-integration received response_code of %s from server" % response_code
		_error(msg)
		return
		
	var data = JSON.parse(body.get_string_from_utf8()).result
	
	_expires = OS.get_system_time_secs() + int(data["expiresIn"])
	_id_token = data["idToken"]
	_refresh_token = data["refreshToken"]
	_token_type = "refresh"
	
	_save_refresh_token()

func _load_refresh_token():
	var file = File.new()
	var err = file.open_encrypted_with_pass(_file_path, File.READ, OS.get_unique_id())
	
	if (err == OK):
		_refresh_token = file.get_as_text()
		_token_type = "refresh"
		
		file.close()
	
func _save_refresh_token():
	var file = File.new()
	
	Directory.new().make_dir_recursive(_file_folder)
	
	var err = file.open_encrypted_with_pass(_file_path, File.WRITE, OS.get_unique_id())
	
	if (err == OK):
		file.store_string(_refresh_token)
		file.close()
	else:
		_error("Unable to store token")

func _clear_refresh_token():
	Directory.new().remove(_file_path)

func _error(message: String):
	printerr(message)
	push_error(message)