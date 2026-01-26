extends AudioStreamPlayer

func playSFX(audio):
	stream = load("res://Sounds/SFX/" + audio)
	play()
