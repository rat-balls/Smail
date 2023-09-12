extends TextureProgressBar

var snail
var normal_under
var dried_under = preload("res://assets/dried_slimebar.png")

func _process(_delta):
	if(snail):
		value = snail.slimebar
	if(value <= 0):
		set_under_texture(dried_under)

func getSnail(Snail):
	snail = Snail

