extends Node

@export var snake_scene : PackedScene
var score :=0
var high_score := 0
var game_started : bool = false

#snake variables
var old_data : Array
var snake_data : Array
var snake : Array

#movement variable

var can_move : bool

#food variable
var food_pos : Vector2
var regen_food : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Grid.position = Vector2(GlobalVariable.left_margin,GlobalVariable.cell_size)
	new_game()
	
func new_game():
	get_tree().paused= false
	get_tree().call_group("snake_group","queue_free")
	
	score = 0
	$HUD/MessageLabel.text ="Move to Start !!"
	$HUD/ScoreLabel.text = str(score)
	GlobalVariable.move_direction =GlobalVariable.up
	can_move = true
	generate_snake()
	move_food()
	$GameOverMenu.hide()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	
	for i in range(3):
		add_segment(GlobalVariable.start_pos + Vector2(0,i))
		
func add_segment(pos):
	snake_data.append(pos)
	var snake_segment = snake_scene.instantiate()
	snake_segment.position = (pos * GlobalVariable.cell_size) + Vector2(GlobalVariable.left_margin,GlobalVariable.cell_size)
	add_child(snake_segment)
	snake.append(snake_segment)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_snake()
	
func move_snake():
	if can_move:
		if Input.is_action_just_pressed("move_up") and GlobalVariable.move_direction != GlobalVariable.down:
			GlobalVariable.move_direction = GlobalVariable.up
			can_move = false
			$MoveSound.play()
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_down") and GlobalVariable.move_direction != GlobalVariable.up:
			GlobalVariable.move_direction = GlobalVariable.down
			can_move = false
			$MoveSound.play()
			if not game_started:
				start_game()

		if Input.is_action_just_pressed("move_right") and GlobalVariable.move_direction != GlobalVariable.left:
			GlobalVariable.move_direction = GlobalVariable.right
			can_move = false
			$MoveSound.play()
			if not game_started:
				start_game()

		if Input.is_action_just_pressed("move_left") and GlobalVariable.move_direction != GlobalVariable.right:
			GlobalVariable.move_direction = GlobalVariable.left
			can_move = false
			$MoveSound.play()
			if not game_started:
				start_game()

func start_game():
	game_started = true
	$MoveTimer.start()
	$HUD/MessageLabel.text = "Snake Game"
	$HUD/ScoreLabel.text = str(score)

func _on_move_timer_timeout() -> void:
	can_move = true
	
	old_data = [] + snake_data
	snake_data[0] += GlobalVariable.move_direction
	
	if is_out_of_bounds(snake_data[0]) or is_self_collision():
		end_game()
		return
	
	for i in range(len(snake_data)):
		if i > 0 :
			snake_data[i] = old_data[i-1]
		snake[i].position = (snake_data[i] * GlobalVariable.cell_size) + Vector2(GlobalVariable.left_margin,GlobalVariable.cell_size)
	
	check_food_eaten()

func is_out_of_bounds(pos: Vector2) -> bool:
	return pos.x < 0 or pos.x > GlobalVariable.columns - 1 or pos.y < 0 or pos.y > GlobalVariable.rows - 1

func is_self_collision() -> bool:
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			return true
	return false
			
func check_food_eaten():
	if snake_data[0] == food_pos:
		score +=1 
		$FoodSound.play()
		$HUD/ScoreLabel.text = str(score)
		if score > high_score:
			high_score = score
		$HUD/HighScoreLabel.text = str(high_score)
		move_food()
		add_segment(old_data[-1])
	
func move_food():
	while regen_food:
		regen_food = false
		food_pos = Vector2(randi_range(0, GlobalVariable.columns - 1), randi_range(0, GlobalVariable.rows - 1))
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$Grid/Food.position = (food_pos * GlobalVariable.cell_size) 
	regen_food = true
	
func end_game():
	$GameOverMenu.show()
	$MoveTimer.stop()
	$GameOverMenu/DeathSound.play()
	$GameOverMenu/FinaScoreLabel.text = "You Scored: " + str(score)
	game_started = false
	get_tree().paused = true


func _on_game_over_menu_restart() -> void:
	new_game()
