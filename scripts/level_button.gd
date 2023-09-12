extends TextureButton

var world
var level_number

func _ready():
	var lv_buttons = get_parent()
	var gui = lv_buttons.get_parent()
	world = gui.get_parent()
	pressed.connect(self._button_pressed)
	level_number = z_index


func _button_pressed():
	world.lv_num = level_number
