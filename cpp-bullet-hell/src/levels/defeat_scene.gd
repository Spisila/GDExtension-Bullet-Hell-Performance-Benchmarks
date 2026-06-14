extends PanelContainer

@onready var high_score: Label = $CenterContainer/VBoxContainer/HighScore
@onready var current_score: Label = $CenterContainer/VBoxContainer/CurrentScore

func _ready() -> void:
	high_score.text = str(Globals.high_score)
	current_score.text = str(Globals.distance)
	Globals.distance = 0

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://CPP&MultiMeshInstance2D/cpp&multi_mesh_instance_2d.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
