extends Control

@onready var label_score: Label = %LabelScore
@onready var label_metrics: RichTextLabel = %LabelMetrics
@onready var btn_copy_telemetry: Button = %BtnCopyTelemetry
@onready var btn_save_telemetry: Button = %BtnSaveTelemetry
@onready var btn_play_again: Button = %BtnPlayAgain
@onready var btn_main_menu: Button = %BtnMainMenu
@onready var copy_feedback: Label = %CopyFeedback

# Perguntas de pós-teste / avaliação científica
@onready var q1_check: CheckBox = %Q1Check
@onready var q2_check: CheckBox = %Q2Check
@onready var q3_check: CheckBox = %Q3Check
@onready var q4_check: CheckBox = %Q4Check

func _ready() -> void:
	AudioManager.play_success()
	var p_name = GameState.player_name if not GameState.player_name.is_empty() else "Participante"
	var p_city = GameState.player_city if not GameState.player_city.is_empty() else "Não informada"
	label_score.text = "Pontuação: " + str(GameState.player_score) + " pts | Participante: " + p_name + " (" + p_city + ")"
	copy_feedback.text = ""

	_format_metrics_display()

	btn_copy_telemetry.pressed.connect(_on_btn_copy_telemetry_pressed)
	btn_save_telemetry.pressed.connect(_on_btn_save_telemetry_pressed)
	btn_play_again.pressed.connect(_on_btn_play_again_pressed)
	btn_main_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)

func _format_metrics_display() -> void:
	var stages = GameState.telemetry_data["stages"]
	var p_name = GameState.player_name if not GameState.player_name.is_empty() else "Estudante / Participante"
	var p_city = GameState.player_city if not GameState.player_city.is_empty() else "Não informada"
	var pre = GameState.telemetry_data["pre_survey"]

	var text = "[b]Identificação do Participante:[/b]\n"
	text += "• Nome: [color=#ffd54f]" + p_name + "[/color] | Cidade/UF: [color=#81c784]" + p_city + "[/color]\n\n"
	
	text += "[b]Sondagem Inicial (Pré-Teste):[/b]\n"
	text += "• Conhecia pioneiras: " + ("[color=#81c784]Sim[/color]" if pre.get("conhecimento_previo_pioneiras", false) else "[color=#ef5350]Não[/color]")
	text += " | Já programou: " + ("[color=#81c784]Sim[/color]" if pre.get("ja_programou_antes", false) else "[color=#ef5350]Não[/color]") + "\n\n"

	text += "[b]Telemetria das 6 Eras Históricas (COTB):[/b]\n"
	text += "1. [color=#ffd54f]Ada Lovelace (1843):[/color] " + str(snapped(stages["ada"]["time_spent"], 0.1)) + "s | " + str(stages["ada"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["ada"]["read_synthesis"] else "Pendente") + "\n"
	text += "2. [color=#ef5350]ENIAC Girls (1945):[/color] " + str(snapped(stages["eniac"]["time_spent"], 0.1)) + "s | " + str(stages["eniac"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["eniac"]["read_synthesis"] else "Pendente") + "\n"
	text += "3. [color=#4fc3f7]Grace Hopper (1947):[/color] " + str(snapped(stages["grace"]["time_spent"], 0.1)) + "s | " + str(stages["grace"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["grace"]["read_synthesis"] else "Pendente") + "\n"
	text += "4. [color=#81c784]Katherine Johnson (1962):[/color] " + str(snapped(stages["katherine"]["time_spent"], 0.1)) + "s | " + str(stages["katherine"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["katherine"]["read_synthesis"] else "Pendente") + "\n"
	text += "5. [color=#ba68c8]Mary Kenneth Keller (1965):[/color] " + str(snapped(stages["keller"]["time_spent"], 0.1)) + "s | " + str(stages["keller"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["keller"]["read_synthesis"] else "Pendente") + "\n"
	text += "6. [color=#ff8a65]Margaret Hamilton (1969):[/color] " + str(snapped(stages["margaret"]["time_spent"], 0.1)) + "s | " + str(stages["margaret"]["attempts"]) + " tent. | Síntese: " + ("Lida [OK]" if stages["margaret"]["read_synthesis"] else "Pendente") + "\n"
	text += "7. [color=#aed581]Epílogo Edith Ranzini (1972, Brasil):[/color] " + ("Concluído [OK]" if GameState.telemetry_data["edith_epilogue_viewed"] else "Não acessado") + "\n"

	label_metrics.text = text

func _build_report_dict() -> Dictionary:
	return {
		"timestamp": Time.get_datetime_string_from_system(),
		"participante": {
			"nome": GameState.player_name if not GameState.player_name.is_empty() else "Participante Anônimo",
			"cidade": GameState.player_city if not GameState.player_city.is_empty() else "Não informada"
		},
		"total_score": GameState.player_score,
		"pre_survey": GameState.telemetry_data["pre_survey"],
		"stages_telemetry": GameState.telemetry_data["stages"],
		"edith_epilogue_viewed": GameState.telemetry_data["edith_epilogue_viewed"],
		"post_test_answers": {
			"compreendeu_relacao_moderna": q1_check.button_pressed,
			"percepcao_ods05_mulheres_ti": q2_check.button_pressed,
			"metodologia_facilitou_aprendizagem": q3_check.button_pressed,
			"valorizou_pioneirismo_brasileiro": q4_check.button_pressed
		}
	}

func _sanitize_filename(text: String) -> String:
	var clean = text.strip_edges()
	var invalid_chars = ["/", "\\", "?", "%", "*", ":", "|", "\"", "<", ">", ".", ";", ",", "'"]
	for ch in invalid_chars:
		clean = clean.replace(ch, "")
	clean = clean.replace(" ", "_")
	if clean.is_empty():
		clean = "anonimo"
	return clean

func _get_export_filename() -> String:
	var dt = Time.get_datetime_dict_from_system()
	var date_str = "%04d-%02d-%02d_%02dh%02d" % [dt.year, dt.month, dt.day, dt.hour, dt.minute]
	var safe_name = _sanitize_filename(GameState.player_name if not GameState.player_name.is_empty() else "Participante")
	var safe_city = _sanitize_filename(GameState.player_city if not GameState.player_city.is_empty() else "Cidade")
	return "Resposta_" + date_str + "_" + safe_name + "_" + safe_city + ".json"

func _append_to_csv(report: Dictionary, target_dir: String) -> void:
	var csv_path = target_dir.path_join("respostas_consolidadas.csv")
	var header = '"Data_Hora";"Nome";"Cidade";"Pontos";"Pre_Conhecia_Pioneiras";"Pre_Ja_Programou";"Ada_Tempo_s";"Ada_Tentativas";"Ada_Sintese";"ENIAC_Tempo_s";"ENIAC_Tentativas";"ENIAC_Sintese";"Grace_Tempo_s";"Grace_Tentativas";"Grace_Sintese";"Katherine_Tempo_s";"Katherine_Tentativas";"Katherine_Sintese";"Keller_Tempo_s";"Keller_Tentativas";"Keller_Sintese";"Margaret_Tempo_s";"Margaret_Tentativas";"Margaret_Sintese";"Edith_Epilogo";"Pos_Q1_Relacao_Moderna";"Pos_Q2_Percepcao_ODS5";"Pos_Q3_Metodologia_Facilitou";"Pos_Q4_Pioneirismo_Brasileiro"'
	
	var st = report["stages_telemetry"]
	var pre = report["pre_survey"]
	var pos = report["post_test_answers"]
	
	var row = [
		report["timestamp"],
		report["participante"]["nome"],
		report["participante"]["cidade"],
		str(report["total_score"]),
		"Sim" if pre.get("conhecimento_previo_pioneiras", false) else "Nao",
		"Sim" if pre.get("ja_programou_antes", false) else "Nao",
		str(snapped(st["ada"]["time_spent"], 0.1)),
		str(st["ada"]["attempts"]),
		"Sim" if st["ada"]["read_synthesis"] else "Nao",
		str(snapped(st["eniac"]["time_spent"], 0.1)),
		str(st["eniac"]["attempts"]),
		"Sim" if st["eniac"]["read_synthesis"] else "Nao",
		str(snapped(st["grace"]["time_spent"], 0.1)),
		str(st["grace"]["attempts"]),
		"Sim" if st["grace"]["read_synthesis"] else "Nao",
		str(snapped(st["katherine"]["time_spent"], 0.1)),
		str(st["katherine"]["attempts"]),
		"Sim" if st["katherine"]["read_synthesis"] else "Nao",
		str(snapped(st["keller"]["time_spent"], 0.1)),
		str(st["keller"]["attempts"]),
		"Sim" if st["keller"]["read_synthesis"] else "Nao",
		str(snapped(st["margaret"]["time_spent"], 0.1)),
		str(st["margaret"]["attempts"]),
		"Sim" if st["margaret"]["read_synthesis"] else "Nao",
		"Sim" if report["edith_epilogue_viewed"] else "Nao",
		"Sim" if pos.get("compreendeu_relacao_moderna", false) else "Nao",
		"Sim" if pos.get("percepcao_ods05_mulheres_ti", false) else "Nao",
		"Sim" if pos.get("metodologia_facilitou_aprendizagem", false) else "Nao",
		"Sim" if pos.get("valorizou_pioneirismo_brasileiro", false) else "Nao"
	]
	
	var csv_line = '"' + '";"'.join(row) + '"'
	
	var file: FileAccess
	if FileAccess.file_exists(csv_path):
		file = FileAccess.open(csv_path, FileAccess.READ_WRITE)
		if file:
			file.seek_end()
	else:
		file = FileAccess.open(csv_path, FileAccess.WRITE)
		if file:
			file.store_string(char(0xFEFF))
			file.store_line(header)
	
	if file:
		file.store_line(csv_line)
		file.close()

func _on_btn_copy_telemetry_pressed() -> void:
	AudioManager.play_click()
	var report = _build_report_dict()
	var json_str = JSON.stringify(report, "\t")
	DisplayServer.clipboard_set(json_str)
	var p_name = GameState.player_name if not GameState.player_name.is_empty() else "Participante"
	copy_feedback.text = "[OK] Dados completos de " + p_name + " copiados para a Área de Transferência (JSON)!"
	copy_feedback.modulate = Color(0.3, 1.0, 0.5)

func _on_btn_save_telemetry_pressed() -> void:
	AudioManager.play_click()
	var report = _build_report_dict()
	var json_str = JSON.stringify(report, "\t")
	var filename = _get_export_filename()
	
	DisplayServer.clipboard_set(json_str)
	
	# Se for Web (navegador), acionar download direto do arquivo
	if OS.has_feature("web"):
		var buffer = json_str.to_utf8_buffer()
		JavaScriptBridge.download_buffer(buffer, filename, "application/json")
		copy_feedback.text = "[OK] Download concluído: '" + filename + "' salvo na sua pasta de Downloads!"
		copy_feedback.modulate = Color(0.3, 1.0, 0.5)
		return
	
	# Se estiver executando localmente (Desktop / Editor)
	var saved_locally = false
	var target_candidates = [
		"D:/Mestrado/Jogos/Computer on the beach/Pioneiras&Alem/pioneiras&além/Resposta questionários",
		"D:/Mestrado/Jogos/Computer on the beach/Pioneiras&Alem/Resposta questionários",
		OS.get_executable_path().get_base_dir().path_join("Resposta questionários"),
		"user://Resposta questionários"
	]
	
	for target_dir in target_candidates:
		if not DirAccess.dir_exists_absolute(target_dir):
			DirAccess.make_dir_recursive_absolute(target_dir)
		
		if DirAccess.dir_exists_absolute(target_dir):
			var file_path = target_dir.path_join(filename)
			var file = FileAccess.open(file_path, FileAccess.WRITE)
			if file:
				file.store_string(json_str)
				file.close()
				saved_locally = true
				_append_to_csv(report, target_dir)
				break
	
	if saved_locally:
		copy_feedback.text = "[OK] Salvo em: Resposta questionários/" + filename + "\ne consolidado no Excel (CSV)!"
		copy_feedback.modulate = Color(0.3, 1.0, 0.5)
	else:
		copy_feedback.text = "[OK] Dados copiados com sucesso na Área de Transferência (JSON)!"
		copy_feedback.modulate = Color(0.3, 1.0, 0.5)

func _on_btn_play_again_pressed() -> void:
	AudioManager.play_click()
	GameState.player_score = 0
	GameState.go_to_stage(1)

