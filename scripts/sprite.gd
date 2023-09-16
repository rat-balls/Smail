extends Sprite2D


var snail_tl = preload("res://assets/SnailSprite/SnailSprite_LeftUp.png")
var snail_bl = preload("res://assets/SnailSprite/SnailSprite_LeftDown.png")
var snail_tr = preload("res://assets/SnailSprite/SnailSprite_RightUp.png")
var snail_br = preload("res://assets/SnailSprite/SnailSprite_RightDown.png")

var osnail_tl = preload("res://assets/SnailSprite/OiledSnailSprite_LeftUp.png")
var osnail_bl = preload("res://assets/SnailSprite/OiledSnailSprite_LeftDown.png")
var osnail_tr = preload("res://assets/SnailSprite/OiledSnailSprite_RightUp.png")
var osnail_br = preload("res://assets/SnailSprite/OiledSnailSprite_RightDown.png")

var dsnail_tl = preload("res://assets/SnailSprite/DriedSnailSprite_LeftUp.png")
var dsnail_bl = preload("res://assets/SnailSprite/DriedSnailSprite_LeftDown.png")
var dsnail_tr = preload("res://assets/SnailSprite/DriedSnailSprite_RightUp.png")
var dsnail_br = preload("res://assets/SnailSprite/DriedSnailSprite_RightDown.png")

var snail
var spritimer = 0
var sprit = 1
var sprit_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	snail = get_parent()
	sprit_array = [osnail_br, osnail_bl, osnail_tl, osnail_tr]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(snail.direction):
		if(snail.oiled):
			spritimer += 1
			if(spritimer >= 7):
				set_texture(sprit_array[sprit])
				sprit += 1
				if(sprit == 4):
					sprit = 1
				spritimer = 1
		else:
			if(snail.direction.x <= 1 && snail.direction.x >= 0):
				if(snail.direction.y <= 1 && snail.direction.y >= 0):
					set_texture(snail_br)
				if(snail.direction.y >= -1 && snail.direction.y <= 0):
					set_texture(snail_tr)
			if(snail.direction.x >= -1 && snail.direction.x <= 0):
				if(snail.direction.y <= 1 && snail.direction.y >= 0):
					set_texture(snail_bl)
				if(snail.direction.y >= -1 && snail.direction.y <= 0):
					set_texture(snail_tl)
	
	if(snail.dead):
		if(texture == snail_br):
			set_texture(dsnail_br)
		if(texture == snail_tr):
			set_texture(dsnail_tr)
		if(texture == snail_bl):
			set_texture(dsnail_bl)
		if(texture == snail_tl):
			set_texture(dsnail_tl)
