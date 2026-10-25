extends Node2D

@onready var placing_layer = $"../Tiles/TileMapLayer2"
@onready var inventory = $"../HUD/Inventory"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		# Check if it is the left mouse button and it was just pressed (not released)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = $"../Tiles".get_cell()
			var held_item_id = inventory.get_held_block()
			placing_layer.set_cell(cell, 1, Vector2i(held_item_id % 7, floor(held_item_id / 7)))
