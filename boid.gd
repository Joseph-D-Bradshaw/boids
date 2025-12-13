extends CharacterBody2D

const EPS = 0.001

var neighbours = []

@export var IS_DEAD = false

@export var MIN_SPEED = 20.0
@export var MAX_SPEED = 200.0
@export var SPEED = 60.0
@export_range(100.0, 1000.0, 10.0) var SEPARATION_FACTOR = 500.0
@export var ALIGNMENT_FACTOR = 25.0
@export var COHESION_FACTOR = 50.0

@onready var separation_area: Area2D = $SeparationArea
@onready var separation_circle: CollisionShape2D = $SeparationArea/SeparationCollision
@onready var line_2d = $Line2D
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
	move_and_slide()

	polygon_2d.look_at(global_position + velocity * 2)

func get_separation():
	var sep_neighbours = get_separation_neighbours()
	
	if sep_neighbours:
		var separation := Vector2.ZERO

		for n in sep_neighbours:
			var direction = (global_position - n.global_position)
			var distance = direction.length()
			var normalized_dir = direction / distance
			var weight = 1 / (distance + EPS)
			separation += normalized_dir * weight
		
		line_2d.points[0] = Vector2(0, 0)
		line_2d.points[1] = separation

		velocity += separation * SEPARATION_FACTOR

func get_separation_neighbours():
	return separation_area.get_overlapping_bodies().filter(func(b): return b != self)
