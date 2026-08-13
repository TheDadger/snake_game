extends TileMapLayer

func _ready() -> void:
	generate_board()
	
func generate_board():
	for y in range(GlobalVariable.rows):
		for x in range(GlobalVariable.columns):
			var tile_id = 0 
			
			if (x+y) % 2 == 1:
				tile_id = 1
			set_cell(Vector2i(x,y), 0, Vector2i(tile_id,0))
