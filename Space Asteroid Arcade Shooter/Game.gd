extends Node2D

var player_scene = load("res://characters/Player.tscn")

var is_game_over = false

func _ready() -> void:
	connect("resized", self, "call_wrap_around")

func call_wrap_around():
	get_tree().call_group("wrap_around", "recalculate_wrap_area")

#Game Over
func _on_Player_player_died():
	#stop gameplay music and load game over music
	$MusicPlayer.stop()
	$MusicPlayer.stream= load("res://assets/audio/music/sawsquarenoise_-_06_-_Towel_Defence_Jingle_Loose.ogg")
	$MusicPlayer.stream.loop = false
	$MusicPlayer.volume_db = -5
	
	#asteroid stop spawning
	$AsteroidSpawner/SpawnTimer.stop()
	
	# turn off roaring sound
	for a in get_tree().get_nodes_in_group("asteroids"):
		if(!a.is_queued_for_deletion()):
			a.get_node("AudioStreamPlayer2D").stop()
	
	$GameOverTimer.start()
	$RestartTimer.start()

func _on_GameOverTimer_timeout():
	#play gameover music and show gameover label
	$MusicPlayer.play(0)
	$GameOverLabel.visible = true


func _on_RestartTimer_timeout():
	$GameOverLabel/RestartLabel.visible=true
	is_game_over=true

func _unhandled_input(event):
	if(is_game_over and event.is_action_released("restart_game")):
		_restart_game()

func _restart_game():
	_undo_game_over()
	_respawn_player()
	$AsteroidSpawner.restart()
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.reset()
	is_game_over = false

func _undo_game_over():
	$GameOverLabel.visible=false
	$GameOverLabel/RestartLabel.visible=false
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_03_-_Towel_Defence_Ingame.ogg")
	$MusicPlayer.stream.loop = true
	$MusicPlayer.volume_db = -10
	$MusicPlayer.play(0)
	
func _respawn_player():
	var player = player_scene.instance()
	player.position=Vector2(626, 680)
	add_child(player)#devo riconettere i segnali
	
