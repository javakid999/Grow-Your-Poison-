extends Node2D

var item_ids = [
	0, 1, 2, 3, 4, 5	
]
@onready var items = [
	$Inventory/Slot1,
	$Inventory/Slot2,
	$Inventory/Slot3,
	$Inventory/Slot4,
	$Inventory/Slot5,
	$Inventory/Slot6
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		update_item(i, item_ids[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_item(slot, item_id):
	print(items[slot])
	if item_id == -1:
		#hide:
		return
	else:
		#show
		items[slot].region_rect = Rect2(3 + 21 * item_id, 3, 16, 16)
		pass
