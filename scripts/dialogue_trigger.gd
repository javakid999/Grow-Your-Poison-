extends Node2D

# Path to dialogue_ui instance in main scene
@onready var dialogue_ui: CanvasLayer = get_tree().current_scene.get_node("Dialogue_UI/canvas")
@onready var speaker_name: RichTextLabel = dialogue_ui.get_node("speaker_name")
@onready var speaker_dialogue: RichTextLabel = dialogue_ui.get_node("speaker_dialogue")
@onready var dialogue_animation: AnimationPlayer = dialogue_ui.get_node("animation_player")
@onready var speaker_sprite: Sprite2D = dialogue_ui.get_node("speaker_sprite")

# Path to player node in main scene
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

@onready var accept_button: Button = dialogue_ui.get_node("accept_button")
@onready var reject_button: Button = dialogue_ui.get_node("reject_button")
@onready var quest_button: Button = $quest_button

@export var dialogues: Array[String]
@export var speaker_names: Array[String]

const speaker_filepath = "res://assets/images/character_sprites/"

var current_dialogue: int = 0
var started: bool = false

signal dialogue_start
signal dialogue_over
signal quest_accepted
signal quest_rejected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Perhaps for when we add multiple lines of dialogue for one character.
	# dialogue_ui.get_node("continue_button").connect("pressed", Callable(self, "continue_dialogue"))
	quest_button.show()
	accept_button.connect("pressed", Callable(self, "quest_accept"))
	reject_button.connect("pressed", Callable(self, "quest_reject"))
	dialogue_animation.animation_finished.connect(_on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_dialogue() -> void:
	if !started:
		started = true
		dialogue_ui.visible = true
		dialogue_start.emit()
		
		if current_dialogue < dialogues.size():
			if !dialogue_ui.visible:
				dialogue_ui.visible = true
			speaker_name.text = speaker_names[current_dialogue]
			speaker_dialogue.text = dialogues[current_dialogue]
			speaker_sprite.texture = load(speaker_filepath + speaker_names[current_dialogue] + ".png")
			accept_button.hide()
			reject_button.hide()
			dialogue_animation.play("RESET")
			dialogue_animation.play("scroll")
		
func end_dialogue() -> void:
	dialogue_ui.visible = false
	dialogue_over.emit()

func _on_animation_finished(_anim_name: String) -> void:
	accept_button.show()
	reject_button.show()

# QUEST HANDLING

func quest_accept() -> void:
	quest_accepted.emit()
	quest_button.hide()
	end_dialogue()
	
func quest_reject() -> void:
	quest_rejected.emit()
	end_dialogue()

func _on_quest_complete() -> void:
	started = false
	current_dialogue += 1
	if current_dialogue >= dialogues.size():
		current_dialogue = 0
	quest_button.show()
	
	


## Keeping in case we ever want more than one line of dialogue per character
#func continue_dialogue() -> void:
	## current_dialogue += 1
	#if current_dialogue < dialogues.size():
		#if !dialogue_ui.visible:
			#dialogue_ui.visible = true
		#speaker_name.text = speaker_names[current_dialogue]
		#speaker_dialogue.text = dialogues[current_dialogue]
		#dialogue_animation.play("RESET")
		#dialogue_animation.play("scroll")
	#else:
		#end_dialogue()
