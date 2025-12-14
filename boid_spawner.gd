extends Node2D

@export var num_of_boids := 10
@export var boid_scene: PackedScene
@export var spawn_to: Node2D

@onready var spawn_area = $SpawnArea

var boids = []

func _ready():
	assert(boid_scene, "No boid scene attached")
	assert(spawn_to, "Node to spawn to not attached")
	var x = global_position.x
	var y = global_position.y
	var w = spawn_area.shape.size.x
	var h = spawn_area.shape.size.y
	
	for i in range(num_of_boids):
		var rand_x = randi_range(x, x + w)
		var rand_y = randi_range(y, y + h)
		
		var boid = boid_scene.instantiate()
		boids.append(boid)
		boid.global_position = Vector2(rand_x, rand_y)
		spawn_to.add_child.call_deferred(boid)

func update_boid_alignments(value: float):
	for boid in boids:
		boid.ALIGNMENT_FACTOR = value

func update_boid_separations(value: float):
	for boid in boids:
		boid.SEPARATION_FACTOR = value

func update_boid_visions(value: float):
	for boid in boids:
		boid.VISION_RADIUS = value
