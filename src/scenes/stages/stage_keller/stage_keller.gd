extends Control

@onready var dialogue_box = $DialogueBox
@onready var lines_container: VBoxContainer = %LinesContainer
@onready var btn_run: Button = %BtnRun
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var btn_menu: Button = %BtnMenu
@onready var label_status: Label = %LabelStatus
@onready var terminal_output: RichTextLabel = %TerminalOutput
@onready var input_container: HBoxContainer = %InteractiveInputContainer
@onready var name_input: LineEdit = %NameInput
@onready var btn_prompt_keller_name: Button = %BtnPromptKellerName
@onready var btn_submit_name: Button = %BtnSubmitName

var card_texture = preload("res://src/assets/textures/icons/Cartao_perfurado.png")
var icon_arrow_up = preload("res://src/assets/textures/icons/icon_arrow_up.svg")
var icon_arrow_down = preload("res://src/assets/textures/icons/icon_arrow_down.svg")
var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null
var start_time: float = 0.0
var _prompt_active: bool = false

# Linhas de código em BASIC explicadas com a metáfora de 'Perguntar e Guardar na Gaveta'
var basic_lines = [
	{
		"code": "REM --- MEU PRIMEIRO PROGRAMA ---",
		"desc": "[b]REM (Bilhete Explicativo):[/b] Uma anotação no topo do texto que explica do que se trata o programa (o computador não faz nada com ela, serve só para nós humanos lermos!).",
		"correct_idx": 0
	},
	{
		"code": "PRINT \"QUAL O SEU NOME?\"",
		"desc": "[b]PRINT (Falar na Tela):[/b] Mostra uma mensagem de texto na tela para fazer uma pergunta amigável ao usuário.",
		"correct_idx": 1
	},
	{
		"code": "INPUT NOME$",
		"desc": "[b]INPUT (Ouvir e Guardar na Gaveta):[/b] O computador para e espera a pessoa digitar o nome no teclado. O que ela digitar é guardado numa gavetinha de memória chamada NOME$!",
		"correct_idx": 2
	},
	{
		"code": "PRINT \"BEM-VINDO(A) AO MUNDO DIGITAL, \"; NOME$",
		"desc": "[b]PRINT com Gaveta:[/b] O computador abre a gavetinha NOME$, pega o nome digitado e mostra uma mensagem personalizada na tela!",
		"correct_idx": 3
	}
]
var current_order = []

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("keller")
	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Irmã Mary Kenneth Keller.png")
	portrait_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HeaderPanel/Margin/HeaderBar.add_child(portrait_icon)
	$HeaderPanel/Margin/HeaderBar.move_child(portrait_icon, 0)

	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)
	btn_run.pressed.connect(_on_btn_run_pressed)
	btn_next_stage.pressed.connect(_on_btn_next_stage_pressed)
	btn_next_stage.hide()
	input_container.hide()

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	name_input.text_submitted.connect(_on_name_submitted)
	btn_submit_name.pressed.connect(func(): _on_name_submitted(name_input.text))
	btn_prompt_keller_name.pressed.connect(func():
		AudioManager.play_click()
		_prompt_mobile_input(name_input, "Digite seu nome ou apelido:")
	)
	name_input.gui_input.connect(func(event: InputEvent):
		if _is_mobile_environment():
			if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
				_prompt_mobile_input(name_input, "Digite seu nome ou apelido:")
	)

	# Instanciar modal de síntese
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

	_setup_lines()
	_start_intro_dialogue()

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Olá! Sou a Irmã Mary Kenneth Keller, freira católica, professora e a primeira mulher a obter um Doutorado em Ciência da Computação nos Estados Unidos (1965)."
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Ajudei a criar a linguagem BASIC com uma missão clara: a computação não deveria ser um segredo trancado para especialistas, mas uma ferramenta para qualquer estudante aprender!"
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Seu desafio: organize as 4 linhas do programa na ordem lógica certa. Quando acertar, você poderá digitar o seu próprio nome no terminal e ver o computador responder a você!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_lines() -> void:
	current_order = basic_lines.duplicate()
	randomize()
	var in_order = true
	while in_order:
		current_order.shuffle()
		var matching = 0
		for i in range(current_order.size()):
			if current_order[i]["correct_idx"] == i:
				matching += 1
		if matching <= 1:
			in_order = false
	_render_buttons()

func _render_buttons() -> void:
	for child in lines_container.get_children():
		child.queue_free()

	for i in range(current_order.size()):
		var item = current_order[i]
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)

		var lbl_pos = Label.new()
		lbl_pos.custom_minimum_size = Vector2(65, 36)
		lbl_pos.text = "Linha " + str((i + 1) * 10) + ":"
		lbl_pos.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(lbl_pos)

		var btn_code = Button.new()
		btn_code.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_code.custom_minimum_size = Vector2(0, 42)
		btn_code.text = item["code"]
		btn_code.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn_code.tooltip_text = item["desc"]
		btn_code.pressed.connect(_on_line_info_clicked.bind(item["desc"]))
		hbox.add_child(btn_code)

		if i > 0:
			var btn_up = Button.new()
			btn_up.custom_minimum_size = Vector2(38, 38)
			btn_up.icon = icon_arrow_up
			btn_up.expand_icon = true
			btn_up.tooltip_text = "Mover linha para cima"
			btn_up.pressed.connect(_move_line.bind(i, -1))
			hbox.add_child(btn_up)

		if i < current_order.size() - 1:
			var btn_down = Button.new()
			btn_down.custom_minimum_size = Vector2(38, 38)
			btn_down.icon = icon_arrow_down
			btn_down.expand_icon = true
			btn_down.tooltip_text = "Mover linha para baixo"
			btn_down.pressed.connect(_move_line.bind(i, 1))
			hbox.add_child(btn_down)

		lines_container.add_child(hbox)

func _on_line_info_clicked(desc: String) -> void:
	AudioManager.play_card()
	terminal_output.text = "[color=#fbc02d][b]Explicação Pedagógica:[/b] " + desc + "[/color]"

func _move_line(from_idx: int, dir: int) -> void:
	AudioManager.play_card()
	var to_idx = from_idx + dir
	var temp = current_order[from_idx]
	current_order[from_idx] = current_order[to_idx]
	current_order[to_idx] = temp
	_render_buttons()

func _on_btn_run_pressed() -> void:
	var is_correct = true
	for i in range(current_order.size()):
		if current_order[i]["correct_idx"] != i:
			is_correct = false
			break

	if is_correct:
		AudioManager.play_success()
		label_status.text = "Ordem correta! O terminal foi ativado: digite seu nome abaixo para rodar o programa!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_run.disabled = true

		terminal_output.text = "[color=#a3be8c]BASIC INTERPRETER v1.0 (Dartmouth/Keller)\n"
		terminal_output.text += "10 REM --- MEU PRIMEIRO PROGRAMA ---\n"
		terminal_output.text += "20 PRINT \"QUAL O SEU NOME?\"\n"
		terminal_output.text += "30 INPUT NOME$\n"
		terminal_output.text += "40 PRINT \"BEM-VINDO(A) AO MUNDO DIGITAL, \"; NOME$\n"
		terminal_output.text += "--------------------------------------\n"
		terminal_output.text += "PRONTO PARA EXECUTAR! Digite seu nome na caixa abaixo:[/color]"

		input_container.show()
		if not GameState.player_name.is_empty() and GameState.player_name != "Estudante / Participante" and GameState.player_name != "Participante Anônimo":
			name_input.text = GameState.player_name
		name_input.grab_focus()
	else:
		AudioManager.play_error()
		GameState.record_attempt("keller")
		var diagnostic = "Atenção: A ordem dos passos está confusa! "
		if current_order[0]["correct_idx"] == 2:
			diagnostic += "O computador tentou pedir para o usuário digitar antes mesmo de fazer a pergunta! Primeiro perguntamos (PRINT), depois ouvimos (INPUT)."
		elif current_order[0]["correct_idx"] == 3:
			diagnostic += "O computador tentou dar as boas-vindas com o nome da pessoa antes de perguntar o nome dela! A gaveta ainda está vazia."
		else:
			diagnostic += "Lembre-se do fluxo da conversa: 1º Bilhete explicativo (REM) -> 2º Perguntar o nome (PRINT) -> 3º Ouvir e guardar na gaveta (INPUT) -> 4º Dar boas-vindas com o nome guardado!"
		
		terminal_output.text = "[color=#bf616a][b]Erro de Lógica:[/b] " + diagnostic + "[/color]"
		label_status.text = "Use os botões de Subir e Descer para reposicionar as linhas!"
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _on_name_submitted(user_name: String) -> void:
	if user_name.strip_edges() == "":
		user_name = "Estudante Pioneiro(a)"

	AudioManager.play_success()
	input_container.hide()

	terminal_output.text += "\n[color=#ffd54f]> " + user_name + "[/color]\n"
	terminal_output.text += "[color=#81c784]BEM-VINDO(A) AO MUNDO DIGITAL, " + user_name.to_upper() + "![/color]\n"
	terminal_output.text += "[color=#64b5f6]PROGRAMA EXECUTADO COM SUCESSO (STATUS: 0 ERRORS)[/color]"

	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("keller", duration, 190)
	GameState.unlock_next_stage(5)

	label_status.text = "Execução perfeita! O computador respondeu diretamente a você!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var victory_lines: Array[Dictionary] = [
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Maravilhoso, " + user_name + "! Você acabou de programar e interagir com o seu primeiro computador na linguagem BASIC."
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Eu acreditava que os computadores deveriam ser uma extensão do potencial humano em escolas e universidades. Você é a prova viva de que essa visão estava certa!"
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Veja agora no nosso Cartão de Conquista por que o acesso à tecnologia na educação é um direito fundamental."
		}
	]
	dialogue_box.start_dialogue(victory_lines)
	dialogue_box.dialogue_finished.connect(func():
		synthesis_modal.show_synthesis(_get_synthesis_data(), true)
	, CONNECT_ONE_SHOT)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 5: Irmã Mary Kenneth Keller (1965)",
		"pioneer_text": "[b][color=#ffd54f]Quem foi a pioneira?[/color][/b]\nA Irmã Mary Kenneth Keller (1913–1985) foi uma freira das Irmãs da Caridade da Bem-Aventurada Virgem Maria, educadora e cientista pioneira.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5):[/color][/b]\nKeller ingressou em um meio universitário predominantemente masculino nos anos 1960. Mesmo diante da surpresa de muitos por ser uma freira atuando em computação avançada, quebrou todos os estereótipos e obteve o primeiro título de Doutorado (Ph.D.) em Computação outorgado a uma mulher nos Estados Unidos.",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nNo Dartmouth College, ajudou a conceber a linguagem [b]BASIC[/b], criada propositalmente para permitir que estudantes de qualquer curso (humanas, biológicas ou artes) pudessem programar.\n\nPosteriormente, fundou e liderou por duas décadas o departamento de computação da Clarke University, impulsionando a formação de centenas de novas cientistas.",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]Entrada, Memória e Saída Interativa:[/b]\nVocê experimentou como o computador conversa com o ser humano:\n• [b]PRINT:[/b] A máquina fala com você na tela;\n• [b]INPUT:[/b] A máquina ouve o que você digita e guarda na gaveta da memória;\n• [b]Variável (a gavetinha NOME$):[/b] Um espaço guardado na memória que pode armazenar qualquer informação para usarmos quando quisermos!",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nKeller previu nos anos 1960: [b]'Estamos passando por uma explosão de informação, e ninguém terá educação completa sem computadores'[/b].\n\nHoje, a inclusão digital e o ensino de computação nas escolas públicas são lutas diretas inspiradas no legado da Irmã Mary Kenneth Keller."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("keller")
		btn_next_stage.show()
		label_status.text = "Síntese consolidada! Clique no botão abaixo para avançar até 1969 com Margaret Hamilton."

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(6)

func _is_mobile_environment() -> bool:
	if OS.has_feature("web"):
		var js_check = """
		(function() {
			var isTouch = ('ontouchstart' in window) || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0);
			var isMobileUA = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
			return isTouch || isMobileUA;
		})()
		"""
		var result = JavaScriptBridge.eval(js_check)
		if result != null and bool(result):
			return true
	if DisplayServer.is_touchscreen_available():
		return true
	var os_name = OS.get_name().to_lower()
	return os_name in ["android", "ios"]

func _prompt_mobile_input(target_line_edit: LineEdit, title: String) -> void:
	if _prompt_active:
		return
	_prompt_active = true
	
	if OS.has_feature("web"):
		var safe_title = title.replace("\\", "\\\\").replace("'", "\\'")
		var current_val = target_line_edit.text.replace("\\", "\\\\").replace("'", "\\'")
		var js = """
		(function() {
			var res = window.prompt('%s', '%s');
			return res !== null ? res : '__CANCELLED__';
		})()
		""" % [safe_title, current_val]
		var res = JavaScriptBridge.eval(js)
		if res != null and str(res) != "__CANCELLED__":
			target_line_edit.text = str(res).strip_edges()
	else:
		target_line_edit.grab_focus()
		
	get_tree().create_timer(0.3).timeout.connect(func():
		_prompt_active = false
	)

