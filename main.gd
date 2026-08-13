extends Node

@export var snake_scene : PackedScene
var score :int
var game_started : bool = false

#cell variable
var cell : int = 20 
var cell_size : int = 50 

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variable
var start_pos = Vector2(9,9)
var up = Vector2(0,-1)
var down = Vector2(0,1)
var right = Vector2(1,0)
var left = Vector2(-1,0)
var can_move : bool
var move_direction

#food variable
var food_pos : Vector2
var regen_food : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	
func new_game():
	get_tree().paused= false
	get_tree().call_group("snake_group","queue_free")
	score = 0 
	$HUD/ScoreLabel.text = "Score:" + str(score)
	move_direction =up
	can_move = true
	generate_snake()
	move_food()
	$GameOverMenu.hide()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	
	for i in range(3):
		add_segment(start_pos + Vector2(0,i))
		
func add_segment(pos):
	snake_data.append(pos)
	var snake_segment = snake_scene.instantiate()
	snake_segment.position = (pos * cell_size) + Vector2(0, cell_size)
	add_child(snake_segment)
	snake.append(snake_segment)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_snake()
	
func move_snake():
	if can_move:
		if Input.is_action_just_pressed("move_up") and move_direction != down:
			move_direction = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_down") and move_direction != up:
			move_direction = down
			can_move = false
			if not game_started:
				start_game()

		if Input.is_action_just_pressed("move_right") and move_direction != left:
			move_direction = right
			can_move = false
			if not game_started:
				start_game()

		if Input.is_action_just_pressed("move_left") and move_direction != right:
			move_direction = left
			can_move = false
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$MoveTimer.start()

func _on_move_timer_timeout() -> void:
	can_move = true
	
	old_data = [] + snake_data
	snake_data[0] += move_direction
	
	for i in range(len(snake_data)):
		if i > 0 :
			snake_data[i] = old_data[i-1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0,cell_size)
	
	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	
func check_out_of_bounds():
	if snake_data[0].x < 0  or snake_data[0]. x > cell - 1 or snake_data[0].y < 0 or snake_data[0].y > cell - 1:
		end_game()

func check_self_eaten():
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		score +=1 
		$HUD/ScoreLabel.text = "Score: " + str(score)
		move_food()
		add_segment(old_data[-1])
	
func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, cell - 1), randi_range(0, cell-1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Food.position = (food_pos * cell_size) + Vector2(0,cell_size)
	regen_food = true
	
func end_game():
	$GameOverMenu.show()
	$MoveTimer.stop()
	game_started = false
	get_tree().paused = true


func _on_game_over_menu_restart() -> void:
	new_game()
