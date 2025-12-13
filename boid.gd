extends Node2D

const KNN = 5

var neighbours = []

@export var IS_DEAD = false

@export var SPEED = 100.0
@export var SEPARATION_FACTOR = 1.0
@export var ALIGNMENT_FACTOR = 25.0
@export var COHESION_FACTOR = 50.0

@onready var separation_area: Area2D = $SeparationArea
@onready var static_body_2d: StaticBody2D = %StaticBody2D
@onready var separation_circle: CollisionShape2D = $SeparationArea/SeparationCollision

func _process(delta):
	if IS_DEAD: return
	global_position += transform.x * SPEED * delta
	separation(delta)
	

func separation(delta):
	var sep_neighbours = get_separation_neighbours()
	if sep_neighbours:
		var dir_to_neighbours := Vector2.ZERO
		for n in sep_neighbours:
			dir_to_neighbours += n.global_position - global_position
		var sep_dir := dir_to_neighbours * -1.0
		var diff = abs(separation_circle.shape.radius - sep_dir.length())
		var angle = atan2(sep_dir.y, sep_dir.x)
		var eased_angle = rotate_toward(rotation, angle, delta * SEPARATION_FACTOR * atan(diff))
		rotation = eased_angle
	
func get_separation_neighbours():
	return separation_area.get_overlapping_bodies().filter(func(b): return b != static_body_2d)

func get_k_nearest(k: int):
	# TODO: Improve this to use a radius filter to minimize calculations
	var nearest = func(a: Node2D, b: Node2D):
		var a_diff = global_position - a.global_position
		var b_diff = global_position - b.global_position
		return a if a_diff < b_diff else b
	
	#var local_boids = BoidManager.boids
	#local_boids.sort_custom(nearest)
	#return local_boids.slice(0, k)

func calc_separation():
	pass
