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
	{"name": "Propulsores de Descida (Motores DPS)", "prio": "ALTA", "cpu": 35.0, "essential": true},
	{"name": "Cálculo de Vetor de Pouso Inercial", "prio": "ALTA", "cpu": 30.0, "essential": true},
	{"name": "Radar de Acoplamento (Sobrecarga de Interrupção!)", "prio": "BAIXA", "cpu": 40.0, "essential": false},
	{"name": "Log de Telemetria de Cabine Não-Crítica", "prio": "BAIXA", "cpu": 15.0, "essential": false}
]

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("margaret")
	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)
	btn_priority_mode.pressed.connect(_on_btn_priority_mode_pressed)
	btn_finish.pressed.connect(_on_btn_finish_pressed)
	btn_finish.hide()

	_start_intro_dialogue()

func _process(delta: float) -> void:
	if is_landing_active and not lunar_touchdown:
		# Altitude descendo
		altitude_meters = max(0.0, altitude_meters - delta * 200.0)
		label_altitude.text = "ALTITUDE LUNAR: " + str(int(altitude_meters)) + " m"

		if not priority_scheduling_enabled:
			# CPU oscila criticamente no limite
			cpu_load = min(100.0, cpu_load + delta * 3.0)
			progress_cpu.value = cpu_load
			label_alarm.text = "ALARME AGC 1202: SOBRECARGA DE CPU (" + str(int(cpu_load)) + "%)"
			label_alarm.modulate = Color(1.0, 0.2, 0.2)
		else:
			# Sobrecarga mitigada pela prioridade de Margaret
			cpu_load = max(62.0, cpu_load - delta * 15.0)
			progress_cpu.value = cpu_load
			label_alarm.text = "[OK] AGC ESTÁVEL: TAREFAS CRÍTICAS PRIORIZADAS (" + str(int(cpu_load)) + "%)"
			label_alarm.modulate = Color(0.3, 1.0, 0.5)

		if altitude_meters <= 0.0:
			_complete_landing()

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
			"text": "O computador de bordo do Módulo Lunar (AGC) está disparando os alarmes 1201 e 1202! O radar de acoplamento foi deixado na posição incorreta e está inundando a CPU com interrupções."
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Felizmente, eu criei a arquitetura de 'Agendamento Assíncrono por Prioridade'. Ative nosso sistema de prioridade para eliminar as tarefas inúteis e salvar a missão Apollo 11!"
		}
	]
	dialogue_box.start_dialogue(lines)
	dialogue_box.dialogue_finished.connect(func():
		is_landing_active = true
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
		lbl.text = "[" + task["prio"] + "] " + task["name"] + " (" + str(task["cpu"]) + "% CPU)"
		hbox.add_child(lbl)

		if not task["essential"]:
			var btn_drop = Button.new()
			btn_drop.text = "Descartar Tarefa"
			btn_drop.pressed.connect(func():
				AudioManager.play_click()
				task["prio"] = "DESCARTADA"
				lbl.text = "[DESCARTADA] " + task["name"]
				lbl.modulate = Color(0.5, 0.5, 0.5)
				btn_drop.disabled = true
				_evaluate_tasks()
			)
			hbox.add_child(btn_drop)

		tasks_container.add_child(panel)

func _evaluate_tasks() -> void:
	var non_essential_cleared = true
	for task in pending_tasks:
		if not task["essential"] and task["prio"] != "DESCARTADA":
			non_essential_cleared = false
			break

	if non_essential_cleared:
		priority_scheduling_enabled = true
		AudioManager.play_success()
		label_status.text = "Excelente! Interrupções desnecessárias foram descartadas pelo agendador do AGC!"
		label_status.modulate = Color(0.3, 1.0, 0.5)

func _on_btn_priority_mode_pressed() -> void:
	AudioManager.play_click()
	# Ativa o modo de prioridade global de Hamilton
	for task in pending_tasks:
		if not task["essential"]:
			task["prio"] = "DESCARTADA"
	_render_task_list()
	priority_scheduling_enabled = true
	AudioManager.play_success()
	label_status.text = "Modo de Prioridade de Margaret Hamilton ativado! O AGC agora processa exclusivamente o pouso."
	label_status.modulate = Color(0.3, 1.0, 0.5)

func _complete_landing() -> void:
	lunar_touchdown = true
	AudioManager.play_success()
	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("margaret", duration, 300)
	GameState.unlock_next_stage(6)

	label_altitude.text = "LUA ALCANÇADA: 0 m — POUSO CONFIRMADO!"
	label_status.text = "'Houston, Tranquility Base here. The Eagle has landed!' Missão salva pelo software!"
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
			"text": "Eu criei o próprio termo 'Engenharia de Software' para exigir o mesmo respeito concedido a outras engenharias. O código não era acessório: ele tornou o impossível realidade!"
		}
	]
	dialogue_box.start_dialogue(win_lines)

func _on_btn_finish_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_victory()
