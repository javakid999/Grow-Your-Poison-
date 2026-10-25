extends Area2D

@onready var inventory = get_node("../..")
const GUI_SCENE = preload("res://book_gui.tscn")
var gui_instance: CanvasLayer = null

const recipes = {
		42: { 'name': 'Potion of 1',  'ingredients': [41, 13, 13], 'days': 1 },
		43: { 'name': 'Potion of 2', 'ingredients': [20, 34, 34], 'days': 2 },
		44: { 'name': 'Potion of 3',  'ingredients': [27, 6, 41],  'days': 3 },
}

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
		
func max_ingredients() -> int:
	var longest = 0
	for r in recipes.values():
		longest = max(longest, r['ingredients'].size())
	return longest
		
func match_recipe(ingredients: Array) -> int:
	var have = ingredients.duplicate()
	have.sort()
	for potion_id in recipes:
		var want = recipes[potion_id]['ingredients'].duplicate()
		want.sort()
		if want == have:
			return potion_id
	return -1
