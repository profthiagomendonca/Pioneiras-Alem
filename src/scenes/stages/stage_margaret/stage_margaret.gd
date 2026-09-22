extends Control

@onready var dialogue_box = $DialogueBox
@onready var label_altitude: Label = %LabelAltitude
@onready var label_alarm: Label = %LabelAlarm
@onready var progress_cpu: ProgressBar = %ProgressCPU
@onready var tasks_container: VBoxContainer = %TasksContainer
@onready var label_status: Label = %LabelStatus
@onready var btn_priority_mode: Button = %BtnPriorityMode
@onready var btn_finish: Button = %BtnFinish
@onready var btn_menu: Button = %BtnMenu

var start_time: float = 0.0
var altitude_meters: float = 3000.0
var cpu_load: float = 115.0
var lunar_touchdown: bool = false
var pending_tasks: Array[Dictionary] = []

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("margaret")

	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Margaret_Hamilton.png")
	portrait_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HeaderPanel/Margin/HeaderBar.add_child(portrait_icon)
	$HeaderPanel/Margin/HeaderBar.move_child(portrait_icon, 0)

	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)

	btn_priority_mode.pressed.connect(_on_btn_land_pressed)
	btn_finish.pressed.connect(_on_btn_finish_pressed)
	btn_finish.hide()

	# Estado inicial completamente limpo - zero avanço automático
	lunar_touchdown = false
	altitude_meters = 3000.0
	cpu_load = 115.0
	progress_cpu.value = cpu_load
	label_altitude.text = "ALTITUDE LUNAR: 3000 m"
	label_alarm.text = "ALARME AGC 1202: SOBRECARGA CRÍTICA DE CPU (115%)"
	label_alarm.modulate = Color(1.0, 0.25, 0.25)
	label_status.text = "Identifique e descarte as 2 tarefas supérfluas para reduzir a sobrecarga da CPU."
	label_status.modulate = Color(1.0, 0.85, 0.4)

	btn_priority_mode.text = "Autorizar Pouso Lunar"
	btn_priority_mode.disabled = true
	btn_priority_mode.modulate = Color(0.7, 0.7, 0.7)

	_init_tasks()
	_start_intro_dialogue()

func _init_tasks() -> void:
	pending_tasks = [
		{
			"id": "motors",
			"name": "Motores de Descida DPS (Propulsão e desaceleração contínua)",
			"desc": "CRÍTICO: Desacelera a nave e impede colisão contra a superfície lunar.",
			"essential": true,
			"cpu": 35.0,
			"discarded": false
		},
		{
			"id": "inertial",
			"name": "Cálculo de Vetor Inercial (Trajetória e telemetria de altitude)",
			"desc": "CRÍTICO: Calcula a velocidade de aproximação e vetor de descida.",
			"essential": true,
			"cpu": 30.0,
			"discarded": false
		},
		{
			"id": "radar",
			"name": "Radar de Rendezvous (Chave ligada por engano na cabine)",
			"desc": "SUPÉRFLUO: Usado apenas para acoplamento na órbita, inútil durante o pouso!",
			"essential": false,
			"cpu": 35.0,
			"discarded": false
		},
		{
			"id": "telemetry",
			"name": "Telemetria Secundária de Cabine (Sensores ambientais internos)",
			"desc": "SUPÉRFLUO: Diagnósticos de cabine secundários que não afetam a descida.",
			"essential": false,
			"cpu": 15.0,
			"discarded": false
		}
	]

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Aqui é Margaret Hamilton, diretora de Engenharia de Software do MIT para o Projeto Apollo. O Módulo Lunar está a 3000 metros da superfície da Lua!"
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "ALERTA! O computador de bordo (AGC) disparou o Alarme 1202! O radar de acoplamento foi deixado ligado por engano e está inundando a CPU de requisições: a carga atingiu 115%!"
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Se a CPU travar, a missão será perdida! Use os princípios do meu software de 'Agendamento por Prioridade': analise os 4 processos abaixo e descarte os 2 supérfluos para autorizar o pouso!"
		}
	]
	dialogue_box.start_dialogue(lines)
	dialogue_box.dialogue_finished.connect(func():
		_render_task_list()
	, CONNECT_ONE_SHOT)

func _render_task_list() -> void:
	for child in tasks_container.get_children():
		child.queue_free()

	for task in pending_tasks:
		var panel = PanelContainer.new()
		var style = StyleBoxFlat.new()
		style.set_corner_radius_all(6)
		style.set_content_margin_all(8)

		if task["discarded"]:
			style.bg_color = Color(0.08, 0.08, 0.1, 0.5)
			style.border_color = Color(0.3, 0.3, 0.35, 0.5)
			style.set_border_width_all(1)
		elif task["essential"]:
			style.bg_color = Color(0.09, 0.11, 0.16, 0.85)
			style.border_color = Color(0.3, 0.55, 0.9, 0.6)
			style.set_border_width_all(1)
		else:
			style.bg_color = Color(0.12, 0.1, 0.08, 0.85)
			style.border_color = Color(1.0, 0.6, 0.2, 0.7)
			style.set_border_width_all(1)

		panel.add_theme_stylebox_override("panel", style)

		var hbox = HBoxContainer.new()
		hbox.theme_override_constants.separation = 12
		panel.add_child(hbox)

		var vbox_info = VBoxContainer.new()
		vbox_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_info.theme_override_constants.separation = 2

		var lbl_title = Label.new()
		var lbl_desc = Label.new()
		lbl_desc.add_theme_font_size_override("font_size", 12)

		if task["discarded"]:
			lbl_title.text = "[DESCARTADO] " + task["name"]
			lbl_title.modulate = Color(0.5, 0.5, 0.55)
			lbl_desc.text = "Processo interrompido pelo agendador de prioridade."
			lbl_desc.modulate = Color(0.4, 0.4, 0.45)
		else:
			var tag = "[VITAL] " if task["essential"] else "[ALERTA] "
			lbl_title.text = tag + task["name"] + " (Carga: +" + str(int(task["cpu"])) + "%)"
			lbl_title.modulate = Color(0.85, 0.95, 1.0) if task["essential"] else Color(1.0, 0.8, 0.4)
			lbl_desc.text = task["desc"]
			lbl_desc.modulate = Color(0.7, 0.8, 0.9) if task["essential"] else Color(1.0, 0.7, 0.5)

		vbox_info.add_child(lbl_title)
		vbox_info.add_child(lbl_desc)
		hbox.add_child(vbox_info)

		var btn_action = Button.new()
		btn_action.custom_minimum_size = Vector2(170, 36)
		btn_action.size_flags_vertical = Control.SIZE_SHRINK_CENTER

		if task["discarded"]:
			btn_action.text = "Descartado [OK]"
			btn_action.disabled = true
		else:
			btn_action.text = "Descartar Processo"
			btn_action.pressed.connect(func():
				_on_task_discard_pressed(task)
			)
		hbox.add_child(btn_action)
		tasks_container.add_child(panel)

func _on_task_discard_pressed(task: Dictionary) -> void:
	if lunar_touchdown:
		return

	if task["essential"]:
		AudioManager.play_error()
		label_status.text = "Atenção: Os motores e o vetor inercial são vitais! Margaret projetou o AGC para NUNCA descartá-los!"
		label_status.modulate = Color(1.0, 0.35, 0.35)
		return

	AudioManager.play_success()
	task["discarded"] = true
	cpu_load = max(55.0, cpu_load - task["cpu"])
	progress_cpu.value = cpu_load
	_render_task_list()
	_check_system_status()

func _check_system_status() -> void:
	var superfluous_remaining: int = 0
	for task in pending_tasks:
		if not task["essential"] and not task["discarded"]:
			superfluous_remaining += 1

	if superfluous_remaining == 0:
		# Sistema totalmente estabilizado
		label_alarm.text = "[ESTÁVEL] AGC OPERANDO COM PRIORIDADE (CARGA SEGURA: 65%)"
		label_alarm.modulate = Color(0.3, 1.0, 0.5)
		label_status.text = "Excelente! Tarefas supérfluas eliminadas. Clique em 'Autorizar Pouso Lunar' para iniciar a descida final!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_priority_mode.disabled = false
		btn_priority_mode.text = "Autorizar Pouso Lunar (Apollo 11)"
		btn_priority_mode.modulate = Color(0.4, 1.0, 0.6)
	else:
		label_status.text = "Processo supérfluo descartado! Carga do AGC caiu para " + str(int(cpu_load)) + "%. Descarte mais 1 processo."
		label_status.modulate = Color(0.4, 0.9, 1.0)

func _on_btn_land_pressed() -> void:
	if lunar_touchdown:
		return

	var superfluous_remaining: int = 0
	for task in pending_tasks:
		if not task["essential"] and not task["discarded"]:
			superfluous_remaining += 1

	if superfluous_remaining > 0:
		AudioManager.play_error()
		label_status.text = "Impossível pousar com sobrecarga na CPU (" + str(int(cpu_load)) + "%)! Descarte os processos supérfluos primeiro."
		label_status.modulate = Color(1.0, 0.35, 0.35)
		return

	AudioManager.play_click()
	lunar_touchdown = true
	btn_priority_mode.disabled = true
	btn_priority_mode.modulate = Color(0.6, 0.6, 0.6)
	label_status.text = "Iniciando queima final dos motores DPS... Módulo Lunar em descida controlada!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var tween = create_tween()
	tween.tween_method(func(val: float):
		altitude_meters = val
		label_altitude.text = "ALTITUDE LUNAR: " + str(int(val)) + " m"
	, 3000.0, 0.0, 2.5)
	tween.finished.connect(_complete_landing)

func _complete_landing() -> void:
	AudioManager.play_success()
	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("margaret", duration, 300)
	GameState.unlock_next_stage(6)

	label_altitude.text = "LUA ALCANÇADA: 0 m — POUSO CONFIRMADO!"
	label_status.text = "'Houston, Tranquility Base here. The Eagle has landed!' Pouso realizado com sucesso graças ao software!"
	label_status.modulate = Color(0.3, 1.0, 0.5)
	btn_finish.show()

	var win_lines: Array[Dictionary] = [
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "O Módulo Lunar pousou em segurança no Mar da Tranquilidade! Neil Armstrong e Buzz Aldrin estão salvos na Lua."
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Eu criei o próprio termo 'Engenharia de Software' para exigir o mesmo respeito concedido a outras engenharias. O código não era mero acessório: ele tornou o impossível realidade!"
		}
	]
	dialogue_box.start_dialogue(win_lines)

func _on_btn_finish_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_victory()
