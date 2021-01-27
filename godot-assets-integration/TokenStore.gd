extends Node

const path = "user://godot-asset-integration/token"

func get_value():
	var f = File.new()
	var err = f.open_encrypted_with_pass(path, File.READ, OS.get_unique_id())
	
	if (err == OK):
		var result = f.get_as_text()
		f.close()
	
		return result
	else:
		return null
	
func set_value(token):
	pass
	
func get_id_token():
	var req = HTTPRequest.new()
	add_child(req)
	
	var url = "http://127.0.0.1:7071/api/plugin/login"
	var headers = ["Content-Type: application/json"]
	var json = JSON.print({
		"type": "custom",
		"token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIxdG9sOGZJdExsaE02Z1gzRjFqZzVhVUQwaUIzIiwiaXNzIjoiZmlyZWJhc2UtYWRtaW5zZGstbjNubmZAZ29kb3QtYXNzZXRzLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwic3ViIjoiZmlyZWJhc2UtYWRtaW5zZGstbjNubmZAZ29kb3QtYXNzZXRzLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiaHR0cHM6Ly9pZGVudGl0eXRvb2xraXQuZ29vZ2xlYXBpcy5jb20vZ29vZ2xlLmlkZW50aXR5LmlkZW50aXR5dG9vbGtpdC52MS5JZGVudGl0eVRvb2xraXQiLCJleHAiOjE2MTE3MjM1NDEsImlhdCI6MTYxMTcxOTk0MX0.OgufRu7_p0S5lJNhkWZj9A387ePE125EfvdZdzu-TaSTORCifR1JvN1nsgANwZ6Knr223rzZ9XeenP0w19aAZ4okVQm-THfrJ-R-59Py6qfLfWg5Iu6QppDSrvriVAJdaDHlYU9VQj_WF_J06g1SwsFnd19_KeGs1XIy24OnKDIYOPW_3L8jHX_ya2x58ZvGk9MrvH6ceXaxO885JMShk2WnjAd_p0ck8JA5VFaIMfteVqMvH0Ngvs7tex1KwczmxmUSbIYwfNnLkiRBOmfM-sNs0BdQDXSYuD20fougypiqFbl8m2Oq5O6AYUBSWaic_73cAhuoAdWv6szOtHDfSQ"
	})
	
	req.request(url, headers, true, HTTPClient.METHOD_POST, json)
	
	var result = yield(req, "request_completed")
	var response_code = result[1]
	var body = result[3]
	
	if (response_code != 200):
		return null
		
	var data = JSON.parse(body.get_string_from_utf8()).result
	var expires_in = data["expiresIn"]
	var id_token = data["idToken"]
	var refresh_token = data["refreshToken"]
	
	pass

func _on_HttpRequest_completed():
	print("basdrf")
