extends Node2D

@onready var boundary_top = $BoundaryTop
@onready var boundary_bottom = $BoundaryBottom
@onready var boundary_left = $BoundaryLeft
@onready var boundary_right = $BoundaryRight

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
