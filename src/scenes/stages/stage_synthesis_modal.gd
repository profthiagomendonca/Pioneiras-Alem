extends PanelContainer

signal closed(is_victory)

@onready var title_label: Label = %TitleLabel
@onready var tab_pioneer_btn: Button = %TabPioneerBtn
@onready var tab_history_btn: Button = %TabHistoryBtn
@onready var tab_concept_btn: Button = %TabConceptBtn
@onready var tab_today_btn: Button = %TabTodayBtn
@onready var content_text: RichTextLabel = %ContentText
@onready var btn_continue: Button = %BtnContinue
@onready var btn_close_modal: Button = %BtnCloseModal
@onready var icon_category: TextureRect = %IconCategory

var current_data: Dictionary = {}
var current_tab: int = 0
var is_victory_mode: bool = false

func _ready() -> void:
	tab_pioneer_btn.pressed.connect(func(): _select_tab(0))
	tab_history_btn.pressed.connect(func(): _select_tab(1))
	tab_concept_btn.pressed.connect(func(): _select_tab(2))
	tab_today_btn.pressed.connect(func(): _select_tab(3))
	btn_continue.pressed.connect(_on_btn_continue_pressed)
	btn_close_modal.pressed.connect(_on_btn_close_modal_pressed)
	hide()

func show_synthesis(data: Dictionary, victory_mode: bool = false) -> void:
	current_data = data
	is_victory_mode = victory_mode
	if victory_mode:
		title_label.text = "🏆 Conquista da Era — " + data.get("stage_title", "Conceito Histórico")
		btn_close_modal.text = "✕ Fechar"
	else:
		title_label.text = "📖 Cartão de Conhecimento — " + data.get("stage_title", "Conceito Histórico")
		btn_close_modal.text = "✕ Voltar ao Jogo"
	_select_tab(0)
	show()

func _select_tab(tab_idx: int) -> void:
	AudioManager.play_click()
	current_tab = tab_idx

	var active_color = Color(0.96, 0.82, 0.36, 1.0)
	var inactive_color = Color(0.7, 0.75, 0.85, 0.9)

	tab_pioneer_btn.modulate = active_color if tab_idx == 0 else inactive_color
	tab_history_btn.modulate = active_color if tab_idx == 1 else inactive_color
	tab_concept_btn.modulate = active_color if tab_idx == 2 else inactive_color
	tab_today_btn.modulate = active_color if tab_idx == 3 else inactive_color

	match tab_idx:
		0:
			content_text.text = current_data.get("pioneer_text", "")
		1:
			content_text.text = current_data.get("history_text", "")
		2:
			content_text.text = current_data.get("concept_text", "")
		3:
			content_text.text = current_data.get("today_text", "")

	if tab_idx == 3:
		if is_victory_mode:
			btn_continue.text = "Avançar para a Próxima Era >"
		else:
			btn_continue.text = "✕ Concluir e Voltar ao Desafio"
	else:
		btn_continue.text = "Próximo Tópico >"

func _on_btn_close_modal_pressed() -> void:
	AudioManager.play_click()
	hide()
	emit_signal("closed", is_victory_mode)

func _on_btn_continue_pressed() -> void:
	AudioManager.play_click()
	if current_tab < 3:
		_select_tab(current_tab + 1)
	else:
		hide()
		emit_signal("closed", is_victory_mode)
