extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	#new_game()
	pass

func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$GameSound.stop()
	$LooseSound.play()
	$HUD.show_game_over()

func new_game(temp_score):
	score = temp_score
	var time = 0.5 - temp_score * 0.005
	if time < 0.005: time = 0.005
	$MobTimer.wait_time = time
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$GameSound.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	if $MobTimer.wait_time > 0.005:
		$MobTimer.wait_time -= 0.005
	print($MobTimer.wait_time)
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
