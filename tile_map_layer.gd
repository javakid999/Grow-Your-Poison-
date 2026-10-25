extends Node2D

@onready var hover_sprite: Sprite2D = $HoverSprite
@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var inventory: Node2D = $"../HUD/Inventory"
@onready var plant_info: Label = $"../HUD/PlantInfo"
@onready var placing_layer = $"TileMapLayer2"
var hovered_cell := Vector2i(-9999, -9999)
var can_place = false

var day = 0
var plants = [
	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	increment_day()

func _process(delta: float) -> void:
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	var plant_layer_cell = placing_layer.local_to_map(placing_layer.get_local_mouse_position())
	
	var selected_id = inventory.get_held_block()
	if inventory.selected_slot == -1:
		hover_sprite.region_rect = Rect2(0, 16 * 8, 16, 16)
	else:
		hover_sprite.region_rect = Rect2(16 * (selected_id % 7), 16 * floor(selected_id / 7), 16, 16)

	if cell == hovered_cell:
		return

	if placing_layer.get_cell_atlas_coords(plant_layer_cell) != Vector2i(-1,-1):
		var plant_selected = null
		for plant in plants:
			if plant['coords'] == cell:
				plant_selected = plant
		if plant_selected == null:
			print('WARNING: NO PLANT IS HERE')
		else:
			if plant_selected['time_grown']-day < 1:
				plant_info.text = 'Plant: {name}\nReady to Harvest!'.format({'name': str(plant_selected['id'])}) 
			else:
				plant_info.text = 'Plant: {name}\n Days \'till grown: {day}'.format({'name': str(plant_selected['id']), 'day': str(plant_selected['time_grown']-day)}) 
	else:
		plant_info.text = ''

	# Is there actually a tile under the mouse?
	if tile_map.get_cell_source_id(cell) == -1 or tile_map.get_cell_atlas_coords(cell) != Vector2i(5,2) or ((placing_layer.get_cell_atlas_coords(plant_layer_cell) != Vector2i(-1,-1)) == (inventory.selected_slot != -1)):   # layer 0
		hovered_cell = Vector2i(-9999, -9999)
		hover_sprite.visible = false
		can_place = false
		return

	hovered_cell = cell
	on_hover_changed(cell)

# ------------------------------
# INTERACTION-INPUT HANDLING
# ------------------------------

var is_interacting = false

func _on_dialogue_trigger_dialogue_start() -> void:
	is_interacting = true
	
func _on_dialogue_trigger_dialogue_over() -> void:
	is_interacting = false

func _input(event):
	if event is InputEventMouseButton and !is_interacting:
		# Check if it is the left mouse button and it was just pressed (not released)
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var cell = $"../Tiles".get_cell()
			
			if inventory.selected_slot == -1: # Remove Plant
				cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
				placing_layer.set_cell(cell, 1, Vector2i(-1, -1))
				
				var find_coord = func(plant):
					return plant['coords'] == cell
				var plant_index = plants.find_custom(find_coord)
				if plant_index != -1:
					plants.remove_at(plant_index)
			
			var held_item_id = inventory.get_held_block()
			if held_item_id != -1  and $"../Tiles".get_can_place() and inventory.is_placeable(held_item_id):  # Place Plant
				placing_layer.set_cell(cell, 1, Vector2i(held_item_id % 7, floor(held_item_id / 7)))
				plants.append(
					{
						'coords': cell,
						'id': held_item_id,
						'time_grown': day + 2
					}
				)
				inventory.decrease_held_item()
				can_place = false
				hovered_cell = Vector2i(-1,-1)
			
			# else - harvest plant
			cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
			var find_coord = func(plant):
					return plant['coords'] == cell
			var plant_index = plants.find_custom(find_coord)
			if plant_index != -1:
				if plants[plant_index]['time_grown'] <= day: # Can be harvested
					if inventory.is_in_inventory(plants[plant_index]['id']+6):
						inventory.increase_item_with_id(plants[plant_index]['id']+6)
						plants.remove_at(plant_index)
						placing_layer.set_cell(cell, 1, Vector2i(-1, -1))
					elif inventory.is_free_space(): # Can be collected
						inventory.give_harvested_item(plants[plant_index]['id']+6)
						plants.remove_at(plant_index)
						placing_layer.set_cell(cell, 1, Vector2i(-1, -1))
						
	# You can no longer skip the day while talking to someone
	if event.is_action_pressed('debug_skip_day') and !is_interacting:
		increment_day()

func update_plants():
	for plant in plants:
		if plant['time_grown'] <= day:
			placing_layer.set_cell(plant['coords'], 1, Vector2i((plant['id'] + 5) % 7, floor(plant['id'] / 7)))

func on_hover_changed(cell: Vector2i):
	hover_sprite.visible = true
	can_place = true
	var target = tile_map.map_to_local(cell) * 8 + Vector2(0, 0)  # lifted 6px
	hover_sprite.position = target
	
func get_cell():
	return hovered_cell
	
func get_can_place():
	return can_place
	
func increment_day():
	day += 1
	update_plants()
	$"../HUD/DayCounter".text = 'Day ' + str(day)
