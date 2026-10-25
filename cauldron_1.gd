extends Sprite2D

var ingredients: Array = []
var recipe: int = -1
var ready_day: int = -1

@onready var inventory = get_parent()
@onready var book = $"../instruction-book/Area2D"

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return
	if get_rect().has_point(to_local(get_global_mouse_position())):
		_clicked()

func _clicked() -> void:
	if recipe != -1:
		_try_collect()
		return
	var held = inventory.get_held_block()
	if held == -1 or not _is_ingredient(held):
		return
	ingredients.append(held)
	inventory.decrease_held_item()
	_check_recipe()

func _is_ingredient(id: int) -> bool:
	return id % 7 == 6 and id <= 41   # harvested crop column of the spritesheet

func _check_recipe() -> void:
	var potion = book.match_recipe(ingredients)
	if potion != -1:
		recipe = potion
		ready_day = _current_day() + book.recipes[potion]['days']
		modulate = Color(0.7, 0.9, 1.0)   # brewing
	elif ingredients.size() >= book.max_ingredients():
		_reset()                           # failed brew

func _try_collect() -> void:
	if _current_day() < ready_day:
		return
	if inventory.is_in_inventory(recipe):
		inventory.increase_item_with_id(recipe)
	elif inventory.is_free_space():
		inventory.give_harvested_item(recipe)
	else:
		return   # no room, brew stays in the cauldron
	_reset()

func _reset() -> void:
	ingredients = []
	recipe = -1
	ready_day = -1
	modulate = Color.WHITE

func is_ready() -> bool:
	return recipe != -1 and _current_day() >= ready_day

func _current_day() -> int:
	var keeper = get_tree().get_first_node_in_group('day_keeper')
	return keeper.day if keeper else 0
