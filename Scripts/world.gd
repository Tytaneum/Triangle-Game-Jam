extends Node2D

@export var groundGrid: TileMapLayer
@export var breakGrid: TileMapLayer
@export var waterGrid: TileMapLayer
@export var partialGrid: TileMapLayer
@export var wallsGrid: TileMapLayer

var collisions = {}
var grid = []
var world

#random
var rng = RandomNumberGenerator.new()

var max_width = 20
var max_depth = 180

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.FINAL_DEPTH = max_depth
	
	#shuffle random
	rng.randomize()
	
	# build the new world object
	world = World.new(breakGrid, groundGrid, waterGrid, partialGrid, wallsGrid, grid)
	
	#start by clearing the grids
	world.clear_grids()
	
	#get all the tiles row by row, then column by column
	for r in range(max_depth + 1):
		#generate the row of tiles
		var current_row = []
		for c in range(max_width + 1):
			current_row.append(Tile.new(world, Vector2(c,r), 0, 0, 20, false))
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
	for row in range(-10, grid.size()):
		if row >= 0:
			for tile in grid[row]:
				#set the water
				world.water_g.set_cell(Vector2i(tile.pos.x, tile.pos.y), 0, Vector2i(0,0))
				if floor(tile.pos.y / level) < 3:
					tile.change_texture(floor(tile.pos.y / level))
				else:
					#only for making sure it doesnt show bedrock
					tile.change_texture(2)
				#check for transition except for last 
				if int(tile.pos.y) % level > 25 and floor(tile.pos.y / level) < 2:
					#pick random from this to next for transition
					tile.change_texture(rng.randi_range(floor(tile.pos.y / level), floor(tile.pos.y / level) + 1))
		else:
			for column in range(grid[0].size()):
				world.water_g.set_cell(Vector2i(column, row), 0, Vector2i(0,0))
	#generate the stones#
	
	#pick a starting depth
	var stone_depth = 10 + rng.randi_range(5,10)
	#move through the map
	while stone_depth < max_depth:
		#pick a random rock in the row
		generate_rock(grid[stone_depth][rng.randi_range(0,grid[stone_depth].size()-1)])
		#move at least 10 levels down
		stone_depth += rng.randi_range(5,15)
	
	#generate the gems, more common but smaller
	
	#pick a starting depth
	var gem_depth = 15 + rng.randi_range(1, 5)
	#move through the map
	while gem_depth < max_depth:
		#pick a random tile in the row
		generate_gem_vein(grid[gem_depth][rng.randi_range(0,grid[gem_depth].size()-1)])
		#move at least 5 levels down
		gem_depth += rng.randi_range(7,12)
	
	#generate the damagin blocks, this will be a single block that explodes
	var trap_depth = 10 + rng.randi_range(1, 5)
	#move through the map
	while trap_depth < max_depth:
		grid[trap_depth][rng.randi_range(0, grid[trap_depth].size()-1)].set_special(3)
		trap_depth += rng.randi_range(1,7)
	
	#generate the barriers now that everything has been placed#
	#this involves changing each of the tiles in the outline to be bedrock with no special#
	
	#walls
	for i in range(-5, max_depth+20):
		var pos = i
		if pos < 0:
				pos = 0
		if pos > max_depth:
			pos = max_depth
			
		#left side
		for f in range(-50, 1):
			world.wall_g.set_cell(Vector2i(f, i), grid[pos][rng.randi_range(1,max_width-1)].texture, Vector2i(0,0))
		for f in range(max_width, 50):
			world.wall_g.set_cell(Vector2i(f, i), grid[pos][rng.randi_range(1,max_width-1)].texture, Vector2i(0,0))
		if i > max_depth:
			for f in range(1, max_width):
				world.wall_g.set_cell(Vector2i(f, i), grid[pos][rng.randi_range(1,max_width-1)].texture, Vector2i(0,0))

	#sides
	for i in range(-5, max_depth):
		if i >= 0:
			grid[i][0].unbreakable = true
			grid[i][0].set_special(0)
			grid[i][0].change_texture(3)
			
			grid[i][grid[i].size()-1].unbreakable = true
			grid[i][grid[i].size()-1].set_special(0)
			grid[i][grid[i].size()-1].change_texture(3)
		else:
			world.ground_g.set_cell(Vector2i(0, i), 3, Vector2i(0,0))
			world.ground_g.set_cell(Vector2i(grid[0].size()-1, i), 3, Vector2i(0,0))
	
	#bottom layer
	for i in range(0, max_width+1):
		#set teh block above it to be a gem
		grid[max_depth-1][i].set_special(2)
		
		grid[max_depth][i].set_special(0)
		grid[max_depth][i].change_texture(3)
		#not unbreakable, just very strong
		grid[max_depth][i].max_health = 1000
		grid[max_depth][i].health = 1000
	
	#make the initial depth 0 and will be updated after each break
	Global.current_depth = 0;

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

#function used to generate a gemstone vein
#starts at a center tile and branches out with a decreasing probability
func generate_gem_vein(tile : Tile):
	
	#get a starting probability
	var probability = 5
	#initialize the closed/open lists
	var to_be_gemmed = [tile]
	var gemmed = []
	
	#loop to expand the vein
	while to_be_gemmed.size() > 0:
		#get the current tile
		var current_tile = to_be_gemmed.pop_front()
		
		#up
		if current_tile.pos.y - 1 >= 0:
			#if its not already a gem and passes the probability
			if !gemmed.has(grid[current_tile.pos.y-1][current_tile.pos.x]) and rng.randi_range(0,10) <= probability:
				#add it to the queue
				to_be_gemmed.append(grid[current_tile.pos.y-1][current_tile.pos.x])
		#left
		if current_tile.pos.x - 1 >= 0:
			#if its not already a gem and passes the probability
			if !gemmed.has(grid[current_tile.pos.y][current_tile.pos.x-1]) and rng.randi_range(0,10) <= probability:
				#add it to the queue
				to_be_gemmed.append(grid[current_tile.pos.y][current_tile.pos.x-1])
		#right
		if current_tile.pos.x + 1 < grid[0].size():
			#if its not already a gem and passes the probability
			if !gemmed.has(grid[current_tile.pos.y][current_tile.pos.x+1]) and rng.randi_range(0,10) <= probability:
				#add it to the queue
				to_be_gemmed.append(grid[current_tile.pos.y][current_tile.pos.x+1])
		#down
		if current_tile.pos.y + 1 < grid.size():
			#if its not already a gem and passes the probability
			if !gemmed.has(grid[current_tile.pos.y+1][current_tile.pos.x]) and rng.randi_range(0,10) <= probability:
				#add it to the queue
				to_be_gemmed.append(grid[current_tile.pos.y+1][current_tile.pos.x])
		
		#add it to the gemmed list, and gemify it
		gemmed.append(current_tile)
		current_tile.set_special(2)
		
		#shrink the probability for the next tile
		probability -= 1

# class for each individual tile
class Tile:
	var world #the parent grid
	var pos #position in the tileset
	var texture #texture used on the tileset
	var special # 0 if normal, 1 if gem, 2 for rock, 3 for explode
	var max_health # max amount of health, used for animation
	var health # amount of health
	var broken # if its broken or not
	var unbreakable
	
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
		
		#if the value is 4 it is bedrock and unbreakable
		if special == 4:
			unbreakable = true
	
	func dig():
		#fixes a bug where damaged blocks still show after exploding
		if !broken and !unbreakable:
			if 5 - (health / (max_health / 4)) < 5:
				change_break_texture(5 - (health / (max_health / 4)))
			else:
				change_break_texture(4)
			if Global.gigadrill:
				health -= 1
			if Global.cutscene:
				health -= 5000
			health -= 1
			if health <= 0:
				break_tile()
	
	func break_tile():
		world.ground_g.erase_cell(pos)
		world.break_g.erase_cell(pos)
		world.partial_g.erase_cell(pos)
		
		#breaking sounds
		if texture == 0:
			world.ground_g.get_child(0).playSFX("groundBreak_1.wav")
		elif texture == 1:
			world.ground_g.get_child(0).playSFX("groundBreak_2.wav")
		elif texture == 2:
			world.ground_g.get_child(0).playSFX("groundBreak_3.wav")
		else:
			world.ground_g.get_child(0).playSFX("groundBreak_3.wav")
		
		if special == 3:
			#Global.TIME -= 10
			explode(2)
		elif special == 2:
			world.ground_g.get_child(0).playSFX("gemCollect.wav")
			Global.gem_meter += 50
		#update the depth if necessary
		if pos.y > Global.current_depth:
			Global.current_depth = int(pos.y)
		
		broken = true
	
	func change_break_texture(break_level):
		world.break_g.set_cell(Vector2i(pos.x, pos.y), 0, Vector2i(break_level,0))
	
	#changes based on the type of block and the special case
	func change_texture(text):
		texture = text
		world.ground_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(special,0))
		world.partial_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(0,0))
		
		#update the health based on the texture.
		max_health = max_health + 10*text
		health = max_health
	
	func set_special(spec):
		special = spec
		if spec == 1:
			max_health = max_health * 2
			health = health * 2
		world.ground_g.set_cell(Vector2i(pos.x, pos.y), texture, Vector2i(special,0))
	
	#function that breaks the tiles around this tile in circular layers
	func explode(layers):
		#makes it so its not infinite
		set_special(0)
		#do the area around the block in layers
		for r in range(-layers, layers):
			for c in range(-layers, layers):
				#make sure the tile exists
				if pos.x + c >= 0 and pos.x + c < world.g[0].size() and pos.y + r >= 0 and pos.y + r < world.g.size():
					if !world.g[pos.y + r][pos.x + c].unbreakable:
						world.g[pos.y + r][pos.x + c].break_tile()
		pass

class World:
	var break_g # the grid that has the breaking animation
	var ground_g # the grid that has the main ground
	var water_g #the grid for water warble
	var partial_g # the grid that contains the partial ground texture
	var wall_g #the walls on the side
	var g # the 2d array of tiles
	
	func _init(b, g, w, p, wall, grid):
		break_g = b
		ground_g = g
		water_g = w
		partial_g = p
		wall_g = wall
		g = grid
	
	# clears all 3 grids
	func clear_grids():
		break_g.clear()
		ground_g.clear()
		water_g.clear()
		wall_g.clear()
		partial_g.clear()
	
	#used to set an updated grid
	func set_grid(grid):
		g = grid
