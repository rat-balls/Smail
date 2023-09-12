extends CharacterBody2D

var ti: TileMap
var tile
var SelectedTiles = []
var SelectedTile
var path_to_selected = []
var direction
var next_location
var speed = 200

var dead = false
var win = false
var slimebar = 15

var WalkableTiles
var astar
var world
var current_tile

func _ready():
	ti = get_parent()
	WalkableTiles = ti.WalkableTiles
	astar = ti.astar
	world = ti.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(ti):
		tile = ti.local_to_map(get_global_mouse_position())
		wipeSlime()
		handleHoverAndSelect()
		handlePath()
		
		if (Input.is_action_just_pressed("Restart")):
			dead = false
			slimebar = 14
			world.loadLv()
			
		if(WalkableTiles.has(str(ti.local_to_map(position)))):
			current_tile = WalkableTiles[str(ti.local_to_map(position))]
			handleCurrentTile()

func wipeSlime():
	for t in ti.get_used_cells(3):
		if (WalkableTiles.has(str(t))):
			
			if (WalkableTiles[str(t)].Slimed):
				ti.set_cell(1, Vector2(t.x, t.y), 2, Vector2i(9,3), 0)
			if (!WalkableTiles[str(t)].Slimed):
				ti.erase_cell(1, Vector2(t.x, t.y))
				
			if (WalkableTiles[str(t)].Used && t != ti.local_to_map(position)):
				WalkableTiles[str(t)].Used = false

func handlePath():
	if(!dead && !win):
		if (SelectedTiles.size() >= 1):
			path_to_selected = astar.get_point_path(
				astar.get_closest_point(position), 
				astar.get_closest_point(SelectedTile)
			)

func handleCurrentTile():
	
	if(current_tile.LeverTile && !current_tile.Used):
		leverFlip()
	
	if(current_tile.Water):
		Water()
	else:
		Slime()
		if(slimebar <= 0):
			Death()
	
	if(current_tile.WinTile && !dead):
		Win()


func Win():
	win = true
	world.winMsg.visible = true
	var sr = ti.get_surrounding_cells(ti.local_to_map(position))
	for dec_tile in ti.get_used_cells(2):
		var ti_cord = ti.get_cell_atlas_coords(2, dec_tile)
		if(sr.has(dec_tile)):
			if(ti_cord == Vector2i(7,3)):
				ti.erase_cell(2, dec_tile)
				ti.set_cell(2, dec_tile, 2, Vector2i(6,3), 0)
	if(Input.is_action_just_pressed("E")):
		if(world.lv_num < 4):
			world.nextLv()
			world.loadLv()
		else:
			world.backToMenu()

func leverFlip():
	var sr = ti.get_surrounding_cells(ti.local_to_map(position))
	for dec_tile in ti.get_used_cells(2):
		var ti_cord = ti.get_cell_atlas_coords(2, dec_tile)
		if(sr.has(dec_tile)):
			if(ti_cord == Vector2i(7,4)):
				ti.erase_cell(2, dec_tile)
				ti.set_cell(2, dec_tile, 2, Vector2i(8,4), 0)
			elif(ti_cord == Vector2i(8,4)):
				ti.erase_cell(2, dec_tile)
				ti.set_cell(2, dec_tile, 2, Vector2i(7,4), 0)
		if(ti_cord == Vector2i(4,4)):
			ti.erase_cell(2, dec_tile)
			ti.set_cell(2, dec_tile, 2, Vector2i(3,4), 0)
		elif(ti_cord == Vector2i(3,4)):
			ti.erase_cell(2, dec_tile)
			ti.set_cell(2, dec_tile, 2, Vector2i(4,4), 0)
		elif(ti_cord == Vector2i(5,4)):
			ti.erase_cell(2, dec_tile)
			ti.set_cell(2, dec_tile, 2, Vector2i(6,4), 0)
		elif(ti_cord == Vector2i(6,4)):
			ti.erase_cell(2, dec_tile)
			ti.set_cell(2, dec_tile, 2, Vector2i(5,4), 0)

		ti.setBarriers(ti_cord, dec_tile)
		if(WalkableTiles.has(str(dec_tile))):
			if(WalkableTiles[str(dec_tile)].OffBarrier):
				astar.set_point_disabled(WalkableTiles[str(dec_tile)].ID, true)
			elif(WalkableTiles[str(dec_tile)].OnBarrier):
				astar.set_point_disabled(WalkableTiles[str(dec_tile)].ID, false)
		ti.connectPoints()

func Water():
	slimebar = 14
	current_tile.Water = false
	current_tile.Used = true
	ti.erase_cell(3, ti.local_to_map(position))
	ti.set_cell(3, ti.local_to_map(position), 2, Vector2i(0,0), 0)

func handleHoverAndSelect():
	for t in ti.get_used_cells(0):
		if (WalkableTiles[str(t)].Hovered && !WalkableTiles[str(t)].Selected):
			ti.erase_cell(0, t)
			WalkableTiles[str(t)].Hovered = false
	
	if (WalkableTiles.has(str(tile)) && !WalkableTiles[str(tile)].Selected):
		
		ti.set_cell(0,tile, 2, Vector2i(1,4), 0)
		WalkableTiles[str(tile)].Hovered = true
		
		if(Input.is_action_just_pressed("rightClick")):
			print(WalkableTiles[str(tile)].ID)
		
		if (Input.is_action_just_pressed("leftClick")):
			ti.erase_cell(0, tile)
			ti.set_cell(0, tile, 2, Vector2i(2,4), 0)
			WalkableTiles[str(tile)].Selected = true
			SelectedTiles.push_front(tile)
			SelectedTile = ti.map_to_local(tile)
		
		if (SelectedTiles.size() > 1):
			WalkableTiles[str(SelectedTiles.back())].Selected = false
			SelectedTiles.pop_back()

func Slime():
	
	if (!current_tile.Used && !current_tile.Water):
		
		if (current_tile.Slimed):

			current_tile.Used = true
			current_tile.Slimed = false
			
	if (!current_tile.Used):
		
		if (!current_tile.Slimed):
			slimebar -= 1
			current_tile.Used = true
			if(slimebar > 0):
				current_tile.Slimed = true
				

func Death():
	dead = true
	path_to_selected = []
	direction = null
	SelectedTile = null
	world.deathMsg.visible = true
	if(SelectedTiles):
		WalkableTiles[str(SelectedTiles.back())].Selected = false
		SelectedTiles.pop_back()


func _physics_process(delta):
	
	if (path_to_selected.size() > 1):
		next_location = path_to_selected[1]
		direction = global_position.direction_to(next_location)
	elif (path_to_selected.size() == 1):
		next_location = path_to_selected[0]
		direction = global_position.direction_to(next_location)
	if(direction):
		global_position += direction * delta * speed
	
	if(SelectedTile != null):
		if(ti.inRange(ti.map_to_local(position), ti.map_to_local(SelectedTile), 200, 50)):
			path_to_selected = []
			SelectedTile = null
			direction = null
			WalkableTiles[str(SelectedTiles.back())].Selected = false
			SelectedTiles.pop_back()
