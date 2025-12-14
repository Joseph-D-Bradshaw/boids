extends CharacterBody2D

const KNN = 3
const EPS = 0.001

@export var IS_DEAD = false

@export var MIN_SPEED = 20.0
@export var MAX_SPEED = 200.0
@export var SPEED = 60.0
@export_range(100.0, 1000.0, 10.0) var SEPARATION_FACTOR = 500.0
@export var ALIGNMENT_FACTOR = 100.0
@export var COHESION_FACTOR = 50.0
@export var VISION_RADIUS = 350.0:
	set(value):
		vision_collision.shape.radius = value

@onready var vision_area: Area2D = $VisionArea
@onready var vision_collision = $VisionArea/VisionCollision
@onready var polygon_2d = $Polygon2D

func _ready():
	velocity = Vector2(randf() - 0.5, randf() - 0.5) * MAX_SPEED

func _process(_delta):
	if IS_DEAD: return
	velocity *= SPEED

	if velocity.length() < MIN_SPEED:
		velocity = velocity.normalized() * MIN_SPEED
	elif velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED

	get_separation()
	get_alignment()
	move_and_slide()

	polygon_2d.look_at(global_position + velocity * 2)

func get_separation():
	var sep_neighbours = get_k_nearest(KNN)
	
	if sep_neighbours:
		var separation := Vector2.ZERO

		for n in sep_neighbours:
			var direction = (global_position - n.global_position)
			var distance = direction.length()
			var normalized_dir = direction / distance
			var weight = 1 / (distance + EPS)
			separation += normalized_dir * weight

		velocity += separation * SEPARATION_FACTOR

func get_alignment():
	var align_neighbours = get_k_nearest(KNN)
	
	if align_neighbours:
		var alignment := Vector2.ZERO
		
		for n in align_neighbours:
			var dir = (n.global_position - global_position).normalized()
			var weight = 1 / ((n.global_position - global_position).length() + EPS)

			alignment += dir * weight
		
		velocity += alignment * ALIGNMENT_FACTOR
			

func get_visible_neighbours():
	return vision_area.get_overlapping_bodies().filter(func(b): return b != self)

func get_k_nearest(k: int) -> Array[Node2D]:
	var neighbours = get_visible_neighbours()
	
	neighbours.sort_custom(nearest)
	return neighbours.slice(0, k)

func nearest(a: Node2D, b: Node2D):
	var a_diff = global_position - a.global_position
	var b_diff = global_position - b.global_position
	return a if a_diff <= b_diff else b
