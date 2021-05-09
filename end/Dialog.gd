extends Node

export (String, FILE, "*.json") var flow_file_path
export (float) var text_speed = 1.0

#var mouse_over : bool = false
var flow : Directory = null
var line_index : int
var text_percent_visiable : float

onready var tween = $Tween
onready var dialog_name = $"MarginContainer/MarginContainer/VBoxContainer/Name"
onready var dialog_text = $"MarginContainer/MarginContainer/VBoxContainer/Text"

func _ready():
	flow = _load_flow_from_file(flow_file_path)
	line_index = 1
	text_percent_visiable = 0
	update_dialog()

func _process(delta):
	dialog_text.percent_visible = text_percent_visiable

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if text_percent_visiable == 1:
			line_index += 1
			update_dialog()

func update_dialog():
	dialog_name.text = flow[str(line_index)].name
	dialog_text.percent_visible = 0
	dialog_text.text = flow[str(line_index)].text
	var text_length = dialog_text.text.length()
	tween.interpolate_property(self, "text_percent_visiable", 0, 1, text_length / 16 * text_speed)
	if not tween.is_active():
		tween.start()

func _load_flow_from_file(path) -> Directory:
	var file = File.new()
	assert(file.file_exists(path))
	
	file.open(path, file.READ)
	var flow = parse_json(file.get_as_text())
	assert(flow.size() > 0)
	
	return flow
