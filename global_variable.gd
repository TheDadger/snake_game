extends Node2D

var screen_size : Vector2
var cell_size : int = 50

var rows : int
var columns : int
var left_margin : float

var start_pos : Vector2

var move_direction
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var right = Vector2(1, 0)
var left = Vector2(-1, 0)

func _ready() -> void:
	screen_size = get_viewport_rect().size
	rows = int(screen_size.y / cell_size) 
	columns = int(screen_size.x / cell_size)
	left_margin = screen_size.x - (columns * cell_size)
	left_margin *= 2	
	rows -=1
	columns -=1
	
	start_pos = Vector2(columns / 2, rows / 2)
