extends Node2D

var item_ids = [
	0, 7, 14, 21, 28, 35	
]
var item_count = [
	2,2,2,2,2,2
]

const item_names = {
	'0': 'Carrot Seeds',
	'6': 'Carrot',
	'7': 'Magic Bean Seeds',
	'13': 'Magic Bean',
	'14': 'Gourd Seeds',
	'20': 'Gourd',
	'21': 'Cactus Seeds',
	'27': 'Cactus',
	'28': 'Kale Seeds',
	'34': 'Kale',
	'35': 'Glowing Fruit Seeds',
	'41': 'Glowing Fruit'
}

const placeable_ids = [
	0,7,14,21,28,35
]

@onready var items = [
	$Inventory/Slot1,
	$Inventory/Slot2,
	$Inventory/Slot3,
	$Inventory/Slot4,
	$Inventory/Slot5,
	$Inventory/Slot6
]
@onready var selection_ghost: Sprite2D = $Inventory/SelectionGhost
@onready var selection_label: Label = $SelectionLabel

var selected_slot = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(6):
		update_item(i, item_ids[i], 2)
	update_selection_ghost()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_item(slot, item_id, count):
	if item_id == -1:
		items[slot].hide()
		return
	else:
		items[slot].show()
		items[slot].region_rect = Rect2(16 * (item_id % 7), 16 * floor(item_id / 7), 16, 16)
		items[slot].get_node('Label').text = str(count)
		
func get_held_block():
	if selected_slot == -1:
		return -1
	return item_ids[selected_slot]

func decrease_held_item():
	item_count[selected_slot] -= 1
	if item_count[selected_slot] == 0:
		item_count[selected_slot] = -1
		item_ids[selected_slot] = -1
	update_item(selected_slot, item_ids[selected_slot], item_count[selected_slot])
	update_selection_ghost()
	
func update_selection_ghost():
	if selected_slot == -1:
		selection_ghost.hide()
		selection_label.hide()
	else:
		selection_label.show()
		selection_ghost.show()
		if item_ids[selected_slot] == -1:
			selection_label.text = ''
		else: selection_label.text = item_names[str(item_ids[selected_slot])]
		selection_ghost.position.x = 17 * selected_slot + 4

func is_placeable(id):
	return placeable_ids.count(id) > 0

func is_in_inventory(id):
	return item_ids.count(id) > 0

func is_free_space():
	return item_ids.count(-1) > 0

func increase_item_with_id(id):
	var index = item_ids.find(id)
	item_count[index] += 1
	update_item(index, id, item_count[index])
	update_selection_ghost()

func give_harvested_item(id):
	var free_slot = item_ids.find(-1)
	item_ids[free_slot] = id
	item_count[free_slot] = 1
	update_item(free_slot, item_ids[free_slot], item_count[free_slot])
	update_selection_ghost()

func _input(event):
	if event.is_action_pressed('slot 1'):
		selected_slot = 0
		update_selection_ghost()
	if event.is_action_pressed('slot 2'):
		selected_slot = 1
		update_selection_ghost()
	if event.is_action_pressed('slot 3'):
		selected_slot = 2
		update_selection_ghost()
	if event.is_action_pressed('slot 4'):
		selected_slot = 3
		update_selection_ghost()
	if event.is_action_pressed('slot 5'):
		selected_slot = 4
		update_selection_ghost()
	if event.is_action_pressed('slot 6'):
		selected_slot = 5
		update_selection_ghost()
	if event.is_action_pressed('shovel slot'):
		selected_slot = -1
		update_selection_ghost()
