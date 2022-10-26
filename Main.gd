extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()
	
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over():
	$DeathSound.play()
	$Music.stop()
	$ScoreTimer.stop()
	$MobTImer.stop()
	$HUD.show_game_over()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTImer.start()
	$ScoreTimer.start()

func _on_MobTImer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI/2
	
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0,250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
