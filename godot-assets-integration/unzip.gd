var storage_path
var zip_file

signal progress(fileName, total)

var fileCount

func unzip(sourceFile,destination):
	zip_file = sourceFile
	storage_path = destination
	var gdunzip = load('res://gdunzip.gd').new()
	var loaded = gdunzip.load(zip_file)
	if !loaded:
		print('- Failed loading zip file')
		return false
	ProjectSettings.load_resource_pack(zip_file)
	var i = 0
	fileCount = len(gdunzip.files)
	for f in gdunzip.files:
		unzip_file(f)
		
func unzip_file(fileName):
	var readFile = File.new()
	
	if readFile.file_exists("res://" + fileName):
		readFile.open(("res://" + fileName), File.READ)
		
		var content = readFile.get_buffer(readFile.get_len())
		readFile.close()
		
		var base_dir = storage_path + fileName.get_base_dir()
		
		var dir = Directory.new()
		dir.make_dir(base_dir)
		
		emit_signal("progress", fileName, fileCount)
		
		var isFolder = fileName.ends_with("/")

		if isFolder:
			dir.make_dir_recursive(storage_path + fileName)
		else:
			var writeFile = File.new()
			writeFile.open(storage_path + fileName, File.WRITE)
			writeFile.store_buffer(content)
			writeFile.close()
