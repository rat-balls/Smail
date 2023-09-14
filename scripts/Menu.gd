extends Node

var lv_num = 1
var lv
var SlimeBar = preload('res://slime_bar.tscn')
var slime_bar
var menuBG
var startBTN
var quitBTN
var levelBTNs
var deathMsg
var winMsg
var leaveBTN
var pooplayer
var slurplayer
var deathplayer

func _ready():
	menuBG = get_node("GUI/MenuBG")
	startBTN = get_node("GUI/StartButton")
	quitBTN = get_node("GUI/QuitButton")
	levelBTNs = get_node("GUI/LevelButtons")
	deathMsg = get_node("GUI/DeathMessage")
	winMsg = get_node("GUI/WinMessage")
	leaveBTN = get_node("GUI/LeaveButton")
	pooplayer = get_node("SnailPoop")
	slurplayer = get_node("SnailSlurp")
	deathplayer = get_node("SnailDeath")

func nextLv():
	lv_num += 1

func loadLv():
	quitBTN.visible = true
	menuBG.visible = false
	startBTN.visible = false
	levelBTNs.visible = false
	deathMsg.visible = false
	winMsg.visible = false
	leaveBTN.visible = false
	#load level
	remove_child(lv)
	var Level = load('res://level0' + str(lv_num) + '.tscn')
	lv = Level.instantiate()
	add_child(lv)
	#load visualizer
	# get_node("Visualizer").visualize(lv.astar)
	#load slime bar
	get_node("GUI").remove_child(slime_bar)
	slime_bar = SlimeBar.instantiate()
	get_node("GUI").add_child(slime_bar)
	slime_bar.getSnail(lv.character)

func backToMenu():
	lv_num = 1
	quitBTN.visible = false
	menuBG.visible = true
	startBTN.visible = true
	levelBTNs.visible = true
	deathMsg.visible = false
	winMsg.visible = false
	leaveBTN.visible = true
	remove_child(lv)
	get_node("GUI").remove_child(slime_bar)


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
