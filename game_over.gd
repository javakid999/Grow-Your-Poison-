extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_game():
	get_tree().reload_current_scene()

func show_ending():
	$CanvasLayer.show()

func _input(event):
	if event.is_action_pressed('debug_end_game'):
		show_ending()

func _on_quest_submission_game_over() -> void:
	show_ending()
