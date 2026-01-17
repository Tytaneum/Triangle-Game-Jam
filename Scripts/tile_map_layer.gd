extends TileMapLayer

var collisions = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_used_cells():
		print(str(i.x) + "," + str(i.y))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# class for each individual tile
class Tile:
	var position #position in the tileset
	var texture #texture used on the tileset
	var special # 0 if normal, 1 if gem, -1 if harming
	var health # amount of health
	var broken # if its broken or not
