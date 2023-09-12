extends TileMap

var tile
var WalkableTiles = {}
var SelectedTiles = []
var SelectedTile
@onready var Char: CharacterBody2D = get_node("../Snail")

var astar
var point_id = 0
var path_to_selected = []
var direction
var next_location
var last_location

var speed = 200

func _ready():
	astar = AStar2D.new()
	setGrid()
	get_node("../Visualizer").visualize(astar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tile = local_to_map(get_global_mouse_position())
	
	for t in get_used_cells(0):
		if WalkableTiles[str(t)].Hovered == true && WalkableTiles[str(t)].Selected != true:
			erase_cell(0, Vector2(t.x, t.y))
			WalkableTiles[str(t)].Hovered = false
	
	if WalkableTiles.has(str(tile)) && WalkableTiles[str(tile)].Selected != true:

		set_cell(0, Vector2(tile.x, tile.y), 2, Vector2i(1,4), 0)
		WalkableTiles[str(tile)].Hovered = true
		
		if Input.is_action_just_pressed("E"):
			print(WalkableTiles[str(tile)])
			
		if Input.is_action_just_pressed("leftClick"):
			erase_cell(0, Vector2(tile.x, tile.y))
			set_cell(0, Vector2(tile.x, tile.y), 2, Vector2i(2,4), 0)
			WalkableTiles[str(tile)].Selected = true
			SelectedTiles.push_front(tile)
			SelectedTile = map_to_local(tile)
			
	if SelectedTiles.size() > 1:
		WalkableTiles[str(SelectedTiles.back())].Selected = false
		SelectedTiles.pop_back()
	
	if SelectedTiles.size() >= 1:
		path_to_selected = astar.get_point_path(
			astar.get_closest_point(Char.position), 
			astar.get_closest_point(SelectedTile)
			)

func _physics_process(delta):
	if (path_to_selected.size() > 1):
		next_location = path_to_selected[1]
		direction = Char.global_position.direction_to(next_location)
	elif (path_to_selected.size() == 1):
		next_location = path_to_selected[0]
		direction = Char.global_position.direction_to(next_location)
	if(direction):
		Char.global_position += direction * delta * speed
	if(SelectedTile):
		if(Char.position >= SelectedTile - Vector2(2,2) && Char.position <= SelectedTile + Vector2(2,2)):
			path_to_selected = []
			direction = null
			SelectedTile = null
			WalkableTiles[str(SelectedTiles.back())].Selected = false
			SelectedTiles.pop_back()
	

func setGrid():
	for tile in get_used_cells(2):
		point_id += 1
		astar.add_point(point_id, map_to_local(Vector2(tile.x, tile.y)), 1)
		WalkableTiles[str(Vector2(tile.x, tile.y))] = {
			"Hovered": false,
			"Selected": false,
			"Slimed": false
		}
	connectPoints()
	
func connectPoints():
	var arr = astar.get_point_ids()
	arr.sort()
	for point in arr:
		var point_pos = astar.get_point_position(point)
		for other in arr:
			var other_pos = astar.get_point_position(other)
			var range = point_pos.x
			if(inRange(other_pos, point_pos)):
				astar.connect_points(point, other, true)
		print(str(point) + ' ' + str(astar.get_point_position(point)))

func inRange(pos_a, pos_b):
	if((pos_a.x >= (pos_b.x - 50) && pos_a.x <= (pos_b.x + 50)) && (pos_a.y >= (pos_b.y - 25) && pos_a.y <= (pos_b.y + 25))):
		return true
	else:
		return false
	
