extends Control

@onready var dialogue_box = $DialogueBox
@onready var label_status: Label = %LabelStatus
@onready var cable_info_label: RichTextLabel = %CableInfoLabel
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var btn_menu: Button = %BtnMenu
@onready var sources_container: VBoxContainer = %SourcesContainer
@onready var targets_container: VBoxContainer = %TargetsContainer

var cable_texture = preload("res://src/assets/textures/icons/Cabo Eniac.png")

var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null

var start_time: float = 0.0
var selected_source_btn: Button = null

# Conexões explicadas com analogias intuitivas (O Maestro, Os Números e A Resposta)
var patch_connections = [
	{
		"source": "Cabo 1: O Maestro (Pulso de Ritmo / Clock)",
		"target": "Painel de Ritmo e Sincronização (Clock)",
		"desc": "[b][color=#ffd54f]1. Cabo do Ritmo (O Maestro do Computador):[/color][/b]\nComo o maestro que guia uma orquestra ou o bater de um coração, este cabo envia pulsos elétricos no mesmo segundo para que todas as peças da máquina trabalhem sincronizadas!",
		"connected": false
	},
	{
		"source": "Cabo 2: O Canal dos Números (Dados para a Conta)",
		"target": "Unidade de Fazer Contas (Processador / Multiplicador)",
		"desc": "[b][color=#4fc3f7]2. Cabo dos Números (Canal de Dados):[/color][/b]\nLeva os números da trajetória guardados na memória até a peça da máquina responsável por multiplicar e fazer as contas!",
		"connected": false
	},
	{
		"source": "Cabo 3: A Saída da Resposta (Gravação Final)",
		"target": "Mecanismo Perfurador de Cartões (Saída / Impressora)",
		"desc": "[b][color=#81c784]3. Cabo da Resposta (Canal de Saída):[/color][/b]\nApós a conta ser feita, este cabo leva o resultado pronto para acionar as agulhas e perfurar o papel, entregando a resposta final aos cientistas!",
		"connected": false
	}
]

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("eniac")
	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Eniac Girls.png")
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

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	# Instanciar modal de síntese
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

	_setup_patch_panel()
	_start_intro_dialogue()

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Olá! Nós somos as seis matemáticas que programaram o ENIAC: Kay, Betty Jennings, Betty Snyder, Marlyn, Frances e Ruth."
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Em 1945 não existiam telas, mouses nem linguagens de programação. Para fazer o primeiro computador gigante funcionar, tínhamos que conectar cabos elétricos pesados de um painel a outro com as próprias mãos!"
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Seu desafio: selecione cada um dos 3 cabos à esquerda e ligue-o ao destino correto à direita. Você pode consultar o 'Cartão do ENIAC' no topo a qualquer momento para aprender mais!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_patch_panel() -> void:
	for child in sources_container.get_children():
		child.queue_free()
	for child in targets_container.get_children():
		child.queue_free()

	var source_indices = [0, 1, 2]
	source_indices.shuffle()

	var target_indices = [0, 1, 2]
	var deranged = false
	while not deranged:
		target_indices.shuffle()
		deranged = true
		for k in range(3):
			if source_indices[k] == target_indices[k]:
				deranged = false
				break

	for idx in source_indices:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(360, 56)
		btn.text = patch_connections[idx]["source"]
		btn.icon = cable_texture
		btn.expand_icon = true
		btn.set_meta("conn_index", idx)
		btn.pressed.connect(_on_source_clicked.bind(btn, idx))
		sources_container.add_child(btn)

	for idx in target_indices:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(360, 56)
		btn.text = "[ Conectar aqui ]\n" + patch_connections[idx]["target"]
		btn.set_meta("conn_index", idx)
		btn.pressed.connect(_on_target_clicked.bind(btn, idx))
		targets_container.add_child(btn)

func _on_source_clicked(btn: Button, idx: int) -> void:
	AudioManager.play_card()
	if selected_source_btn and selected_source_btn != btn:
		selected_source_btn.modulate = Color(1, 1, 1)

	selected_source_btn = btn
	btn.modulate = Color(1.0, 0.9, 0.3)
	cable_info_label.text = patch_connections[idx]["desc"]
	label_status.text = "Cabo selecionado! Agora clique no painel da direita correspondente para conectá-lo."
	label_status.modulate = Color(0.9, 0.9, 0.3)

func _on_target_clicked(btn_t: Button, target_idx: int) -> void:
	if not selected_source_btn:
		AudioManager.play_error()
		label_status.text = "Selecione primeiro um cabo da coluna da esquerda!"
		label_status.modulate = Color(1.0, 0.6, 0.3)
		return

	var s_idx = selected_source_btn.get_meta("conn_index")
	if s_idx == target_idx:
		AudioManager.play_success()
		patch_connections[s_idx]["connected"] = true
		selected_source_btn.disabled = true
		selected_source_btn.modulate = Color(0.3, 1.0, 0.5)
		selected_source_btn.text = "[OK] " + patch_connections[s_idx]["source"]
		btn_t.disabled = true
		btn_t.modulate = Color(0.3, 1.0, 0.5)
		btn_t.icon = cable_texture
		btn_t.expand_icon = true
		btn_t.text = "[OK] " + patch_connections[s_idx]["target"]
		selected_source_btn = null
		label_status.text = "Conexão perfeita! O sinal elétrico está passando corretamente."
		label_status.modulate = Color(0.3, 1.0, 0.5)
		_check_all_cables()
	else:
		AudioManager.play_error()
		label_status.text = "Circuito incompatível! Pense na função: o Maestro vai no Ritmo, os Números vão para as Contas, e a Resposta vai para a Impressora."
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _check_all_cables() -> void:
	for conn in patch_connections:
		if not conn["connected"]:
			return

	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("eniac", duration, 180)
	GameState.unlock_next_stage(2)

	label_status.text = "Desafio Concluído! O circuito físico do ENIAC operou com total sincronia!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var win_lines: Array[Dictionary] = [
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Sensacional! Todos os circuitos estão sincronizados e o ENIAC concluiu o cálculo em segundos."
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Veja agora no nosso Cartão de Conquista como a nossa história foi quase apagada pelo preconceito da época, e por que o nosso trabalho criou a base de todo processador moderno!"
		}
	]
	dialogue_box.start_dialogue(win_lines)
	dialogue_box.dialogue_finished.connect(func():
		synthesis_modal.show_synthesis(_get_synthesis_data(), true)
	, CONNECT_ONE_SHOT)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 2: As Programadoras do ENIAC (1945)",
		"pioneer_text": "[b][color=#ffd54f]Quem foram as pioneiras?[/color][/b]\nSeis matemáticas fundamentais: Kathleen McNulty, Frances Bilas, Betty Jean Jennings, Ruth Lichterman, Elizabeth Snyder e Marlyn Wescoff.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5):[/color][/b]\nEmbora tenham sido elas que fizeram o primeiro computador eletrônico gigante funcionar, seu trabalho foi rotulado na época como 'tarefa secundária de secretária'. Na festa oficial de inauguração em 1946, os engenheiros homens levaram todo o crédito público e elas nem foram convidadas para o jantar comemorativo!",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nSem nenhum livro ou manual para estudar, elas criaram do zero as primeiras técnicas de programação do mundo: diagramas de fluxo, testes de circuitos e localização de falhas elétricas.\n\nElas transformaram uma máquina enorme de 30 toneladas de metal em um computador científico programável.",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]Como a eletricidade se organiza no computador:[/b]\nAntes de podermos digitar comandos, tudo era ligado por cabos físicos:\n• [b]O Maestro (Clock):[/b] Dá o ritmo para que o computador saiba quando agir a cada segundo;\n• [b]Canal de Dados:[/b] Os fios que levam as informações até a peça que faz as contas;\n• [b]Canal de Saída:[/b] Os fios que levam a resposta final para imprimir.",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nO chip (processador) dentro do seu celular tem bilhões de conexões microscópicas que funcionam exatamente com esse mesmo trio: ritmo (clock), trânsito de dados e saída de resultados!\n\nReconhecer as programadoras do ENIAC é resgatar as verdadeiras fundadoras da computação prática."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("eniac")
		btn_next_stage.show()
		label_status.text = "Síntese consolidada! Clique no botão abaixo para avançar até 1947 com Grace Hopper."

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(3)
