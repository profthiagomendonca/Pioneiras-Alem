extends Control

@onready var label_score: Label = %LabelScore
@onready var label_metrics: RichTextLabel = %LabelMetrics
@onready var btn_copy_telemetry: Button = %BtnCopyTelemetry
@onready var btn_play_again: Button = %BtnPlayAgain
@onready var btn_main_menu: Button = %BtnMainMenu
@onready var copy_feedback: Label = %CopyFeedback

# Perguntas de pós-teste / avaliação científica
@onready var q1_check: CheckBox = %Q1Check
@onready var q2_check: CheckBox = %Q2Check
@onready var q3_check: CheckBox = %Q3Check

func _ready() -> void:
	AudioManager.play_success()
	label_score.text = "Pontuação Total: " + str(GameState.player_score) + " pts"
	copy_feedback.text = ""

	_format_metrics_display()

	btn_copy_telemetry.pressed.connect(_on_btn_copy_telemetry_pressed)
	btn_play_again.pressed.connect(_on_btn_play_again_pressed)
	btn_main_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)

func _format_metrics_display() -> void:
	var stages = GameState.telemetry_data["stages"]

	var text = "[b]Desempenho e Telemetria Científica (COTB - 6 Pioneiras):[/b]\n\n"
	text += "1. [color=#ffd54f]Ada Lovelace (1843):[/color] " + str(snapped(stages["ada"]["time_spent"], 0.1)) + "s | " + str(stages["ada"]["attempts"]) + " tent.\n"
	text += "2. [color=#ef5350]ENIAC Girls (1945):[/color] " + str(snapped(stages["eniac"]["time_spent"], 0.1)) + "s | " + str(stages["eniac"]["attempts"]) + " tent.\n"
	text += "3. [color=#4fc3f7]Grace Hopper (1947):[/color] " + str(snapped(stages["grace"]["time_spent"], 0.1)) + "s | " + str(stages["grace"]["attempts"]) + " tent.\n"
	text += "4. [color=#81c784]Katherine Johnson (1962):[/color] " + str(snapped(stages["katherine"]["time_spent"], 0.1)) + "s | " + str(stages["katherine"]["attempts"]) + " tent.\n"
	text += "5. [color=#ba68c8]Mary Kenneth Keller (1965):[/color] " + str(snapped(stages["keller"]["time_spent"], 0.1)) + "s | " + str(stages["keller"]["attempts"]) + " tent.\n"
	text += "6. [color=#ff8a65]Margaret Hamilton (1969):[/color] " + str(snapped(stages["margaret"]["time_spent"], 0.1)) + "s | " + str(stages["margaret"]["attempts"]) + " tent.\n\n"
	text += "[i]Dados estruturados prontos para coleta empírica e análise quantitativa no artigo.[/i]"

	label_metrics.text = text

func _on_btn_copy_telemetry_pressed() -> void:
	AudioManager.play_click()
	var report = {
		"timestamp": Time.get_datetime_string_from_system(),
		"score": GameState.player_score,
		"metrics": GameState.telemetry_data["stages"],
		"post_test_answers": {
			"conhecia_pioneiras": q1_check.button_pressed,
			"percebeu_impacto_ods05": q2_check.button_pressed,
			"engajamento_positivo": q3_check.button_pressed
		}
	}
	var json_str = JSON.stringify(report, "\t")
	DisplayServer.clipboard_set(json_str)
	copy_feedback.text = "✓ Dados JSON copiados para a área de transferência!"
	copy_feedback.modulate = Color(0.3, 1.0, 0.5)

func _on_btn_play_again_pressed() -> void:
	AudioManager.play_click()
	GameState.player_score = 0
	GameState.go_to_stage(1)
