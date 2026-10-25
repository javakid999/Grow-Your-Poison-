extends Node2D

@onready var hover_sprite: Sprite2D = $HoverSprite
@onready var tile_map: TileMapLayer = $TileMapLayer
var hovered_cell := Vector2i(-9999, -9999)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())

	if cell == hovered_cell:
		return

	# Is there actually a tile under the mouse?
	if tile_map.get_cell_source_id(cell) == -1:   # layer 0
		hovered_cell = Vector2i(-9999, -9999)
		hover_sprite.visible = false
		return

	hovered_cell = cell
	on_hover_changed(cell)

func on_hover_changed(cell: Vector2i):
	hover_sprite.visible = true
	var target = tile_map.map_to_local(cell) * 8 + Vector2(0, -12 + 32)  # lifted 6px
	hover_sprite.position = target

func get_cell():
	return hovered_cell
