extends Control

@onready var dialogue_box = $DialogueBox
@onready var label_status: Label = %LabelStatus
@onready var cable_info_label: RichTextLabel = %CableInfoLabel
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_menu: Button = %BtnMenu
@onready var sources_container: VBoxContainer = %SourcesContainer
@onready var targets_container: VBoxContainer = %TargetsContainer

var cable_texture = preload("res://src/assets/textures/icons/Cabo Eniac.png")

var start_time: float = 0.0
var selected_source_btn: Button = null

var patch_connections = [
	{
		"source": "Cabo 1: Transmissor de Pulso Mestre",
		"target": "Painel de Ciclos (Digit Trays)",
		"desc": "[b]Pulso Mestre:[/b] Envia o sinal de clock de 100 kHz para sincronizar os ciclos do acumulador.",
		"connected": false
	},
	{
		"source": "Cabo 2: Acumulador #1 (Velocidade V0)",
		"target": "Unidade Multiplicadora / Divisora",
		"desc": "[b]Canal de Dados:[/b] Envia o vetor de aceleração para ser multiplicado pelo coeficiente de arrasto do ar.",
		"connected": false
	},
	{
		"source": "Cabo 3: Acumulador de Saída Integrada",
		"target": "Leitor/Perfurador de Cartões IBM",
		"desc": "[b]Canal de Saída:[/b] Transfere as coordenadas da trajetória balística para perfuração no cartão.",
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

	_setup_patch_panel()
	_start_intro_dialogue()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Olá! Somos Betty Snyder e Kay McNulty, duas das seis programadoras pioneiras do ENIAC na Universidade da Pensilvânia."
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Em 1945 não existiam sistemas operacionais nem linguagens escritas: nós programávamos conectando cabos físicos e configurando mais de 3.000 interruptores nas paredes de aço do computador!"
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Precisamos calcular a trajetória balística de um teste. Conecte os cabos de pulso dos transmissores (à esquerda) aos painéis de destino corretos (à direita)!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_patch_panel() -> void:
	for child in sources_container.get_children():
		child.queue_free()
	for child in targets_container.get_children():
		child.queue_free()

	for i in range(patch_connections.size()):
		var data = patch_connections[i]
		var btn_s = Button.new()
		btn_s.custom_minimum_size = Vector2(340, 56)
		btn_s.text = data["source"]
		btn_s.icon = cable_texture
		btn_s.expand_icon = true
		btn_s.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn_s.set_meta("idx", i)
		btn_s.pressed.connect(_on_source_btn_pressed.bind(btn_s, data))
		sources_container.add_child(btn_s)

	var target_indices = [0, 1, 2]
	target_indices.shuffle()
	for idx in target_indices:
		var data = patch_connections[idx]
		var btn_t = Button.new()
		btn_t.custom_minimum_size = Vector2(340, 56)
		btn_t.text = data["target"]
		btn_t.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn_t.set_meta("idx", idx)
		btn_t.pressed.connect(_on_target_btn_pressed.bind(btn_t))
		targets_container.add_child(btn_t)

func _on_source_btn_pressed(btn: Button, data: Dictionary) -> void:
	AudioManager.play_card()
	if selected_source_btn != null:
		selected_source_btn.modulate = Color.WHITE
	selected_source_btn = btn
	btn.modulate = Color(1.0, 0.85, 0.3)
	cable_info_label.text = data["desc"]
	label_status.text = "Cabo selecionado! Agora clique na porta de destino correspondente no painel direito."
	label_status.modulate = Color(1.0, 0.85, 0.3)

func _on_target_btn_pressed(btn_t: Button) -> void:
	if selected_source_btn == null:
		AudioManager.play_error()
		label_status.text = "Atenção: Selecione primeiro um cabo na coluna da esquerda!"
		label_status.modulate = Color(1.0, 0.4, 0.4)
		return

	var s_idx = selected_source_btn.get_meta("idx")
	var t_idx = btn_t.get_meta("idx")

	if s_idx == t_idx:
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
		label_status.text = "Conexão estabelecida com sucesso! Válvulas aquecendo..."
		label_status.modulate = Color(0.3, 1.0, 0.5)
		_check_all_cables()
	else:
		AudioManager.play_error()
		label_status.text = "Circuito incorreto! Esse destino causará curto de pulso na lógica do acumulador."
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _check_all_cables() -> void:
	for conn in patch_connections:
		if not conn["connected"]:
			return

	var duration = (Time.get_ticks_msec() / 1000.0) - start_time
	GameState.complete_stage("eniac", duration, 180)
	GameState.unlock_next_stage(2)

	btn_next_stage.show()
	label_status.text = "ENIAC Operando a 5.000 adições por segundo! Cálculo de trajetória concluído em 20 segundos!"
	label_status.modulate = Color(0.3, 1.0, 0.5)

	var win_lines: Array[Dictionary] = [
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Perfeito! A trajetória foi calculada com absoluta precisão matemática."
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Nós fomos chamadas inicialmente apenas de 'computadoras humanas', mas na verdade criamos a primeira metodologia de programação de computadores digitais do mundo."
		},
		{
			"speaker": "ENIAC Girls (1945)",
			"color": Color(0.85, 0.4, 0.4),
			"text": "Agora, vamos avançar dois anos no tempo para conhecer Grace Hopper e o Harvard Mark II em 1947!"
		}
	]
	dialogue_box.start_dialogue(win_lines)

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(3)
