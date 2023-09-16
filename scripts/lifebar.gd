extends TextureProgressBar

var snail
var normal_under = preload("res://assets/slimebar2-export.png")
var dried_under = preload("res://assets/dried_slimebar.png")


func _process(_delta):
	if(snail):
		value = snail.slimebar
	if(value <= 0):
		set_under_texture(dried_under)

func getSnail(Snail):
	snail = Snail
	set_under_texture(normal_under)

