extends TextureProgressBar


func _ready(): # for debug purposes
	value = 498

func _physics_process(_delta: float):
	increment(Global.points)
	
	if Global.gigadrill:
		decrement()
		if value <= 0:
			Global.gigadrill = false
			
	if value >= 498 and !Global.gigadrill:
		Global.gigadrill = true
	

func increment(points):
	value += points
	
func decrement():
	value -= 1
