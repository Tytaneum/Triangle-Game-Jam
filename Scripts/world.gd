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
	var world = World.new(breakGrid, groundGrid, partialGrid, grid)
	
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
	
	#update the grid
	world.set_grid(grid)
	
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
	
	#generate the stones
	
	print(grid.size())
	
	#pick a starting depth
	var stone_depth = 10 + rng.randi_range(5,10)
	#move through the map
	while stone_depth < max_depth:
		#pick a random rock in the row
		generate_rock(grid[stone_depth][rng.randi_range(0,grid[stone_depth].size()-1)])
		#move at least 10 levels down
		stone_depth += rng.randi_range(10,20)
	pass

#function used to generate a rock from a single tile
#start by generating a rectangle of tiles, then chip at the corners to keep it rounded
#idea is you only have to go two directions per cycle instead of one
func generate_rock(tile : Tile):
	#initialize the rock array
	var rock = []
	
	#generate the size of the square and fill out the initial array with it
	var rock_size = rng.randi_range(5,9)
	#always make sure its odd though
	if rock_size % 2 != 1:
		rock_size += 1
	
	#fill out the initial array with it
	for i in range(rock_size):
		var rock_row = []
		for j in range(rock_size):
			rock_row.append(1)
		rock.append(rock_row)
	
	#chip away at it#
	
	#grab each of the 4 corners
	var rock_corners = [Vector2i(0,0), Vector2i(0,rock_size-1), Vector2i(rock_size-1,0), Vector2i(rock_size-1,rock_size-1)]
	
	#while there is an unfinished corner
	while rock_corners.size() > 0:
		#grab the corner, need seperate for math later 
		var current_corner = rock_corners.pop_front()
		#initialize the queue
		var chip_queue = [current_corner]
		var chipped_queue = []
		#reset the percent chance
		var percent_remove = 8
		#reset until empty
		while chip_queue.size() > 0:
			#remove first value from queue
			var current_tile = chip_queue.pop_front()
			#chip that corner away
			rock[current_tile.y][current_tile.x] = 0
			
			#HORIZONTAL#
			
			#do the rng chance
			if rng.randi_range(0,10) <= percent_remove:
				#if / else for considering the tile
				if current_corner.x == 0:
					#make sure its in bounds
					if current_tile.x + 1 <= rock_size-1:
						#make sure its not already gone
						if rock[current_tile.x + 1][current_tile.y] != 0:
							#Add the tile
							chip_queue.append(Vector2i(current_tile.x + 1, current_tile.y))
				else:
					#make sure its within bounds
					if current_tile.x - 1 >= 0:
						#make sure its not already gone
						if rock[current_tile.x - 1][current_tile.y] != 0:
							#add the tile
							chip_queue.append(Vector2i(current_tile.x - 1, current_tile.y))
			
			#VERTICAL#
			
			#do the rng chance
			if rng.randi_range(0,10) <= percent_remove:
				#if / else for considering the tile
				if current_corner.y == 0:
					#make sure its in bounds
					if current_tile.y + 1 <= rock_size-1:
						#make sure its not already gone
						if rock[current_tile.x][current_tile.y + 1] != 0:
							#Add the tile
							chip_queue.append(Vector2i(current_tile.x, current_tile.y + 1))
				else:
					#make sure its within bounds
					if current_tile.y - 1 >= 0:
						#make sure its not already gone
						if rock[current_tile.x][current_tile.y - 1] != 0:
							#add the tile
							chip_queue.append(Vector2i(current_tile.x, current_tile.y - 1))
			
			#shrink the chance
			percent_remove -= 1
			
			#add it to the finished queue
			chipped_queue.append(current_tile)
	
	#actually translate to tiles#
	#set up the for loops to place the tile in the middle of the rock
	for r in range(-rock_size/2,(rock_size/2)+1):
		for c in range(-rock_size/2,(rock_size/2)+1):
			#find out if the tile is within the grid
			if tile.pos.x + c > 0 and tile.pos.x + c < grid[0].size() and tile.pos.y + r < grid.size() and tile.pos.y + r > 0 and rock[r + rock_size/2][c + rock_size/2] == 1:
				grid[tile.pos.y + r][tile.pos.x + c].set_special(1)

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
	
	func set_special(spec):
		special = spec
		if spec == 1:
			max_health = max_health * 2
			health = health * 2
		world.ground_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(special,0))

class World:
	var break_g # the grid that has the breaking animation
	var ground_g # the grid that has the main ground
	var partial_g # the grid that contains the partial ground texture
	var g # the 2d array of tiles
	
	func _init(b, g, p, grid):
		break_g = b
		ground_g = g
		partial_g = p
		g = grid
	
	# clears all 3 grids
	func clear_grids():
		break_g.clear()
		ground_g.clear()
		partial_g.clear()
	
	#used to set an updated grid
	func set_grid(grid):
		g = grid
