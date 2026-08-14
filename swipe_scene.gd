extends Node2D

var initial_pos := Vector2.ZERO
var final_pos := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			initial_pos = event.position
		else:
			final_pos = event.position
			check_swipe()
			
func check_swipe():
	var movement_vector = final_pos - initial_pos
	var swipe_length = movement_vector.length()
	var swipe_direction = movement_vector.normalized()
	
	if swipe_length < 40:
		return
	
	if swipe_direction.x > 0.7 and GlobalVariable.move_direction != GlobalVariable.left :
		GlobalVariable.move_direction = GlobalVariable.right
		$MoveSound.play()
		get_parent().can_move = false
		if not get_parent().game_started:
			get_parent().start_game()
			
	if swipe_direction.x < -0.7 and GlobalVariable.move_direction != GlobalVariable.right:
		GlobalVariable.move_direction = GlobalVariable.left
		$MoveSound.play()
		get_parent().can_move = false
		if not get_parent().game_started:
			get_parent().start_game()
			
	if swipe_direction.y > 0.7 and GlobalVariable.move_direction != GlobalVariable.up:
		GlobalVariable.move_direction = GlobalVariable.down
		$MoveSound.play()
		get_parent().can_move = false
		if not get_parent().game_started:
			get_parent().start_game()
			
	if swipe_direction.y < -0.7 and GlobalVariable.move_direction != GlobalVariable.down:
		GlobalVariable.move_direction = GlobalVariable.up 
		$MoveSound.play()
		get_parent().can_move = false
		if not get_parent().game_started:
			get_parent().start_game()
