extends Node2D

# Path to dialogue_ui instance in main scene
@onready var dialogue_ui: CanvasLayer = get_tree().current_scene.get_node("Dialogue_UI/canvas")
# Path to dialogue_ui speaker_name instance in main scene
@onready var speaker_name: RichTextLabel = get_tree().current_scene.get_node("Dialogue_UI/canvas/speaker_name")
# Path to dialogue_ui speaker_dialogue instance in main scene
@onready var speaker_dialogue: RichTextLabel = get_tree().current_scene.get_node("Dialogue_UI/canvas/speaker_dialogue")
# Path to player node in main scene
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
# Path to dialogue_ui animation player instance in main scene
@onready var dialogue_animation: AnimationPlayer = get_tree().current_scene.get_node("Dialogue_UI/canvas/animation_player")

@onready var quest_button: Button = $quest_button

@export var dialogues: Array[String]
@export var speaker_names: Array[String]

var current_dialogue: int = -1
var started: bool = false

signal dialogue_start
signal dialogue_over
signal quest_accepted
signal quest_rejected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Perhaps for when we add multiple lines of dialogue for one character.
	# dialogue_ui.get_node("continue_button").connect("pressed", Callable(self, "continue_dialogue"))
	dialogue_ui.get_node("accept_button").connect("pressed", Callable(self, "quest_accept"))
	dialogue_ui.get_node("reject_button").connect("pressed", Callable(self, "quest_reject"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_dialogue() -> void:
	print(current_dialogue)
	if !started:
		started = true
		dialogue_ui.visible = true
		dialogue_start.emit()
		continue_dialogue()
		
func end_dialogue() -> void:
	dialogue_ui.visible = false
	started = false
	dialogue_over.emit()
	
func quest_accept() -> void:
	print("got accepted")
	quest_accepted.emit()
	end_dialogue()
	
func quest_reject() -> void:
	print("got rejected")
	quest_rejected.emit()
	end_dialogue()

func continue_dialogue() -> void:
	current_dialogue += 1
	if current_dialogue < dialogues.size():
		if !dialogue_ui.visible:
			dialogue_ui.visible = true
		speaker_name.text = speaker_names[current_dialogue]
		speaker_dialogue.text = dialogues[current_dialogue]
		dialogue_animation.play("RESET")
		dialogue_animation.play("scroll")
	else:
		end_dialogue()
