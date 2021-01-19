extends RigidBody2D

signal explode

var explosion_particles_scene = load("res://objects/ParticlesAsteroidExplosion.tscn")
var asteroid_small_scene = load("res://objects/AsteroidSmol.tscn")
var rng = RandomNumberGenerator.new()
var explosionpitch=1


var is_exploded=false

signal score_changed
var score_value = 100
var points_scored_scene = load("res://ui/PointsScored.tscn")

func _ready():
	var main_camera= get_node("/root/Game/MainCamera")
	#quando i gioco è attivo invio il segnale explode alla main camera chiamando il metodo asteroid exploded
	self.connect("explode", main_camera,  "asteroid_exploded")
	var label = get_parent().get_node("/root/Game/GUI/MarginContainer/HBoxContainer/VBoxContainer/Score")
	self.connect("score_changed", label , "update_score")

func explode():
	if(!is_exploded):
		is_exploded=true
		
		_explosion_particles()
		_play_explosion_sounf()
		
		emit_signal("explode")
		emit_signal("score_changed", score_value)
		_spawn_score()
		
		_spawn_asteroid_smalls(4)
		get_parent().remove_child(self)
		queue_free()
		print("exploded")

func _spawn_score():
	var pointscor= points_scored_scene.instance()
	pointscor.get_node("Label").text= str(score_value)
	pointscor.position= self.position
	
	get_parent().add_child(pointscor)
	

func _play_explosion_sounf():
	var explosion_sound = AudioStreamPlayer2D.new()
	explosion_sound.stream=load("res://assets/audio/sfx/AsteroidExplosion.wav")
	explosion_sound.pitch_scale=explosionpitch
	explosion_sound.position= self.position
	get_parent().add_child(explosion_sound)
	explosion_sound.play(0)



func _explosion_particles():
	var explosion_particles = explosion_particles_scene.instance()
	explosion_particles.position = self.position
	get_parent().add_child(explosion_particles)
	explosion_particles.emitting =true

func _spawn_asteroid_smalls(num: int):
	for i in range(num):
		_spawn_asteroid_small()
		
func _spawn_asteroid_small(): # con _ iniziale vengono viste come metodi privati
	var asteroid_small = asteroid_small_scene.instance()
	asteroid_small.position=self.position #prende la posizione dell'asteroide grande
	_randomize_trajectory(asteroid_small)
	get_parent().add_child(asteroid_small)

func _randomize_trajectory(asteroid):
	 #random spin
	asteroid.angular_velocity = rand_range(-4,4)
	asteroid.linear_damp = 0
	#sceglie tra -1 0 1
	rng.randomize()
	var lv_x= rng.randi_range(-1 ,1)
	var lv_y= rng.randi_range(-1 ,1)
	
	asteroid.linear_velocity = Vector2(400*lv_x, 400*lv_y)
	asteroid.linear_damp=0

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
