extends TextureButton

var world
var level_number
var set

func _ready():
	var lv_buttons = get_parent()
	var gui = lv_buttons.get_parent()
	world = gui.get_parent()
	level_number = z_index

func setButton():
	if(!set):
		set = true
		pressed.connect(self._button_pressed)
		mouse_entered.connect(self._mouse_entered)
		mouse_exited.connect(self._mouse_exited)

func _button_pressed():
	world.lv_num = level_number
	world.loadLv()

func _mouse_entered():
	world.pooplayer.set_pitch_scale(randf_range(1.3, 1.7))
	world.pooplayer.play()

func _mouse_exited():
	world.slurplayer.set_pitch_scale(randf_range(1.3, 1.7))
	world.slurplayer.play()
