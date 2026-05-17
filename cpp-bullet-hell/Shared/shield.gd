extends CPUParticles2D

@export var radius : float

@export var amount_of_points : int

@onready var circle_pivot: Marker2D = $CirclePivot
@onready var circle_point: Marker2D = $CirclePivot/CirclePoint

func  _ready() -> void:
	
	circle_point.position.x -= radius
	
	var rotation_amount : float = 360.0 / amount_of_points
	
	self.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINTS

	for i in range(amount_of_points) :
		
		self.emission_points.push_back(circle_point.position)
		circle_pivot.rotation_degrees += rotation_amount
		
	print(emission_points)
