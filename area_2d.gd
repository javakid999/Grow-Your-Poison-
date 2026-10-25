extends Area2D

const GUI_SCENE = preload("res://book_gui.tscn")
var gui_instance: CanvasLayer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not gui_instance:
				open_gui()
			else:
				close_gui()
				
func open_gui() -> void:
	# Instantiate and add to the scene tree
	gui_instance = GUI_SCENE.instantiate()
	add_child(gui_instance)

func close_gui() -> void:
	if gui_instance:
		gui_instance.queue_free() # Safely remove the GUI
		gui_instance = null
