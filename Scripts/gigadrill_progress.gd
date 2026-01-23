extends TextureProgressBar


func _ready(): # for debug purposes
	Global.gem_meter = 498

func _physics_process(_delta: float):
	value = Global.gem_meter
	increment(Global.points)
	
	if Global.gigadrill:
		decrement()
		if Global.gem_meter <= 0:
			Global.gigadrill = false
			
	if Global.gem_meter >= 498 and !Global.gigadrill:
		Global.gem_meter = 498
		Global.gigadrill = true
	

func increment(points):
	Global.gem_meter += points
	
func decrement():
	Global.gem_meter -= 1
