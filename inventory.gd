extends Node2D

var item_ids = [
	0, 1, 2, 3, 4, 5	
]
var item_count = [
	100,100,100,100,100,100
]
@onready var items = [
	$Inventory/Slot1,
	$Inventory/Slot2,
	$Inventory/Slot3,
	$Inventory/Slot4,
	$Inventory/Slot5,
	$Inventory/Slot6
]

var selected_slot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		update_item(i, item_ids[i], 100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_item(slot, item_id, count):
	if item_id == -1:
		items[slot].hide()
		return
	else:
		items[slot].show()
		items[slot].region_rect = Rect2(21 * (item_id % 7), 24 * floor(item_id / 7), 21, 24)
		items[slot].get_node('Label').text = str(count)
		
func get_held_block():
	return item_ids[selected_slot]
