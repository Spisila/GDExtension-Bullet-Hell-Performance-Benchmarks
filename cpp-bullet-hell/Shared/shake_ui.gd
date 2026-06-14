extends ProgressBar

@onready var back_to_original_pos: Timer = $BackToOriginalPos

var original_pos : Vector2

@export var x_range : Vector2
@export var y_range : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_pos = self.position

func shake() -> void:
	var ran_x: float = randf_range(x_range.x, x_range.y)
	var ran_y: float = randf_range(y_range.x, y_range.y)
	
	var ran_pos: Vector2 = Vector2(ran_x, ran_y)
	
	var tween = create_tween()
	tween.tween_property(
		self, 
		"global_position", 
		original_pos + ran_pos, 0.01
	)
	
	back_to_original_pos.start()
	


func _on_bullet_manager_player_hit() -> void:
	shake()


func _on_back_to_original_pos_timeout() -> void:
	self.global_position = original_pos
