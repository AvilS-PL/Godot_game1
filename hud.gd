extends CanvasLayer
signal start_game

var temp_score = 0
var scorer = false

func _ready():
	pass

func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout

	$Message.text = "Bruh Game"
	$Message.show()
	temp_score = 0
	update_score(temp_score)
	$ScoreUp.position.x = 264
	$ScoreDown.position.x = 264
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$ScoreDown.show()
	$ScoreUp.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	var fixed_position_multiplayer = 0
	var checking_value = score
	while true:
		checking_value = floor(checking_value/10)
		if checking_value > 0:
			fixed_position_multiplayer += 1
		else:
			break
	$ScoreUp.position.x = 264 + 25*fixed_position_multiplayer
	$ScoreDown.position.x = 264 + 25*fixed_position_multiplayer


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	$ScoreDown.hide()
	$ScoreUp.hide()
	start_game.emit(temp_score)


func _on_score_up_button_down():
	scorer = true
	while scorer:
		temp_score += 1
		if temp_score > 99: temp_score = 0
		if temp_score < 0: temp_score = 99
		update_score(temp_score)
		await get_tree().create_timer(0.1).timeout


func _on_score_up_button_up():
	scorer = false


func _on_score_down_button_down():
	scorer = true
	while scorer:
		temp_score -= 1
		if temp_score > 99: temp_score = 0
		if temp_score < 0: temp_score = 99
		update_score(temp_score)
		await get_tree().create_timer(0.1).timeout


func _on_score_down_button_up():
	scorer = false
