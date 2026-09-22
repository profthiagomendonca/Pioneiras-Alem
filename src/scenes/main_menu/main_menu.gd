extends Control

@onready var btn_start: Button = %BtnStart
@onready var btn_stages: Button = %BtnStages
@onready var btn_about: Button = %BtnAbout
@onready var stages_modal: PanelContainer = %StagesModal
@onready var about_modal: PanelContainer = %AboutModal
@onready var btn_close_stages: Button = %BtnCloseStages
@onready var btn_close_about: Button = %BtnCloseAbout

@onready var btn_stage_1: Button = %BtnStage1
@onready var btn_stage_2: Button = %BtnStage2
@onready var btn_stage_3: Button = %BtnStage3
@onready var btn_stage_4: Button = %BtnStage4
@onready var btn_stage_5: Button = %BtnStage5
@onready var btn_stage_6: Button = %BtnStage6

func _ready() -> void:
	btn_start.pressed.connect(_on_btn_start_pressed)
	btn_stages.pressed.connect(_on_btn_stages_pressed)
	btn_about.pressed.connect(_on_btn_about_pressed)
	btn_close_stages.pressed.connect(func(): stages_modal.hide())
	btn_close_about.pressed.connect(func(): about_modal.hide())

	btn_stage_1.pressed.connect(func(): GameState.go_to_stage(1))
	btn_stage_2.pressed.connect(func(): GameState.go_to_stage(2))
	btn_stage_3.pressed.connect(func(): GameState.go_to_stage(3))
	btn_stage_4.pressed.connect(func(): GameState.go_to_stage(4))
	btn_stage_5.pressed.connect(func(): GameState.go_to_stage(5))
	btn_stage_6.pressed.connect(func(): GameState.go_to_stage(6))

	stages_modal.hide()
	about_modal.hide()
	_update_stage_buttons()

func _update_stage_buttons() -> void:
	var max_stage = GameState.max_unlocked_stage
	
	btn_stage_1.disabled = false
	btn_stage_2.disabled = max_stage < 2
	btn_stage_3.disabled = max_stage < 3
	btn_stage_4.disabled = max_stage < 4
	btn_stage_5.disabled = max_stage < 5
	btn_stage_6.disabled = max_stage < 6

	btn_stage_1.text = "Fase 1: Ada Lovelace (1843) — O Primeiro Algoritmo"
	btn_stage_2.text = ("Fase 2: ENIAC Girls (1945) — Programação Física" if max_stage >= 2 else "[Bloqueada] Fase 2: ENIAC Girls")
	btn_stage_3.text = ("Fase 3: Grace Hopper (1947) — O Bug & Compilador" if max_stage >= 3 else "[Bloqueada] Fase 3: Grace Hopper")
	btn_stage_4.text = ("Fase 4: Katherine Johnson (1962) — Mecânica Orbital" if max_stage >= 4 else "[Bloqueada] Fase 4: Katherine Johnson")
	btn_stage_5.text = ("Fase 5: Mary Kenneth Keller (1965) — BASIC na Educação" if max_stage >= 5 else "[Bloqueada] Fase 5: Mary Kenneth Keller")
	btn_stage_6.text = ("Fase 6: Margaret Hamilton (1969) — A Missão Apollo" if max_stage >= 6 else "[Bloqueada] Fase 6: Margaret Hamilton")

func _on_btn_start_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(GameState.max_unlocked_stage)

func _on_btn_stages_pressed() -> void:
	AudioManager.play_click()
	_update_stage_buttons()
	stages_modal.show()

func _on_btn_about_pressed() -> void:
	AudioManager.play_click()
	about_modal.show()
