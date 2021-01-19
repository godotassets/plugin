extends Node2D

onready var rect = get_node("ColorRect")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var thread = Thread.new()
var count = 0
var totalFiles = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var unzip = load("res://unzip.gd").new()
	
	unzip.connect("progress", self, "_on_Progress")
	
	thread.start(self, "_thread_function", unzip)
	
func _thread_function(unzip):
	unzip.unzip('C:/temp/save/3412.zip', 'res://output/')
	call_deferred("_on_Done")
	

func _on_Progress(fileName, total):
	count = count + 1
	totalFiles = total
	rect.rect_size.x = (float(count) / float(totalFiles)) * 512

func _on_Done():
	thread.wait_to_finish()
	print("Done motherfucka : " + str(count) + " of " + str(totalFiles))
