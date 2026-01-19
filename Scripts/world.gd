extends Node2D

@export var groundGrid: TileMapLayer
@export var breakGrid: TileMapLayer
@export var partialGrid: TileMapLayer

var collisions = {}
var grid = []

#random
var rng = RandomNumberGenerator.new()

var max_width = 10
var max_depth = 107

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#shuffle random
	rng.randomize()
	
	# build the new world object
	var world = World.new(breakGrid, groundGrid, partialGrid)
	
	#start by clearing the grids
	world.clear_grids()
	
	#get all the tiles row by row, then column by column
	for r in range(max_depth + 1):
		#generate the row of tiles
		var current_row = []
		for c in range(max_width + 1):
			current_row.append(Tile.new(world, Vector2(c,r), 0, 0, 25, false))
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
	var world #the parent grid
	var pos #position in the tileset
	var texture #texture used on the tileset
	var special # 0 if normal, 1 if gem, -1 if harming
	var max_health # max amount of health, used for animation
	var health # amount of health
	var broken # if its broken or not
	var digging
	
	func _init(g, p, t, s, h, b):
		world = g
		pos = p
		texture = t
		special = s
		health = h
		max_health = h
		broken = b
		
		#set the first value for texture
		change_break_texture(0)
	
	func dig():
		if 5 - (health / (max_health / 4)) < 5:
			change_break_texture(5 - (health / (max_health / 4)))
		else:
			change_break_texture(4)
		health -= 1
		if health <= 0:
			break_tile()
	
	func break_tile():
		world.ground_g.erase_cell(pos)
		world.break_g.erase_cell(pos)
		world.partial_g.erase_cell(pos)
		broken = true
	
	func change_break_texture(break_level):
		world.break_g.set_cell(Vector2i(pos.x, pos.y), 0, Vector2i(break_level,0))
	
	#changes based on the type of block and the special case
	func change_texture(text):
		texture = text
		world.ground_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(special,0))
		world.partial_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(0,0))

class World:
	var break_g # the grid that has the breaking animation
	var ground_g # the grid that has the main ground
	var partial_g # the grid that contains the partial ground texture
	
	func _init(b, g, p):
		break_g = b
		ground_g = g
		partial_g = p
	
	# clears all 3 grids
	func clear_grids():
		break_g.clear()
		ground_g.clear()
		partial_g.clear()
