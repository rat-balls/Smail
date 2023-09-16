extends Camera2D

@onready var ui = $"../MovingUI"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!get_parent().menuBG.visible):
		if(Input.is_action_pressed("scrollUp")):
			if(zoom < Vector2(1.5, 1.5)):
				ui.follow_viewport_scale = zoom
				zoom += Vector2(0.01, 0.01)
		if(Input.is_action_pressed("scrollDown")):
			if(zoom > Vector2(1, 1)):
				ui.follow_viewport_scale += 0.007
				zoom -= Vector2(0.01, 0.01)

		if(Input.is_action_just_pressed("scrollUp")):
			if(zoom < Vector2(1.5, 1.5)):
				ui.follow_viewport_scale -= 0.02
				zoom += Vector2(0.03, 0.03)
		if(Input.is_action_just_pressed("scrollDown")):
			if(zoom > Vector2(1, 1)):
				ui.follow_viewport_scale += 0.02
				zoom -= Vector2(0.03, 0.03)
