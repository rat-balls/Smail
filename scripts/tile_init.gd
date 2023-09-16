extends TileMap

var astar: AStar2D
var point_id = 0
var WalkableTiles = {}
var Snail: PackedScene
var character: CharacterBody2D
var win_cell
var win_surr_cells = []
var lever_cells = []
var lever_surr_cells = []
var spwnTile = Vector2i(100,100)

# Called when the node enters the scene tree for the first time.
func _ready():
	astar = AStar2D.new()
	Snail = load('res://scenes/snail.tscn')
	setGrid()
	var snail = Snail.instantiate()
	add_child(snail)
	character = get_node("Snail")
	if(character):
		for tile in get_used_cells(2):
			var tl_cords = get_cell_atlas_coords(2, tile)
			if(tl_cords == Vector2i(9,4)):
				spwnTile = tile
		character.position = astar.get_point_position(WalkableTiles[str(spwnTile)].ID)


func setGrid():
	for tile in get_used_cells(3):
		setWalkableTiles(tile)
	for ti in get_used_cells(2):
		setDecorationTileProperties(ti)
	for tile in get_used_cells(3):
		setWalkableTileProperties(tile)
		addPoints(tile)
	
	connectPoints()

func setWalkableTiles(tile):
	WalkableTiles[str(tile)] = {
		"ID": null,
		"Hovered": false,
		"Selected": false,
		"Slimed": false,
		"Used": false,
		"Water": false,
		"WinTile": false,
		"OnBarrier": false,
		"OffBarrier": false,
		"LeverTile": false,
		"Oil": false
	}

func setDecorationTileProperties(ti):
	var ti_cord = get_cell_atlas_coords(2, ti)
	if(ti_cord == Vector2i(7,3)):
		win_cell = ti
		win_surr_cells = get_surrounding_cells(ti)
	setBarriers(ti_cord, ti)
	if(ti_cord == Vector2i(7,4)
	|| ti_cord == Vector2i(8,4)):
		lever_cells.push_back(ti)
		lever_surr_cells += get_surrounding_cells(ti)

func setBarriers(ti_cord, ti):
	if(ti_cord == Vector2i(3,4)
	|| ti_cord == Vector2i(6,4)):
		WalkableTiles[str(ti)].OffBarrier = true
		WalkableTiles[str(ti)].OnBarrier = false
	if(ti_cord == Vector2i(4,4)
	|| ti_cord == Vector2i(5,4)):
		WalkableTiles[str(ti)].OnBarrier = true
		WalkableTiles[str(ti)].OffBarrier = false

func setWalkableTileProperties(tile):
	var cord = get_cell_atlas_coords(3, tile)
	if(cord == Vector2i(6,0) 
	|| cord ==  Vector2i(7,0) 
	|| cord == Vector2i(8,0) 
	|| cord == Vector2i(9,0)):
		WalkableTiles[str(tile)].Water = true
	if(cord == Vector2i(1,1) 
	|| cord ==  Vector2i(2,1) 
	|| cord == Vector2i(3,1) 
	|| cord == Vector2i(4,1)):
		WalkableTiles[str(tile)].Oil = true
	if(win_surr_cells):
		if(win_surr_cells.has(tile)):
			WalkableTiles[str(tile)].WinTile = true
	if(lever_surr_cells):
		if(lever_surr_cells.has(tile)):
			WalkableTiles[str(tile)].LeverTile = true

func addPoints(tile):
	point_id += 1
	WalkableTiles[str(tile)].ID = point_id
	astar.add_point(point_id, map_to_local(tile), 1)
	if(WalkableTiles[str(tile)].OnBarrier):
		astar.set_point_disabled(point_id)

func connectPoints():
	var arr = astar.get_point_ids()
	arr.sort()
	for point in arr:
		var point_pos = astar.get_point_position(point)
		for other in arr:
			var other_pos = astar.get_point_position(other)
			if(inRange(other_pos, point_pos, 50, 25) 
			&& other_pos != point_pos 
			&& !astar.is_point_disabled(point) 
			&& !astar.is_point_disabled(other)):
				astar.connect_points(point, other, true)
			if(other_pos != point_pos 
			&& astar.is_point_disabled(point) 
			|| astar.is_point_disabled(other)):
				astar.disconnect_points(point, other, true)
	get_node("../Visualizer").visible = false
	get_node("../Visualizer").visible = true

func inRange(pos_a, pos_b, n_x, n_y):
	if((pos_a.x >= (pos_b.x - n_x) && pos_a.x <= (pos_b.x + n_x)) && (pos_a.y >= (pos_b.y - n_y) && pos_a.y <= (pos_b.y + n_y))):
		return true
	else:
		return false

