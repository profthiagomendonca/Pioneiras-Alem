extends PanelContainer

signal dialogue_finished

@onready var label_name: Label = $Margin/HBoxMain/VBoxText/Header/SpeakerName
@onready var label_text: RichTextLabel = $Margin/HBoxMain/VBoxText/DialogueText
@onready var btn_next: Button = $Margin/HBoxMain/VBoxText/Footer/BtnNext
@onready var portrait_rect: TextureRect = $Margin/HBoxMain/PortraitContainer/Portrait

var portrait_ada = preload("res://src/assets/textures/portraits/Ada_Lovelace.png")
var portrait_grace = preload("res://src/assets/textures/portraits/Grace_Hopper.png")
var portrait_margaret = preload("res://src/assets/textures/portraits/Margaret_Hamilton.png")
var portrait_eniac = preload("res://src/assets/textures/portraits/Eniac Girls.png")
var portrait_katherine = preload("res://src/assets/textures/portraits/Katherine Johnson.png")
var portrait_keller = preload("res://src/assets/textures/portraits/Irmã Mary Kenneth Keller.png")

var dialogue_queue: Array[Dictionary] = []
var is_typing: bool = false
var text_tween: Tween

func _ready() -> void:
	btn_next.pressed.connect(_on_btn_next_pressed)
	hide()

func start_dialogue(lines: Array[Dictionary]) -> void:
	dialogue_queue = lines.duplicate()
	show()
	_display_next_line()

func _display_next_line() -> void:
	if dialogue_queue.is_empty():
		hide()
		emit_signal("dialogue_finished")
		return

	var current: Dictionary = dialogue_queue.pop_front()
	var speaker: String = current.get("speaker", "Narrador")
	label_name.text = speaker
	var text_content: String = current.get("text", "")

	# Definir retrato dinamicamente para as 6 pioneiras
	if "Ada" in speaker:
		portrait_rect.texture = portrait_ada
	elif "Grace" in speaker:
		portrait_rect.texture = portrait_grace
	elif "Margaret" in speaker:
		portrait_rect.texture = portrait_margaret
	elif "ENIAC" in speaker or "Eniac" in speaker:
		portrait_rect.texture = portrait_eniac
	elif "Katherine" in speaker:
		portrait_rect.texture = portrait_katherine
	elif "Keller" in speaker or "Mary" in speaker or "Irmã" in speaker:
		portrait_rect.texture = portrait_keller
	else:
		portrait_rect.texture = null

	label_text.text = text_content
	label_text.visible_ratio = 0.0
	is_typing = true
	btn_next.text = "Pular..."

	if text_tween and text_tween.is_valid():
		text_tween.kill()

	text_tween = create_tween()
	var duration: float = max(0.5, float(text_content.length()) * 0.025)
	text_tween.tween_property(label_text, "visible_ratio", 1.0, duration)
	text_tween.finished.connect(func():
		is_typing = false
		btn_next.text = "Continuar >"
	)

func _on_btn_next_pressed() -> void:
	AudioManager.play_click()
	if is_typing:
		if text_tween and text_tween.is_valid():
			text_tween.kill()
		label_text.visible_ratio = 1.0
		is_typing = false
		btn_next.text = "Continuar >"
	else:
		_display_next_line()

func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)):
		_on_btn_next_pressed()
		get_viewport().set_input_as_handled()
