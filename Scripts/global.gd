extends Node

var gigadrill = false
var cutscene = false # Should've really done this earlier, will make the player crazy overpowered during gigadrill cutscene among other things
var camera_zoom = 2
var current_depth
var gem_meter = 0
var points = 0
var TIME = 133 # seconds
var FINAL_DEPTH = 107

signal lose #tells the player to play the death animation
signal restart #tells restart button to enable
