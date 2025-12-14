class_name Main extends Node2D

@onready var boundary_top = $BoundaryTop
@onready var boundary_bottom = $BoundaryBottom
@onready var boundary_left = $BoundaryLeft
@onready var boundary_right = $BoundaryRight
@onready var boid_spawner = $BoidSpawner
@onready var alignment_slider = $UI/AlignmentSlider
@onready var alignment_value = $UI/AlignmentValue
@onready var separation_slider = $UI/SeparationSlider
@onready var separation_value = $UI/SeparationValue
@onready var vision_slider = $UI/VisionSlider
@onready var vision_value = $UI/VisionValue



func _ready():
	boundary_top.body_entered.connect(func(body: Node2D):
		body.velocity.y *= -1.0
	)
	boundary_bottom.body_entered.connect(func(body: Node2D):
		body.velocity.y *= -1.0
	)
	boundary_left.body_entered.connect(func(body: Node2D):
		body.velocity.x *= -1.0
	)
	boundary_right.body_entered.connect(func(body: Node2D):
		body.velocity.x *= -1.0
	)
	alignment_slider.value_changed.connect(update_alignment)
	separation_slider.value_changed.connect(update_separation)
	vision_slider.value_changed.connect(update_vision)

func update_alignment(v):
	boid_spawner.update_boid_alignments(v)
	alignment_value.text = str(v)

func update_separation(v):
	boid_spawner.update_boid_separations(v)
	separation_value.text = str(v)

func update_vision(v):
	boid_spawner.update_boid_visions(v)
	vision_value.text = str(v)
