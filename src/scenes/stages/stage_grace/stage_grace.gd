extends Control

@onready var dialogue_box = $DialogueBox
@onready var relays_grid: GridContainer = %RelaysGrid
@onready var compiler_panel: PanelContainer = %CompilerPanel
@onready var label_status: Label = %LabelStatus
@onready var bug_info_label: RichTextLabel = %BugInfoLabel
@onready var moth_icon_rect: TextureRect = %MothIconRect
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_menu: Button = %BtnMenu

var moth_texture = preload("res://src/assets/textures/icons/mariposa.png")

var start_time: float = 0.0
var bug_found: bool = false
var compiler_step_completed: bool = false
var moth_relay_index: int = 4 # Relé F (índice 4)

# Perguntas de compilação
var compiler_pairs = [
	{"high": "SUBTRACT IMPOSTO FROM SALARIO", "code": "SUB R1, R2, R3", "paired": false},
	{"high": "IF SALDO < 0 GOTO ALERTA", "code": "BR_NEG R1, ADR_0x40", "paired": false},
	{"high": "PRINT RELATORIO", "code": "SYS_OUT 0x01", "paired": false}
]
var selected_high_btn: Button = null

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("grace")
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

	_setup_relays()
	_start_intro_dialogue()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Olá! Sou Grace Hopper, oficial da Marinha dos EUA e cientista da computação. Estamos no laboratório do computador eletromecânico Harvard Mark II."
		},
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Nossa máquina parou de repente! Há uma falha de circuito em um dos relés mecânicos. Inspecione o painel de relés para descobrir o que está bloqueando a passagem da corrente elétrica!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_relays() -> void:
	for i in range(8):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(110, 68)
		btn.text = "Relé #" + str(70 + i) + "\n[ Testar ]"
		btn.pressed.connect(_on_relay_clicked.bind(i, btn))
		relays_grid.add_child(btn)

func _on_relay_clicked(idx: int, btn: Button) -> void:
	if bug_found:
		return

	if idx == moth_relay_index:
		AudioManager.play_bug_catch()
		bug_found = true
		btn.text = "Relé #74\nBUG (MARIPOSA)!"
		btn.icon = moth_texture
		btn.expand_icon = true
		btn.modulate = Color(1.0, 0.85, 0.2)
		moth_icon_rect.show()

		label_status.text = "Incrível! Uma mariposa estava presa nos contatos do Relé #74!"
		label_status.modulate = Color(0.4, 1.0, 0.5)
		bug_info_label.text = "[color=#ffd54f][b]Registro Histórico (9 de Setembro de 1947):[/b][/color] Grace Hopper e sua equipe colaram a mariposa com fita adesiva no caderno de bordo oficial: [i]'First actual case of bug being found'[/i]. Daqui nasceu o termo moderno de 'Debugging'!"

		var mid_lines: Array[Dictionary] = [
			{
				"speaker": "Grace Hopper (1947)",
				"color": Color(0.3, 0.7, 0.9),
				"text": "Você encontrou o bug físico! Agora que o hardware voltou a operar, vamos para a minha verdadeira revolução: o COMPILADOR."
			},
			{
				"speaker": "Grace Hopper (1947)",
				"color": Color(0.3, 0.7, 0.9),
				"text": "Diziam que computadores só entendiam aritmética e código binário. Eu provei que podíamos escrever instruções em inglês comum (como COBOL) e fazer o próprio computador traduzir para linguagem de máquina!"
			}
		]
		dialogue_box.start_dialogue(mid_lines)
		dialogue_box.dialogue_finished.connect(_on_intro_compiler_finished, CONNECT_ONE_SHOT)
	else:
		AudioManager.play_click()
		btn.text = "Relé #" + str(70 + idx) + "\n[OK] Normal"
		btn.disabled = true
		label_status.text = "Relé #" + str(70 + idx) + ": Corrente nominal de 24V, sem obstruções."
		label_status.modulate = Color(0.7, 0.8, 0.9)

func _on_intro_compiler_finished() -> void:
	compiler_panel.show()
	_setup_compiler_game()

func _setup_compiler_game() -> void:
	var high_container = %HighLevelContainer
	var low_container = %LowLevelContainer

	for child in high_container.get_children():
		child.queue_free()
	for child in low_container.get_children():
		child.queue_free()

	for i in range(compiler_pairs.size()):
		var pair = compiler_pairs[i]
		var btn_h = Button.new()
		btn_h.custom_minimum_size = Vector2(250, 40)
		btn_h.text = pair["high"]
		btn_h.set_meta("pair_index", i)
		btn_h.pressed.connect(_on_high_btn_pressed.bind(btn_h))
		high_container.add_child(btn_h)

	var shuffled_indices = [0, 1, 2]
	shuffled_indices.shuffle()
	for idx in shuffled_indices:
		var pair = compiler_pairs[idx]
		var btn_l = Button.new()
		btn_l.custom_minimum_size = Vector2(250, 40)
		btn_l.text = pair["code"]
		btn_l.set_meta("pair_index", idx)
		btn_l.pressed.connect(_on_low_btn_pressed.bind(btn_l))
		low_container.add_child(btn_l)

func _on_high_btn_pressed(btn: Button) -> void:
	AudioManager.play_click()
	if selected_high_btn != null:
		selected_high_btn.modulate = Color.WHITE
	selected_high_btn = btn
	btn.modulate = Color(0.4, 0.8, 1.0)
	label_status.text = "Instrução de alto nível selecionada. Escolha a instrução em código de máquina correspondente!"

func _on_low_btn_pressed(btn: Button) -> void:
	if selected_high_btn == null:
		label_status.text = "Selecione primeiro uma instrução em linguagem humana à esquerda!"
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
		selected_high_btn = null
		label_status.text = "Compilação bem-sucedida! Instrução traduzida corretamente."
		label_status.modulate = Color(0.4, 1.0, 0.5)
		_check_compiler_completion()
	else:
		AudioManager.play_error()
		label_status.text = "Erro de semântica na compilação! A instrução de máquina não corresponde à lógica."
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _check_compiler_completion() -> void:
	for pair in compiler_pairs:
		if not pair["paired"]:
			return

	compiler_step_completed = true
	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("grace", duration, 200)
	GameState.unlock_next_stage(2)

	btn_next_stage.show()
	label_status.text = "Extraordinário! Você compilou um programa completo e compreendeu a fundação dos compiladores!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var victory_lines: Array[Dictionary] = [
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Brilhante! 'É mais fácil pedir perdão do que permissão', como eu costumo dizer. Graças aos compiladores, qualquer ser humano pôde passar a programar."
		},
		{
			"speaker": "Grace Hopper (1947)",
			"color": Color(0.3, 0.7, 0.9),
			"text": "Agora, vamos avançar no tempo até a NASA nos anos 60 para conhecer a brilhante matemática Katherine Johnson!"
		}
	]
	dialogue_box.start_dialogue(victory_lines)

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(4)
