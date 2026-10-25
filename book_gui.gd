extends CanvasLayer
@onready var book = get_parent()
@onready var page_l: Label = $Sprite2D/PageL
@onready var page_r: Label = $Sprite2D/PageR
@onready var button_l: Button = $ButtonL
@onready var button_r: Button = $ButtonR

var potion_ids: Array = []
var spread: int = 0   # index of the recipe shown on the left page

func _ready() -> void:
	potion_ids = book.recipes.keys()
	potion_ids.sort()
	_render()

func turn(direction: int) -> void:
	var next = spread + 2 * direction
	if next >= 0 and next < potion_ids.size():
		spread = next
		_render()

func _render() -> void:
	page_l.text = _page_text(spread)
	page_r.text = _page_text(spread + 1)
	button_l.visible = spread > 0
	button_r.visible = spread + 2 < potion_ids.size()

func _page_text(i: int) -> String:
	if i >= potion_ids.size():
		return ''
	var r = book.recipes[potion_ids[i]]
	var lines = [r['name'], '']
	for id in r['ingredients']:
		lines.append('- ' + book.inventory.item_names[str(id)])
	lines.append('Stir and let sit for %d days' % r['days'])
	return '\n'.join(lines)
