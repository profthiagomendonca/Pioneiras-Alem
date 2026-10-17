extends Control

@onready var dialogue_box = $DialogueBox
@onready var relays_grid: GridContainer = %RelaysGrid
@onready var compiler_panel: PanelContainer = %CompilerPanel
@onready var label_status: Label = %LabelStatus
@onready var bug_info_label: RichTextLabel = %BugInfoLabel
@onready var moth_icon_rect: TextureRect = %MothIconRect
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var btn_menu: Button = %BtnMenu

var moth_texture = preload("res://src/assets/textures/icons/mariposa.png")

var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null

var start_time: float = 0.0
var bug_found: bool = false
var compiler_step_completed: bool = false
var moth_relay_index: int = 4

# Pares de compilação: A metáfora do 'Tradutor' entre a nossa língua e os circuitos da máquina
var compiler_pairs = [
	{
		"high": "1. 'SUBTRAIR DESPESA DO SALÁRIO'\n(Como a gente fala no dia a dia)",
		"code": "[SUBTRAIR CONTA DA GAVETA_SALARIO]\n(Ação que a máquina executa)",
		"explanation": "Tradução Perfeita! O tradutor de Grace transformou uma frase em linguagem humana no comando exato para a máquina diminuir o valor e guardar o troco na gaveta da memória!",
		"paired": false
	},
	{
		"high": "2. 'SE SALDO FOR MENOR QUE ZERO, AVISAR'\n(Regra de Decisão com 'SE')",
		"code": "[SE SALDO < 0, PULAR PARA O ALARME]\n(Ação que a máquina executa)",
		"explanation": "Tradução Perfeita! O tradutor converteu a regra humana em uma checagem elétrica: se faltar dinheiro, o computador aciona o sinal de alerta automaticamente!",
		"paired": false
	},
	{
		"high": "3. 'IMPRIMIR O RECIBO DO CLIENTE'\n(Pedido de Saída de Informação)",
		"code": "[ACIONAR MOTOR DA IMPRESSORA]\n(Ação que a máquina executa)",
		"explanation": "Tradução Perfeita! Uma palavra comum em nossa língua acionou o rolo mecânico da impressora para entregar a folha pronta ao usuário!",
		"paired": false
	}
]
var selected_high_btn: Button = null

func _ready() -> void:
	randomize()
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("grace")
	moth_relay_index = randi() % 8
	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Grace_Hopper.png")
	portrait_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HeaderPanel/Margin/HeaderBar.add_child(portrait_icon)
	$HeaderPanel/Margin/HeaderBar.move_child(portrait_icon, 0)

	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)
	btn_next_stage.pressed.connect(_on_btn_next_stage_pressed)
	btn_next_stage.hide()
	compiler_panel.hide()
	moth_icon_rect.hide()

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	# Instanciar modal de síntese
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

	_setup_relays()
	_start_intro_dialogue()

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Olá! Sou Grace Hopper, matemática, oficial da Marinha dos EUA e cientista da computação. Estamos no laboratório do Harvard Mark II, uma máquina repleta de chavinhas elétricas chamadas relés."
		},
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Nossa máquina parou de responder subitamente! Algo físico travou a passagem da corrente. Clique nas chavinhas para inspecionar os circuitos e encontrar o que está bloqueando a máquina!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_relays() -> void:
	for i in range(8):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(110, 68)
		btn.text = "Chave #" + str(70 + i) + "\n[ Testar ]"
		btn.pressed.connect(_on_relay_clicked.bind(i, btn))
		relays_grid.add_child(btn)

func _on_relay_clicked(idx: int, btn: Button) -> void:
	if bug_found:
		return

	if idx == moth_relay_index:
		AudioManager.play_success()
		bug_found = true
		btn.text = "Chave #" + str(70 + idx) + "\n[ ! MARIPOSA ! ]"
		btn.modulate = Color(1.0, 0.8, 0.2)
		moth_icon_rect.show()
		
		bug_info_label.text = "[color=#fbc02d][b]Origem Histórica do 'Bug':[/b] Uma mariposa de verdade entrou no circuito da Chave #" + str(70 + idx) + " e bloqueou o contato elétrico! Grace colou o inseto no caderno oficial com a frase: 'Primeiro caso real de inseto (bug) encontrado'. Daí nasceu o termo 'Debug' para caçar erros![/color]"
		label_status.text = "Inseto localizado com sucesso! Agora vamos ao segundo passo: A invenção do Compilador."
		label_status.modulate = Color(0.3, 1.0, 0.5)

		var moth_dialogue: Array[Dictionary] = [
			{
				"speaker": "Grace Hopper (1947)",
				"color": Color(0.3, 0.7, 0.9),
				"text": "Incrível! Encontramos o 'bug'! Mas meu maior legado foi resolver um problema ainda maior: por que forçar humanos a falar em números estranhos se os computadores podem aprender a nossa língua?"
			},
			{
				"speaker": "Grace Hopper (1947)",
				"color": Color(0.3, 0.7, 0.9),
				"text": "Criei o 'Compilador': um tradutor automático que transforma frases em linguagem humana em ações executáveis pela máquina. Experimente a tradução logo abaixo!"
			}
		]
		dialogue_box.start_dialogue(moth_dialogue)
		dialogue_box.dialogue_finished.connect(_setup_compiler_step, CONNECT_ONE_SHOT)
	else:
		AudioManager.play_click()
		btn.text = "Chave #" + str(70 + idx) + "\n[ Normal ]"
		btn.disabled = true
		btn.modulate = Color(0.5, 0.6, 0.7)
		label_status.text = "Chave #" + str(70 + idx) + " operando normalmente. O contato elétrico está limpo. Teste outra!"
		label_status.modulate = Color(0.8, 0.8, 0.9)

func _setup_compiler_step() -> void:
	compiler_panel.show()
	label_status.text = "Fase do Compilador: Selecione a frase humana à esquerda e ligue-a à ação correspondente do computador à direita."
	label_status.modulate = Color(0.95, 0.85, 0.3)

	var high_container = %HighLevelContainer
	var low_container = %LowLevelContainer

	for child in high_container.get_children():
		child.queue_free()
	for child in low_container.get_children():
		child.queue_free()

	var high_indices = [0, 1, 2]
	high_indices.shuffle()
	var low_indices = [0, 1, 2]
	low_indices.shuffle()

	for idx in high_indices:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(400, 52)
		btn.text = compiler_pairs[idx]["high"]
		btn.set_meta("pair_index", idx)
		btn.pressed.connect(_on_high_btn_pressed.bind(btn))
		high_container.add_child(btn)

	for idx in low_indices:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(400, 52)
		btn.text = compiler_pairs[idx]["code"]
		btn.set_meta("pair_index", idx)
		btn.pressed.connect(_on_low_btn_pressed.bind(btn))
		low_container.add_child(btn)

func _on_high_btn_pressed(btn: Button) -> void:
	AudioManager.play_card()
	if selected_high_btn and selected_high_btn != btn:
		selected_high_btn.modulate = Color(1, 1, 1)

	selected_high_btn = btn
	btn.modulate = Color(1.0, 0.9, 0.3)
	label_status.text = "Frase humana selecionada! Agora escolha à direita qual ação o computador deve executar."

func _on_low_btn_pressed(btn: Button) -> void:
	if selected_high_btn == null:
		label_status.text = "Selecione primeiro uma frase humana na coluna da esquerda!"
		return

	var high_idx = selected_high_btn.get_meta("pair_index")
	var low_idx = btn.get_meta("pair_index")

	if high_idx == low_idx:
		AudioManager.play_success()
		compiler_pairs[high_idx]["paired"] = true
		selected_high_btn.disabled = true
		selected_high_btn.modulate = Color(0.3, 1.0, 0.5)
		btn.disabled = true
		btn.modulate = Color(0.3, 1.0, 0.5)
		
		bug_info_label.text = "[color=#a3be8c][b]Resultado da Tradução:[/b] " + compiler_pairs[high_idx]["explanation"] + "[/color]"
		label_status.text = "Tradução concluída! O compilador ensinou a máquina a entender você."
		label_status.modulate = Color(0.4, 1.0, 0.5)
		selected_high_btn = null
		_check_compiler_completion()
	else:
		AudioManager.play_error()
		label_status.text = "Ação incompatível: Essa ordem da máquina faz outra coisa. Leia as duas opções com atenção!"
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _check_compiler_completion() -> void:
	for pair in compiler_pairs:
		if not pair["paired"]:
			return

	compiler_step_completed = true
	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("grace", duration, 200)
	GameState.unlock_next_stage(3)

	label_status.text = "Desafio Concluído! Você compreendeu como o compilador revolucionou o mundo!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var victory_lines: Array[Dictionary] = [
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Excelente raciocínio! Ao conectar o que nós falamos com o que a máquina faz, você experimentou a mágica do Compilador."
		},
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Veja agora no nosso Cartão de Conquista como essa ideia foi ridicularizada no início, e como ela transformou a programação em algo acessível para toda a humanidade!"
		}
	]
	dialogue_box.start_dialogue(victory_lines)
	dialogue_box.dialogue_finished.connect(func():
		synthesis_modal.show_synthesis(_get_synthesis_data(), true)
	, CONNECT_ONE_SHOT)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 3: Grace Hopper (1947)",
		"pioneer_text": "[b][color=#ffd54f]Quem foi a pioneira?[/color][/b]\nGrace Brewster Murray Hopper (1906–1992) foi matemática, professora, contra-almirante da Marinha dos EUA e uma das figuras mais carismáticas da ciência.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5):[/color][/b]\nGrace enfrentou a rigidez militar e a descrença dos cientistas homens da época. Quando propôs que computadores pudessem ser programados em palavras normais, disseram que era 'uma perda de tempo absurda' e que computadores só serviam para matemáticos. Ela provou que todos estavam errados!",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nEla inventou o [b]Compilador[/b] (o primeiro tradutor automático de programas) e ajudou a criar a linguagem [b]COBOL[/b], que permitiu que bancos, empresas e hospitais usassem computadores.\n\nAlém disso, popularizou os termos [b]'Bug'[/b] (quando retirou uma mariposa que travava o computador) e [b]'Debug'[/b] (o ato de caçar e consertar defeitos).",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]O Google Tradutor dos Computadores (Compilador):[/b]\nO computador só entende pulsos de eletricidade (ligado e desligado / 0 e 1). É quase impossível para uma pessoa comum escrever milhões de números binários de cabeça.\n\nGrace inventou o [b]Compilador[/b]: um tradutor que pega o que você escreve em linguagem humana e traduz instantaneamente para a língua elétrica da máquina!",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nSe hoje você pode criar um site, programar um jogo ou usar um aplicativo no celular, é porque Grace Hopper quebrou a barreira dos números incompreensíveis.\n\nEla democratizou a tecnologia para que qualquer pessoa do planeta pudesse aprender a programar."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("grace")
		btn_next_stage.show()
		label_status.text = "Síntese consolidada! Clique no botão abaixo para avançar até 1962 com Katherine Johnson."

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(4)
