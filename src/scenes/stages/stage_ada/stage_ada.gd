extends Control

@onready var dialogue_box = $DialogueBox
@onready var slots_container: HBoxContainer = %SlotsContainer
@onready var deck_container: HBoxContainer = %DeckContainer
@onready var btn_run: Button = %BtnRun
@onready var btn_hint: Button = %BtnHint
@onready var btn_next_stage: Button = %BtnNextStage
@onready var label_status: Label = %LabelStatus
@onready var card_info_box: RichTextLabel = %CardInfoBox
@onready var gear_left: Control = %GearLeft
@onready var gear_right: Control = %GearRight

var card_texture = preload("res://src/assets/textures/icons/Cartao_perfurado.png")
var start_time: float = 0.0
var attempts: int = 0

# Definição dos cartões perfurados
var cards_data = [
	{
		"id": "input",
		"title": "Entrada de Dados",
		"desc": "[b]Cartão de Operação:[/b] Inicializar variáveis [i]n = 4[/i] e zerar acumuladores na memória mecânica.",
		"correct_pos": 0
	},
	{
		"id": "loop",
		"title": "Laço de Repetição",
		"desc": "[b]Cartão de Controle:[/b] Estrutura condicional iterativa: enquanto [i]k <= n[/i], avançar colunas do tear.",
		"correct_pos": 1
	},
	{
		"id": "calc",
		"title": "Cálculo Aritmético",
		"desc": "[b]Cartão de Variável:[/b] Multiplicar coeficientes binomiais e processar termos fracionários intermediários.",
		"correct_pos": 2
	},
	{
		"id": "output",
		"title": "Saída e Impressão",
		"desc": "[b]Cartão de Saída:[/b] Perfurar e imprimir na folha o Número de Bernoulli correspondente.",
		"correct_pos": 3
	}
]

var active_slot_cards: Array = [null, null, null, null]
var selected_deck_card_index: int = -1

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("ada")
	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Ada_Lovelace.png")
	portrait_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HeaderPanel/Margin/HeaderBar.add_child(portrait_icon)
	$HeaderPanel/Margin/HeaderBar.move_child(portrait_icon, 0)

	btn_run.pressed.connect(_on_btn_run_pressed)
	btn_hint.pressed.connect(_on_btn_hint_pressed)
	btn_next_stage.pressed.connect(_on_btn_next_stage_pressed)
	btn_next_stage.hide()

	_setup_deck()
	_start_intro_dialogue()

func _on_btn_menu_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_main_menu()

func _process(delta: float) -> void:
	if gear_left and gear_right:
		gear_left.rotation += delta * 0.4
		gear_right.rotation -= delta * 0.4

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Ada Lovelace (1843)",
			"color": Color(0.9, 0.7, 0.2),
			"text": "Olá! Sou Ada Lovelace. Em 1843, percebi algo que poucos enxergaram: a Máquina Analítica de Babbage não serve apenas para calcular números, mas para manipular qualquer símbolo regido por regras."
		},
		{
			"speaker": "Ada Lovelace (1843)",
			"color": Color(0.9, 0.7, 0.2),
			"text": "Para provar isso, criei o primeiro algoritmo da história humana, destinado a calcular os Números de Bernoulli."
		},
		{
			"speaker": "Ada Lovelace (1843)",
			"color": Color(0.9, 0.7, 0.2),
			"text": "Seu desafio: organize os 4 cartões perfurados na ordem lógica correta para que o motor a vapor possa processar o algoritmo sem falhas!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _setup_deck() -> void:
	for child in deck_container.get_children():
		child.queue_free()

	# Embaralhar cartões
	var shuffled = cards_data.duplicate()
	shuffled.shuffle()

	for i in range(shuffled.size()):
		var data = shuffled[i]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(210, 80)
		btn.text = data["title"]
		btn.icon = card_texture
		btn.expand_icon = true
		btn.set_meta("card_data", data)
		btn.pressed.connect(_on_deck_card_pressed.bind(btn))
		btn.mouse_entered.connect(_on_card_hover.bind(data))
		deck_container.add_child(btn)

	for i in range(4):
		var slot_btn: Button = slots_container.get_node("Slot" + str(i + 1))
		slot_btn.text = "[ Vazio ]\nSlot " + str(i + 1)
		slot_btn.pressed.connect(_on_slot_pressed.bind(i, slot_btn))

func _on_card_hover(data: Dictionary) -> void:
	card_info_box.text = data["desc"]

func _on_deck_card_pressed(btn: Button) -> void:
	AudioManager.play_card()
	var card_data = btn.get_meta("card_data")
	
	# Achar primeiro slot vazio
	for i in range(4):
		if active_slot_cards[i] == null:
			active_slot_cards[i] = card_data
			var slot_btn: Button = slots_container.get_node("Slot" + str(i + 1))
			slot_btn.icon = card_texture
			slot_btn.expand_icon = true
			slot_btn.text = "[OK] " + card_data["title"]
			btn.disabled = true
			card_info_box.text = "Cartão inserido no Slot " + str(i + 1) + ". Clique no slot se quiser remover."
			return

	card_info_box.text = "Todos os slots já estão preenchidos! Remova um cartão clicando no slot desejado."

func _on_slot_pressed(slot_idx: int, slot_btn: Button) -> void:
	if active_slot_cards[slot_idx] != null:
		AudioManager.play_click()
		var card_data = active_slot_cards[slot_idx]
		# Reabilitar no deck
		for child in deck_container.get_children():
			if child.has_meta("card_data") and child.get_meta("card_data")["id"] == card_data["id"]:
				child.disabled = false
				break
		active_slot_cards[slot_idx] = null
		slot_btn.icon = null
		slot_btn.text = "[ Vazio ]\nSlot " + str(slot_idx + 1)
		card_info_box.text = "Cartão removido do Slot " + str(slot_idx + 1)

func _on_btn_hint_pressed() -> void:
	AudioManager.play_click()
	card_info_box.text = "[color=#fbc02d][b]Dica de Ada:[/b] Todo algoritmo precisa de: (1) definir dados de entrada, (2) laço de repetição, (3) processamento matemático e por fim (4) gravação do resultado![/color]"

func _on_btn_run_pressed() -> void:
	attempts += 1
	# Verificar se todos os slots estão cheios
	for i in range(4):
		if active_slot_cards[i] == null:
			AudioManager.play_error()
			label_status.text = "Atenção: Todos os 4 slots precisam de cartões perfurados!"
			label_status.modulate = Color(1.0, 0.4, 0.4)
			return

	# Checar ordem correta
	var is_correct: bool = true
	for i in range(4):
		if active_slot_cards[i]["correct_pos"] != i:
			is_correct = false
			break

	if is_correct:
		AudioManager.play_success()
		var duration = (Time.get_ticks_msec() / 1000.0) - start_time
		GameState.complete_stage("ada", duration, 150)
		GameState.unlock_next_stage(1)

		label_status.text = "Sucesso! O motor calculou os Números de Bernoulli com perfeição!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_run.disabled = true
		btn_next_stage.show()

		var victory_lines: Array[Dictionary] = [
			{
				"speaker": "Ada Lovelace (1843)",
				"color": Color(0.9, 0.7, 0.2),
				"text": "Magnífico! Você acabou de executar a primeira lógica computacional do mundo."
			},
			{
				"speaker": "Ada Lovelace (1843)",
				"color": Color(0.9, 0.7, 0.2),
				"text": "Minhas anotações ('Nota G') definiram as bases da computação moderna. Vamos agora avançar no tempo até 1945 para conhecer as lendárias ENIAC Girls!"
			}
		]
		dialogue_box.start_dialogue(victory_lines)
	else:
		AudioManager.play_error()
		label_status.text = "Falha de execução! O fluxo lógico dos cartões está inconsistente. Revise a ordem das instruções."
		label_status.modulate = Color(1.0, 0.35, 0.35)

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(2)
