extends Node

var lv_num = 1
var lv

#bg
@onready var menuBG = $BG/BGs/MenuBG

#moving ui
@onready var camera = $Camera2D
@onready var moving_ui = $MovingUI
@onready var moving_gui = $MovingUI/MovingGUI
@onready var winMsg = $MovingUI/MovingGUI/WinMessage
@onready var deathMsg = $MovingUI/MovingGUI/DeathMessage
@onready var quitBTN = $MovingUI/MovingGUI/QuitButton
@onready var slime_bar = $MovingUI/MovingGUI/SlimeBar

#ui
@onready var ui = $UI
@onready var gui = $UI/GUI
@onready var leaveBTN = $UI/GUI/LeaveButton
@onready var levelBTNs = $UI/GUI/LevelButtons
@onready var startBTN = $UI/GUI/StartButton

#sfx players
@onready var pooplayer = $SnailPoop
@onready var slurplayer = $SnailSlurp
@onready var slurpwater = $SnailWaterSlurp
@onready var deathplayer = $SnailDeath
@onready var bgplayer = $BGMusic


func _ready():
	levelBTNs.get_node("LevelButton1").setButton()

func nextLv():
	lv_num += 1

func loadLv():
	menuBG.visible = false
	moving_ui.visible = true
	ui.visible = false
	remove_child(lv)
	var Level = load('res://level0' + str(lv_num) + '.tscn')
	lv = Level.instantiate()
	add_child(lv)
	slime_bar.getSnail(lv.character)
	#get_node("Visualizer").visualize(lv.astar)

func backToMenu():
	camera.zoom = Vector2(1,1)
	lv_num = 1
	menuBG.visible = true
	moving_ui.visible = false
	ui.visible = true
	remove_child(lv)
	moving_gui.remove_child(slime_bar)


func _on_leave_button_pressed():
	get_tree().quit()


func _on_quit_button_pressed():
	backToMenu()


func _on_start_button_pressed():
	loadLv()


func _on_start_button_mouse_entered():
	pooplayer.set_pitch_scale(1)
	pooplayer.play()

func _on_start_button_mouse_exited():
	slurplayer.set_pitch_scale(1)
	slurplayer.play()


func _on_bg_music_finished():
	bgplayer.play()
