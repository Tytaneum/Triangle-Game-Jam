extends TileMapLayer

@export var worldGrid: TileMapLayer

var collisions = {}
var grid = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_used_cells():
		#print(str(i.x) + "," + str(i.y))
		pass
	
	#get the bounding box of the grid
	var grid_shape = get_used_rect()
	
	var x_min = grid_shape.position.x
	var x_max = grid_shape.end.x
	var y_min = grid_shape.position.y
	var y_max = grid_shape.end.y
	
	#get all the tiles row by row, then column by column
	for r in range(y_max + 1):
		#generate the row of tiles
		var current_row = []
		for c in range(x_max + 1):
			current_row.append(Tile.new(worldGrid, Vector2(c,r), randi_range(0,2), 0, 25, false))
		#add it to the global grid
		grid.append(current_row)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# class for each individual tile
class Tile:
	var grid_parent #the parent grid
	var pos #position in the tileset
	var texture #texture used on the tileset
	var special # 0 if normal, 1 if gem, -1 if harming
	var max_health # max amount of health, used for animation
	var health # amount of health
	var broken # if its broken or not
	var digging
	
	func _init(g, p, t, s, h, b):
		grid_parent = g
		pos = p
		texture = t
		special = s
		health = h
		max_health = h
		broken = b
		
		#set the first value for texture
		change_texture(0)
	
	func dig():
		change_texture(5 - (health / (max_health / 4)))
		health -= 1
		if health <= 0:
			break_tile()
	
	func break_tile():
		grid_parent.erase_cell(pos)
		broken = true
	
	func change_texture(break_level):
		grid_parent.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(break_level,0))
