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
var cpu_load: float = 85.0
var is_landing_active: bool = false
var priority_scheduling_enabled: bool = false
var lunar_touchdown: bool = false

var pending_tasks = [
	{"name": "Propulsores de Descida (Motores DPS)", "prio": "CRÍTICA", "cpu": 35.0, "essential": true},
	{"name": "Cálculo de Vetor de Pouso Inercial", "prio": "CRÍTICA", "cpu": 30.0, "essential": true},
	{"name": "Radar de Rendezvous (Chave na posição errada!)", "prio": "SUPÉRFLUA", "cpu": 35.0, "essential": false},
	{"name": "Telemetria Secundária de Cabine", "prio": "SUPÉRFLUA", "cpu": 15.0, "essential": false}
]

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
	btn_priority_mode.pressed.connect(_on_btn_priority_mode_pressed)
	btn_finish.pressed.connect(_on_btn_finish_pressed)
	btn_finish.hide()

	progress_cpu.value = 115.0
	label_alarm.text = "ALARME AGC 1202: SOBRECARGA DE CPU (115%)"
	label_alarm.modulate = Color(1.0, 0.2, 0.2)
	label_status.text = "Identifique os 2 processos que NÃO são essenciais para o pouso e clique em Descartar."

	_start_intro_dialogue()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Aqui é Margaret Hamilton, diretora de Engenharia de Software do MIT para o Programa Apollo. Estamos a menos de 3 minutos do pouso na Lua!"
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "O computador de bordo do Módulo Lunar (AGC) disparou o Alarme 1202! O radar de acoplamento foi deixado ligado por engano e está inundando a CPU de interrupções (115% de carga)."
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Para evitar que a nave caia, meu software de 'Agendamento por Prioridade' precisa descartar as tarefas inúteis e focar apenas nos motores e na trajetória de pouso. Remova as tarefas supérfluas!"
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
		var hbox = HBoxContainer.new()
		panel.add_child(hbox)

		var lbl = Label.new()
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if task["prio"] == "DESCARTADA":
			lbl.text = "[DESCARTADA] " + task["name"]
			lbl.modulate = Color(0.5, 0.5, 0.5)
		else:
			var tag = "[ESSENCIAL] " if task["essential"] else "[SUPÉRFLUA] "
			lbl.text = tag + task["name"] + " (Carga: +" + str(int(task["cpu"])) + "%)"
			lbl.modulate = Color(0.9, 0.95, 1.0) if task["essential"] else Color(1.0, 0.75, 0.4)
		hbox.add_child(lbl)

		var btn_action = Button.new()
		btn_action.custom_minimum_size = Vector2(170, 36)
		if task["prio"] == "DESCARTADA":
			btn_action.text = "Descartado [OK]"
			btn_action.disabled = true
		else:
			btn_action.text = "Descartar Processo"
			btn_action.pressed.connect(func():
				if not task["essential"]:
					AudioManager.play_success()
					task["prio"] = "DESCARTADA"
					cpu_load = max(55.0, cpu_load - task["cpu"])
					progress_cpu.value = cpu_load
					label_status.text = "Processo supérfluo descartado! Carga do AGC caiu para " + str(int(cpu_load)) + "%."
					label_status.modulate = Color(0.4, 0.9, 1.0)
					_render_task_list()
					_evaluate_system()
				else:
					AudioManager.play_error()
					label_status.text = "Atenção: Processos vitais (motores e navegação) não podem ser desligados!"
					label_status.modulate = Color(1.0, 0.35, 0.35)
			)
		hbox.add_child(btn_action)
		tasks_container.add_child(panel)

func _evaluate_system() -> void:
	var superfluous_remaining = 0
	for task in pending_tasks:
		if not task["essential"] and task["prio"] != "DESCARTADA":
			superfluous_remaining += 1

	if superfluous_remaining == 0:
		_trigger_landing_success()

func _on_btn_priority_mode_pressed() -> void:
	AudioManager.play_click()
	for task in pending_tasks:
		if not task["essential"]:
			task["prio"] = "DESCARTADA"
	cpu_load = 55.0
	progress_cpu.value = cpu_load
	_render_task_list()
	label_status.text = "Agendamento por Prioridade de Margaret Hamilton ativado! Tarefas supérfluas eliminadas automaticamente."
	label_status.modulate = Color(0.3, 1.0, 0.5)
	_trigger_landing_success()

func _trigger_landing_success() -> void:
	if lunar_touchdown:
		return
	lunar_touchdown = true
	priority_scheduling_enabled = true
	btn_priority_mode.disabled = true

	label_alarm.text = "[OK] AGC ESTABILIZADO: TAREFAS CRÍTICAS PRIORIZADAS (55%)"
	label_alarm.modulate = Color(0.3, 1.0, 0.5)
	progress_cpu.value = 55.0

	var tween = create_tween()
	tween.tween_method(func(val: float):
		label_altitude.text = "ALTITUDE LUNAR: " + str(int(val)) + " m"
	, 3000.0, 0.0, 2.0)
	tween.finished.connect(_complete_landing)

func _complete_landing() -> void:
	AudioManager.play_success()
	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("margaret", duration, 300)
	GameState.unlock_next_stage(6)

	label_altitude.text = "LUA ALCANÇADA: 0 m — POUSO CONFIRMADO!"
	label_status.text = "'Houston, Tranquility Base here. The Eagle has landed!' Pouso realizado com sucesso!"
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
