extends "res://objects/Asteroid.gd"

func _ready():
	var main_camera= get_node("/root/Game/MainCamera")
	#quando i gioco è attivo invio il segnale explode alla main camera chiamando il metodo asteroid small exploded
	self.connect("explode", main_camera,  "asteroid_small_exploded")
	score_value=250

#override
func explode():
	if(!is_exploded):
		is_exploded=true
		
		_explosion_particles()
		explosionpitch=1.2
		_play_explosion_sounf()
		
		emit_signal("explode")
		emit_signal("score_changed", score_value)
		
		_spawn_score()
		
		get_parent().remove_child(self)
		queue_free()
		print("exploded")
