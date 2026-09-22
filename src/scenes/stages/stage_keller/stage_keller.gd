extends Control

@onready var dialogue_box = $DialogueBox
@onready var lines_container: VBoxContainer = %LinesContainer
@onready var terminal_output: RichTextLabel = %TerminalOutput
@onready var label_status: Label = %LabelStatus
@onready var btn_run: Button = %BtnRun
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_menu: Button = %BtnMenu

var start_time: float = 0.0

var basic_lines = [
	{"line_num": 10, "code": "10 REM PROGRAMA EDUCATIVO BASIC", "correct_idx": 0},
	{"line_num": 20, "code": "20 PRINT \"QUAL O SEU NOME?\"", "correct_idx": 1},
	{"line_num": 30, "code": "30 INPUT NOME$", "correct_idx": 2},
	{"line_num": 40, "code": "40 PRINT \"BEM-VINDO AO COTB, \"; NOME$", "correct_idx": 3}
]
var current_order = []

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("keller")
	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)
	btn_run.pressed.connect(_on_btn_run_pressed)
	btn_next_stage.pressed.connect(_on_btn_next_stage_pressed)
	btn_next_stage.hide()

	_setup_lines()
	_start_intro_dialogue()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Olá! Sou a Irmã Mary Kenneth Keller. Em 1965, tive a honra de receber o primeiro Doutorado (Ph.D.) em Ciência da Computação dos Estados Unidos."
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Participei do desenvolvimento da linguagem BASIC na Dartmouth College. Nosso lema era simples: qualquer pessoa, estudante ou pesquisador, tem o direito e a capacidade de aprender a programar!"
		},
		{
			"speaker": "Irmã Mary Kenneth Keller (1965)",
			"color": Color(0.4, 0.8, 0.5),
			"text": "Organize as linhas do código BASIC na ordem correta das instruções numeradas (10, 20, 30, 40) para executarmos nosso primeiro programa na máquina Teletype 33!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_lines() -> void:
	current_order = basic_lines.duplicate()
	current_order.shuffle()
	_render_buttons()

func _render_buttons() -> void:
	for child in lines_container.get_children():
		child.queue_free()

	for i in range(current_order.size()):
		var item = current_order[i]
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 12)

		var btn_code = Button.new()
		btn_code.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_code.custom_minimum_size = Vector2(0, 42)
		btn_code.text = "Linha " + str(i + 1) + ": " + item["code"]
		hbox.add_child(btn_code)

		if i > 0:
			var btn_up = Button.new()
			btn_up.text = "Subir"
			btn_up.custom_minimum_size = Vector2(80, 42)
			btn_up.pressed.connect(func():
				AudioManager.play_card()
				var temp = current_order[i]
				current_order[i] = current_order[i - 1]
				current_order[i - 1] = temp
				_render_buttons()
			)
			hbox.add_child(btn_up)

		if i < current_order.size() - 1:
			var btn_down = Button.new()
			btn_down.text = "Descer"
			btn_down.custom_minimum_size = Vector2(80, 42)
			btn_down.pressed.connect(func():
				AudioManager.play_card()
				var temp = current_order[i]
				current_order[i] = current_order[i + 1]
				current_order[i + 1] = temp
				_render_buttons()
			)
			hbox.add_child(btn_down)

		lines_container.add_child(hbox)

func _on_btn_run_pressed() -> void:
	var is_correct = true
	for i in range(current_order.size()):
		if current_order[i]["correct_idx"] != i:
			is_correct = false
			break

	if is_correct:
		AudioManager.play_success()
		var duration = (Time.get_ticks_msec() / 1000.0) - start_time
		GameState.complete_stage("keller", duration, 240)
		GameState.unlock_next_stage(5)

		terminal_output.text = "[color=#a3be8c]READY.\nRUN\n\nQUAL O SEU NOME?\n> PESQUISADOR DO COTB\nBEM-VINDO AO COTB, PESQUISADOR DO COTB!\n\nSUCCESS: 0 ERRORS. PROGRAM FINISHED.[/color]"
		label_status.text = "Execução perfeita! O interpretador BASIC processou todas as instruções sem erros de compilação!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_run.disabled = true
		btn_next_stage.show()

		var win_lines: Array[Dictionary] = [
			{
				"speaker": "Irmã Mary Kenneth Keller (1965)",
				"color": Color(0.4, 0.8, 0.5),
				"text": "Maravilhoso! O BASIC transformou a computação de uma área militar restrita em uma ferramenta educacional global."
			},
			{
				"speaker": "Irmã Mary Kenneth Keller (1965)",
				"color": Color(0.4, 0.8, 0.5),
				"text": "Eu acreditava que os computadores deveriam ensinar as pessoas a pensar. Vamos agora para a Fase Final em 1969 com Margaret Hamilton e o pouso na Lua!"
			}
		]
		dialogue_box.start_dialogue(win_lines)
	else:
		AudioManager.play_error()
		terminal_output.text = "[color=#bf616a]SYNTAX ERROR: LINE SEQUENCE OUT OF BOUNDS.\nTRY AGAIN.[/color]"
		label_status.text = "Erro de sequência! Lembre-se de que a leitura lógica precisa definir o REM, fazer a pergunta antes do INPUT e exibir a resposta no final!"
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(6)
