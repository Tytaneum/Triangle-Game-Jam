extends TileMapLayer

@export var worldGrid: TileMapLayer

var collisions = {}
var grid = []

#random
var rng = RandomNumberGenerator.new()

var max_width = 10
var max_depth = 90

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#shuffle random
	rng.randomize()
	
	#start by clearing the grid
	clear()
	
	#get all the tiles row by row, then column by column
	for r in range(max_depth + 1):
		#generate the row of tiles
		var current_row = []
		for c in range(max_width + 1):
			current_row.append(Tile.new(worldGrid, Vector2(c,r), 0, 0, 25, false))
		#add it to the global grid
		grid.append(current_row)
	
	#generate the level now that its been built
	generate_level()

func generate_level():
	
	#get the value to change level into thirds
	var level = max_depth / 3
	
	#go through each tile in the grid
	for row in range(grid.size()):
		for tile in grid[row]:
			tile.change_texture(floor(tile.pos.y / level))
			#check for transition except for last 
			if int(tile.pos.y) % level > 25 and tile.pos.y / level < 2:
				#pick random from this to next for transition
				tile.change_texture(rng.randi_range(floor(tile.pos.y / level), floor(tile.pos.y / level) + 1))
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
		change_break_texture(0)
	
	func dig():
		change_break_texture(5 - (health / (max_health / 4)))
		health -= 1
		if health <= 0:
			break_tile()
	
	func break_tile():
		grid_parent.erase_cell(pos)
		broken = true
	
	func change_break_texture(break_level):
		grid_parent.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(break_level,0))
	
	func change_texture(text):
		texture = text
		grid_parent.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(0,0))
