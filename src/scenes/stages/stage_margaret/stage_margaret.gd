extends Control

@onready var dialogue_box = $DialogueBox
@onready var label_altitude: Label = %LabelAltitude
@onready var label_alarm: Label = %LabelAlarm
@onready var progress_cpu: ProgressBar = %ProgressCPU
@onready var tasks_container: VBoxContainer = %TasksContainer
@onready var label_status: Label = %LabelStatus
@onready var btn_priority_mode: Button = %BtnPriorityMode
@onready var btn_finish: Button = %BtnFinish
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var btn_menu: Button = %BtnMenu

var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null

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

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	# Instanciar modal de síntese
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

	# Estado inicial
	lunar_touchdown = false
	altitude_meters = 3000.0
	cpu_load = 130.0
	progress_cpu.value = cpu_load
	label_altitude.text = "ALTITUDE LUNAR: 3000 m"
	label_alarm.text = "ALARME 1202: SOBRECARGA DE PROCESSAMENTO (130%)"
	label_alarm.modulate = Color(1.0, 0.25, 0.25)
	label_status.text = "Triagem Crítica: Analise cada sistema e descarte os que não afetam o pouso imediato até atingir carga segura (<= 85%)!"
	label_status.modulate = Color(1.0, 0.85, 0.4)

	btn_priority_mode.text = "Autorizar Pouso Lunar"
	btn_priority_mode.disabled = true
	btn_priority_mode.modulate = Color(0.7, 0.7, 0.7)

	_init_tasks()
	_start_intro_dialogue()

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _init_tasks() -> void:
	pending_tasks = [
		{
			"id": "motors",
			"name": "Propulsão Principal dos Motores de Descida (DPS)",
			"desc": "Controla a aceleração e queima do motor foguete para frear a queda da nave em direção ao solo lunar.",
			"essential": true,
			"cpu": 35.0,
			"discarded": false
		},
		{
			"id": "inertial",
			"name": "Controle de Atitude e Estabilidade de Voo (RCS)",
			"desc": "Aciona micropropulsores de manobra para manter a cabine nivelada e impedir que o módulo tombe de lado.",
			"essential": true,
			"cpu": 25.0,
			"discarded": false
		},
		{
			"id": "landing_radar",
			"name": "Radar de Altimetria e Velocidade de Toque no Solo",
			"desc": "Mede em tempo real a altitude exata em metros até a superfície para amortecer o toque no chão.",
			"essential": true,
			"cpu": 15.0,
			"discarded": false
		},
		{
			"id": "life_support",
			"name": "Monitoramento de Oxigênio e Pressurização da Cabine",
			"desc": "Regula a circulação contínua de ar respirável e pressão interna para os trajes espaciais da tripulação.",
			"essential": true,
			"cpu": 10.0,
			"discarded": false
		},
		{
			"id": "rendezvous_radar",
			"name": "Radar de Rastreio da Nave-Mãe Columbia em Órbita",
			"desc": "Localiza a nave em órbita lunar alta. Acionado por engano por uma chave de hardware com defeito.",
			"essential": false,
			"cpu": 25.0,
			"discarded": false
		},
		{
			"id": "earth_reentry",
			"name": "Cálculo de Trajetória de Retorno à Terra (Próxima Semana)",
			"desc": "Simula a curva de reentrada no Oceano Pacífico para o resgate que ocorrerá após o fim da missão lunar.",
			"essential": false,
			"cpu": 20.0,
			"discarded": false
		}
	]
	_render_tasks()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Houston, temos uma emergência crítica! Faltam apenas 3 minutos para a Apollo 11 pousar na Lua e um radar acionado por engano disparou o Alarme 1202: 130% de sobrecarga!"
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Em vez de deixar o computador travar, eu projetei a Arquitetura com Prioridade. Precisamos identificar e descartar os processos secundários que podem esperar, mantendo apenas os vitais para o pouso!"
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Seu desafio: analise a função de cada subsistema e descarte os não essenciais até a carga da CPU baixar para 85% ou menos. Se você desativar um sistema vital por engano, a nave não pousará em segurança!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _render_tasks() -> void:
	for child in tasks_container.get_children():
		child.queue_free()

	for i in range(pending_tasks.size()):
		var task = pending_tasks[i]
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 10)

		var btn_task = Button.new()
		btn_task.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_task.custom_minimum_size = Vector2(0, 34)
		btn_task.text = task["name"] + " (" + str(int(task["cpu"])) + "% da CPU)"
		btn_task.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn_task.tooltip_text = task["desc"]

		if task["discarded"]:
			btn_task.modulate = Color(0.5, 0.5, 0.5, 0.5)
			btn_task.text = "[ DESATIVADO ] " + task["name"]
		else:
			btn_task.modulate = Color(1, 1, 1, 1)

		btn_task.pressed.connect(func():
			label_status.text = task["desc"]
			label_status.modulate = Color(1.0, 0.85, 0.4)
		)
		hbox.add_child(btn_task)

		var btn_toggle = Button.new()
		btn_toggle.custom_minimum_size = Vector2(130, 32)
		if task["discarded"]:
			btn_toggle.text = "Reativar"
			btn_toggle.modulate = Color(0.6, 0.8, 1.0)
		else:
			btn_toggle.text = "Descartar"
			btn_toggle.modulate = Color(1.0, 0.5, 0.5)

		btn_toggle.pressed.connect(_toggle_task.bind(i))
		hbox.add_child(btn_toggle)

		tasks_container.add_child(hbox)

func _toggle_task(idx: int) -> void:
	AudioManager.play_click()
	var task = pending_tasks[idx]
	task["discarded"] = not task["discarded"]

	# Recalcular carga de CPU partindo de 130%
	var current_cpu = 130.0
	for t in pending_tasks:
		if t["discarded"]:
			current_cpu -= t["cpu"]

	cpu_load = max(0.0, current_cpu)
	progress_cpu.value = cpu_load

	if cpu_load <= 85.0:
		label_alarm.text = "STATUS AGC: CARGA SEGURA (" + str(int(cpu_load)) + "%) — PRIORIDADE DE POUSO ATIVA"
		label_alarm.modulate = Color(0.3, 1.0, 0.5)
		label_status.text = "Sobrecarga contida com sucesso! A CPU agora prioriza 100% da atenção no módulo de descida."
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_priority_mode.disabled = false
		btn_priority_mode.modulate = Color(0.3, 1.0, 0.5)
	else:
		label_alarm.text = "ALARME 1202: SOBRECARGA (" + str(int(cpu_load)) + "%)"
		label_alarm.modulate = Color(1.0, 0.25, 0.25)
		label_status.text = "A CPU ainda está sobrecarregada (" + str(int(cpu_load)) + "%). Descarte outros processos que não afetam o pouso imediato."
		label_status.modulate = Color(1.0, 0.7, 0.3)
		btn_priority_mode.disabled = true
		btn_priority_mode.modulate = Color(0.7, 0.7, 0.7)

	_render_tasks()

func _on_btn_land_pressed() -> void:
	# Checar se alguma tarefa essencial foi descartada por engano
	for t in pending_tasks:
		if t["essential"] and t["discarded"]:
			AudioManager.play_error()
			label_status.text = "FALHA CRÍTICA: Você desativou '" + t["name"] + "'! Sem esse sistema vital, os astronautas não sobrevivem ao pouso. Reative-o e descarte processos que não afetam a descida imediata!"
			label_status.modulate = Color(1.0, 0.2, 0.2)
			return

	AudioManager.play_success()
	btn_priority_mode.disabled = true
	label_status.text = "Pouso autorizado! O computador priorizou 100% dos recursos nos motores de descida..."
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
	label_status.text = "Desafio Concluído! 'Houston, aqui Base da Tranqüilidade. O Eagle pousou!' Pouso realizado graças à sua priorização de software!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var win_lines: Array[Dictionary] = [
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "O Módulo Lunar pousou em segurança no solo da Lua! Neil Armstrong e Buzz Aldrin estão sãos e salvos."
		},
		{
			"speaker": "Margaret Hamilton (1969)",
			"color": Color(0.95, 0.45, 0.45),
			"text": "Veja agora no nosso Cartão de Conquista como a Engenharia de Software nasceu dessa missão, e em seguida vamos conhecer o Epílogo Especial sobre a pioneira brasileira Edith Ranzini!"
		}
	]
	dialogue_box.start_dialogue(win_lines)
	dialogue_box.dialogue_finished.connect(func():
		synthesis_modal.show_synthesis(_get_synthesis_data(), true)
	, CONNECT_ONE_SHOT)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 6: Margaret Hamilton (1969)",
		"pioneer_text": "[b][color=#ffd54f]Quem foi a pioneira?[/color][/b]\nMargaret Heafield Hamilton (1936–presente) é matemática, cientista da computação e empresária. Liderou a equipe do Laboratório do MIT que programou o computador de bordo das naves Apollo.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5):[/color][/b]\nNa década de 1960, a programação de software era tratada com desdém por engenheiros homens de hardware, que a chamavam pejorativamente de 'trabalho de digitação'. Margaret lutou com rigor e firmeza para provar que criar software é uma disciplina de engenharia tão complexa e nobre quanto construir motores, criando o termo [b]'Engenharia de Software'[/b].",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nEla inventou a [b]Arquitetura com Prioridade[/b] do computador da Apollo 11.\n\nQuando o radar defeituoso entupiu a máquina com alarmes segundos antes do pouso, o software de Margaret tomou a decisão inteligente: descartou tarefas menores e manteve 100% da atenção no motor que evitava a queda na Lua!",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]A Triagem de Emergência no Computador (Prioridade):[/b]\nNenhum computador tem memória infinita. Quando milhares de coisas acontecem ao mesmo tempo, a máquina precisa de regras claras:\n• [b]Tarefas Vitais (Prioridade Máxima):[/b] O que mantém a vida humana ou a missão funcionando;\n• [b]Tarefas Secundárias:[/b] Coisas que podem esperar ou ser desligadas sem prejuízo.",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nQuando o seu celular recebe 10 notificações ao mesmo tempo enquanto você atende uma ligação de emergência, ele não trava porque usa o mesmo princípio de prioridade criado por Margaret Hamilton!\n\nAparelhos médicos de UTI, aviões comerciais e carros modernos só são confiáveis graças à Engenharia de Software."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("margaret")
		btn_finish.show()
		btn_finish.text = "Avançar para o Epílogo Brasileiro (Edith Ranzini) >"
		label_status.text = "Síntese consolidada! Clique no botão abaixo para conhecer o pioneirismo brasileiro de Edith Ranzini."

func _on_btn_finish_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_epilogue()
