extends Node2D

@onready var submit_button: Button = $SubmitButton

var quest_active: bool
var rejected_count: int = 0

signal quest_complete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func quest_accepted() -> void:
	quest_active = true
	submit_button.show()
	
func quest_rejected() -> void:
	rejected_count += 1
	quest_complete.emit()

func _on_submit_button_pressed() -> void:
	quest_active = false
	submit_button.hide()
	quest_complete.emit()
