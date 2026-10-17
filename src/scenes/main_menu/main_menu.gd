extends Control

@onready var btn_start: Button = %BtnStart
@onready var btn_stages: Button = %BtnStages
@onready var btn_research: Button = %BtnResearch
@onready var btn_ods: Button = %BtnOds
@onready var stages_modal: PanelContainer = %StagesModal
@onready var research_modal: PanelContainer = %ResearchModal
@onready var ods_modal: PanelContainer = %OdsModal
@onready var btn_close_stages: Button = %BtnCloseStages
@onready var btn_close_research: Button = %BtnCloseResearch
@onready var btn_close_ods: Button = %BtnCloseOds

@onready var btn_stage_1: Button = %BtnStage1
@onready var btn_stage_2: Button = %BtnStage2
@onready var btn_stage_3: Button = %BtnStage3
@onready var btn_stage_4: Button = %BtnStage4
@onready var btn_stage_5: Button = %BtnStage5
@onready var btn_stage_6: Button = %BtnStage6

var icon_ada = preload("res://src/assets/textures/portraits/Ada_Lovelace.png")
var icon_eniac = preload("res://src/assets/textures/portraits/Eniac Girls.png")
var icon_grace = preload("res://src/assets/textures/portraits/Grace_Hopper.png")
var icon_katherine = preload("res://src/assets/textures/portraits/Katherine Johnson.png")
var icon_keller = preload("res://src/assets/textures/portraits/Irmã Mary Kenneth Keller.png")
var icon_margaret = preload("res://src/assets/textures/portraits/Margaret_Hamilton.png")

@onready var pre_survey_modal: PanelContainer = %PreSurveyModal
@onready var input_name: LineEdit = %InputName
@onready var input_city: LineEdit = %InputCity
@onready var pre_q1: CheckBox = %PreQ1
@onready var pre_q2: CheckBox = %PreQ2
@onready var pre_q3: CheckBox = %PreQ3
@onready var btn_confirm_pre: Button = %BtnConfirmPre
@onready var btn_skip_pre: Button = %BtnSkipPre

var pre_survey_completed: bool = false

func _ready() -> void:
	AudioManager.play_bgm()

	btn_start.icon = preload("res://src/assets/textures/icons/icon_play.svg")
	btn_start.expand_icon = true
	btn_start.alignment = HORIZONTAL_ALIGNMENT_LEFT

	btn_stages.icon = preload("res://src/assets/textures/icons/icon_timeline.svg")
	btn_stages.expand_icon = true
	btn_stages.alignment = HORIZONTAL_ALIGNMENT_LEFT

	btn_research.icon = preload("res://src/assets/textures/icons/icon_info.svg")
	btn_research.expand_icon = true
	btn_research.alignment = HORIZONTAL_ALIGNMENT_LEFT

	btn_ods.icon = preload("res://src/assets/textures/icons/icon_female.svg")
	btn_ods.expand_icon = true
	btn_ods.alignment = HORIZONTAL_ALIGNMENT_LEFT

	btn_start.pressed.connect(_on_btn_start_pressed)
	btn_stages.pressed.connect(_on_btn_stages_pressed)
	btn_research.pressed.connect(func():
		AudioManager.play_click()
		research_modal.show()
	)
	btn_ods.pressed.connect(func():
		AudioManager.play_click()
		ods_modal.show()
	)
	btn_close_stages.pressed.connect(func(): stages_modal.hide())
	btn_close_research.pressed.connect(func(): research_modal.hide())
	btn_close_ods.pressed.connect(func(): ods_modal.hide())

	btn_stage_1.pressed.connect(func(): GameState.go_to_stage(1))
	btn_stage_2.pressed.connect(func(): GameState.go_to_stage(2))
	btn_stage_3.pressed.connect(func(): GameState.go_to_stage(3))
	btn_stage_4.pressed.connect(func(): GameState.go_to_stage(4))
	btn_stage_5.pressed.connect(func(): GameState.go_to_stage(5))
	btn_stage_6.pressed.connect(func(): GameState.go_to_stage(6))

	btn_confirm_pre.pressed.connect(_on_confirm_pre_survey)
	btn_skip_pre.pressed.connect(_on_skip_pre_survey)

	stages_modal.hide()
	research_modal.hide()
	ods_modal.hide()
	pre_survey_modal.hide()
	_update_stage_buttons()

func _update_stage_buttons() -> void:
	var max_stage = GameState.max_unlocked_stage
	
	btn_stage_1.disabled = false
	btn_stage_2.disabled = max_stage < 2
	btn_stage_3.disabled = max_stage < 3
	btn_stage_4.disabled = max_stage < 4
	btn_stage_5.disabled = max_stage < 5
	btn_stage_6.disabled = max_stage < 6

	btn_stage_1.icon = icon_ada
	btn_stage_1.expand_icon = true
	btn_stage_1.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_1.text = "Fase 1: Ada Lovelace (1843) — O Primeiro Algoritmo e a Visão do Software"

	btn_stage_2.icon = icon_eniac if max_stage >= 2 else null
	btn_stage_2.expand_icon = true
	btn_stage_2.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_2.text = ("Fase 2: ENIAC Girls (1945) — Programação Física de Hardware" if max_stage >= 2 else "[Bloqueada] Fase 2: ENIAC Girls")

	btn_stage_3.icon = icon_grace if max_stage >= 3 else null
	btn_stage_3.expand_icon = true
	btn_stage_3.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_3.text = ("Fase 3: Grace Hopper (1947) — O Bug & A Gênese dos Compiladores" if max_stage >= 3 else "[Bloqueada] Fase 3: Grace Hopper")

	btn_stage_4.icon = icon_katherine if max_stage >= 4 else null
	btn_stage_4.expand_icon = true
	btn_stage_4.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_4.text = ("Fase 4: Katherine Johnson (1962) — Mecânica Orbital & Auditoria Numérica" if max_stage >= 4 else "[Bloqueada] Fase 4: Katherine Johnson")

	btn_stage_5.icon = icon_keller if max_stage >= 5 else null
	btn_stage_5.expand_icon = true
	btn_stage_5.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_5.text = ("Fase 5: Mary Kenneth Keller (1965) — 1º Ph.D. Feminino & BASIC na Educação" if max_stage >= 5 else "[Bloqueada] Fase 5: Mary Kenneth Keller")

	btn_stage_6.icon = icon_margaret if max_stage >= 6 else null
	btn_stage_6.expand_icon = true
	btn_stage_6.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_stage_6.text = ("Fase 6: Margaret Hamilton (1969) — Engenharia de Software & Apollo 11" if max_stage >= 6 else "[Bloqueada] Fase 6: Margaret Hamilton")

func _on_btn_start_pressed() -> void:
	AudioManager.play_click()
	if not pre_survey_completed and GameState.max_unlocked_stage == 1:
		pre_survey_modal.show()
	else:
		GameState.go_to_stage(GameState.max_unlocked_stage)

func _on_confirm_pre_survey() -> void:
	AudioManager.play_click()
	pre_survey_completed = true
	var p_name = input_name.text.strip_edges()
	var p_city = input_city.text.strip_edges()
	if p_name.is_empty():
		p_name = "Estudante / Participante"
	if p_city.is_empty():
		p_city = "Não informada"
	
	GameState.player_name = p_name
	GameState.player_city = p_city
	GameState.telemetry_data["participant"]["name"] = p_name
	GameState.telemetry_data["participant"]["city"] = p_city
	
	GameState.telemetry_data["pre_survey"]["conhecimento_previo_pioneiras"] = pre_q1.button_pressed
	GameState.telemetry_data["pre_survey"]["ja_programou_antes"] = pre_q2.button_pressed
	GameState.telemetry_data["pre_survey"]["percepcao_mulheres_computacao"] = 5 if pre_q3.button_pressed else 2
	pre_survey_modal.hide()
	GameState.go_to_stage(1)

func _on_skip_pre_survey() -> void:
	AudioManager.play_click()
	pre_survey_completed = true
	var p_name = input_name.text.strip_edges()
	var p_city = input_city.text.strip_edges()
	if p_name.is_empty():
		p_name = "Participante Anônimo"
	if p_city.is_empty():
		p_city = "Não informada"
	GameState.player_name = p_name
	GameState.player_city = p_city
	GameState.telemetry_data["participant"]["name"] = p_name
	GameState.telemetry_data["participant"]["city"] = p_city
	pre_survey_modal.hide()
	GameState.go_to_stage(1)

func _on_btn_stages_pressed() -> void:
	AudioManager.play_click()
	_update_stage_buttons()
	stages_modal.show()
