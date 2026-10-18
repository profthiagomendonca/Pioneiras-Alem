extends Control

@onready var dialogue_box = $DialogueBox
@onready var slots_container: HBoxContainer = %SlotsContainer
@onready var deck_container: HBoxContainer = %DeckContainer
@onready var btn_run: Button = %BtnRun
@onready var btn_hint: Button = %BtnHint
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var label_status: Label = %LabelStatus
@onready var card_info_box: RichTextLabel = %CardInfoBox
@onready var gear_left: Control = %GearLeft
@onready var gear_right: Control = %GearRight

var card_texture = preload("res://src/assets/textures/icons/Cartao_perfurado.png")
var start_time: float = 0.0
var attempts: int = 0

var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null

# Cartões didáticos combinando a Metáfora do Cotidiano (Receita de Bolo) com o Conceito de Computação
var cards_data = [
	{
		"id": "input",
		"title": "1. Os Ingredientes",
		"concept": "Entrada de Dados",
		"analogy": "1. Ingredientes (Entrada)",
		"short_desc": "Colocar na mesa o que a máquina vai usar",
		"desc": "[b][color=#ffd54f]1. Cartão de Ingredientes (Entrada de Dados):[/color][/b]\nAntes de fazer um bolo, você separa a farinha, os ovos e o açúcar na mesa. No computador é a mesma coisa: o algoritmo precisa [b]receber os dados iniciais[/b] antes de realizar qualquer cálculo!",
		"correct_pos": 0
	},
	{
		"id": "calc",
		"title": "2. O Preparo / Massa",
		"concept": "Processamento (Cálculo)",
		"analogy": "2. Preparo (Processamento)",
		"short_desc": "Misturar e realizar as transformações",
		"desc": "[b][color=#4fc3f7]2. Cartão de Preparo (Processamento / Cálculo):[/color][/b]\nCom os ingredientes prontos, você bate a massa e ajeita na fôrma. Na máquina de Ada, é aqui que as engrenagens giram para [b]somar, multiplicar e transformar os dados[/b] inseridos!",
		"correct_pos": 1
	},
	{
		"id": "decision",
		"title": "3. Teste do Palito",
		"concept": "Decisão / Repetição (Laço)",
		"analogy": "3. Teste do Palito (Decisão)",
		"short_desc": "Checar: 'Terminou? SE NÃO, repete!'",
		"desc": "[b][color=#81c784]3. Cartão de Checagem (Decisão / Condição):[/color][/b]\nVocê espeta o palito no bolo: [b]SE[/b] sair úmido, assa mais 5 minutos; [b]SENÃO[/b], pode retirar! O computador faz essa pergunta: [b]'A conta acabou? SE NÃO, repita o passo anterior!'[/b]",
		"correct_pos": 2
	},
	{
		"id": "output",
		"title": "4. Servir o Bolo",
		"concept": "Saída de Dados",
		"analogy": "4. Servir à Mesa (Saída)",
		"short_desc": "Entregar o resultado final prontinho",
		"desc": "[b][color=#ff8a65]4. Cartão de Servir (Saída de Dados):[/color][/b]\nO bolo cheiroso é colocado na mesa para saborear! No computador, é o momento em que a máquina perfura a resposta final no papel ou [b]mostra o resultado pronto na tela[/b].",
		"correct_pos": 3
	}
]

var active_slot_cards: Array = [null, null, null, null]

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

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	# Instanciar modal de síntese pedagógica
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

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
			"text": "Olá! Sou Ada Lovelace. Em 1843, percebi algo que ninguém mais enxergou: as máquinas podiam fazer muito mais do que calcular números — podiam seguir qualquer sequência lógica do pensamento humano!"
		},
		{
			"speaker": "Ada Lovelace (1843)",
			"color": Color(0.9, 0.7, 0.2),
			"text": "Para isso, criei o que chamamos hoje de 'Algoritmo': uma receita passo a passo que a máquina segue sem se perder, usando cartões de papel perfurados."
		},
		{
			"speaker": "Ada Lovelace (1843)",
			"color": Color(0.9, 0.7, 0.2),
			"text": "Seu desafio: organize os 4 cartões na ordem lógica correta, como se fosse uma receita de bolo! Você também pode clicar em 'Cartão de Ada' no topo da tela para aprender mais."
		}
	]
	dialogue_box.start_dialogue(lines)

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _setup_deck() -> void:
	for child in deck_container.get_children():
		child.queue_free()

	# Embaralhar cartões
	var shuffled = cards_data.duplicate()
	shuffled.shuffle()

	for i in range(shuffled.size()):
		var data = shuffled[i]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(230, 85)
		btn.text = data["analogy"] + "\n[" + data["concept"] + "]"
		btn.set_meta("card_data", data)
		btn.pressed.connect(_on_deck_card_pressed.bind(btn))
		btn.mouse_entered.connect(_on_card_hover.bind(data))
		deck_container.add_child(btn)

	for i in range(4):
		var slot_btn: Button = slots_container.get_node("Slot" + str(i + 1))
		slot_btn.text = "[ Slot " + str(i + 1) + " Vazio ]\nClique em um cartão"
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
			slot_btn.text = "Passo " + str(i + 1) + ":\n" + card_data["analogy"]
			btn.disabled = true
			card_info_box.text = "[b]Cartão colocado no Passo " + str(i + 1) + ":[/b] " + card_data["desc"] + "\n[color=#aaa](Clique no slot para retirar se quiser mudar)[/color]"
			return

	card_info_box.text = "Todos os 4 passos já estão preenchidos! Para trocar algum cartão, clique no slot lá em cima."

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
		slot_btn.text = "[ Slot " + str(slot_idx + 1) + " Vazio ]\nClique em um cartão"
		card_info_box.text = "Cartão retirado do Passo " + str(slot_idx + 1) + ". Escolha outro cartão abaixo."

func _on_btn_hint_pressed() -> void:
	AudioManager.play_click()
	card_info_box.text = "[color=#ffd54f][b]Dica Pedagógica de Ada (A Receita do Bolo):[/b]\nPense na ordem natural da cozinha:\n1º Você separa os [b]Ingredientes (Entrada)[/b];\n2º Você mistura e bate a [b]Massa (Processamento)[/b];\n3º Você faz o [b]Teste do Palito (Decisão)[/b] para ver se já assou;\n4º Você [b]Serve o Bolo (Saída)[/b] para os convidados![/color]"

func _on_btn_run_pressed() -> void:
	attempts += 1
	# Verificar se todos os slots estão cheios
	for i in range(4):
		if active_slot_cards[i] == null:
			AudioManager.play_error()
			label_status.text = "Atenção: Preencha todos os 4 passos da receita antes de acionar a máquina!"
			label_status.modulate = Color(1.0, 0.4, 0.4)
			return

	# Checar ordem correta: entrada -> cálculo -> decisão -> saída
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

		card_info_box.text = "[color=#a3be8c][b]Perfeito! A Máquina Analítica funcionou como um relógio:[/b]\n1. Recebeu os Ingredientes (Entrada de Dados);\n2. Bateu a massa e calculou as engrenagens (Processamento);\n3. Fez o Teste do Palito para saber quando parar (Decisão/Laço);\n4. Serviu o prato pronto impresso no papel (Saída de Dados)![/color]"
		label_status.text = "Algoritmo Perfeito! Você descobriu como funciona o coração de qualquer programa de computador!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_run.disabled = true

		var victory_lines: Array[Dictionary] = [
			{
				"speaker": "Ada Lovelace (1843)",
				"color": Color(0.9, 0.7, 0.2),
				"text": "Brilhante! Você acabou de montar um Algoritmo com perfeição."
			},
			{
				"speaker": "Ada Lovelace (1843)",
				"color": Color(0.9, 0.7, 0.2),
				"text": "Não importa se é a minha máquina mecânica de 1843 ou a Inteligência Artificial mais moderna de hoje: todo computador sempre precisa de Entrada, Processamento, Decisão e Saída."
			},
			{
				"speaker": "Ada Lovelace (1843)",
				"color": Color(0.9, 0.7, 0.2),
				"text": "Veja agora o seu Cartão de Conquista para celebrar o que aprendemos antes de avançarmos no tempo!"
			}
		]
		dialogue_box.start_dialogue(victory_lines)
		dialogue_box.dialogue_finished.connect(func():
			synthesis_modal.show_synthesis(_get_synthesis_data(), true)
		, CONNECT_ONE_SHOT)
	else:
		AudioManager.play_error()
		var error_msg = ""
		if active_slot_cards[0]["id"] == "output":
			error_msg = "Você colocou 'Servir o Bolo' antes de tudo! Como a máquina vai entregar uma resposta se nem recebeu os ingredientes e nem fez nenhuma conta?"
		elif active_slot_cards[0]["id"] == "calc":
			error_msg = "Você tentou 'Bater a Massa' com a tigela vazia! Primeiro precisamos do Cartão de Ingredientes (Entrada de Dados) para que o computador saiba quais números usar."
		elif active_slot_cards[1]["id"] == "decision":
			error_msg = "Você tentou espetar o palito no forno antes mesmo de bater a massa! Primeiro processamos os dados, e só depois checamos se precisamos repetir."
		elif active_slot_cards[2]["id"] == "output":
			error_msg = "Você serviu o bolo antes de checar se estava assado! O teste de Decisão precisa vir antes da Saída para garantir que a conta terminou."
		else:
			error_msg = "Ordem incorreta! Lembre-se da lógica da cozinha: 1º Ingredientes (Entrada) -> 2º Preparo (Processamento) -> 3º Teste do Palito (Decisão) -> 4º Servir (Saída)."
		
		card_info_box.text = "[color=#bf616a][b]Opa, algo deu errado:[/b] " + error_msg + "[/color]"
		label_status.text = "Dê uma olhada no diagnóstico acima e tente reorganizar os passos!"
		label_status.modulate = Color(1.0, 0.35, 0.35)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 1: Ada Lovelace (1843)",
		"pioneer_text": "[b][color=#ffd54f]Quem foi a pioneira?[/color][/b]\nAugusta Ada King, Condessa de Lovelace (1815–1852), foi uma matemática e escritora inglesa, filha do poeta Lord Byron.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5):[/color][/b]\nNo século XIX, as mulheres eram proibidas de frequentar universidades e o meio científico britânico achava que mulheres 'não tinham cérebro para matemática'. Apesar do preconceito, Ada estudou com dedicação e teve a coragem de propor que máquinas podiam pensar muito além de simples calculadoras.",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nAo estudar a Máquina Analítica de Charles Babbage, Ada escreveu as famosas [b]'Notas de Lovelace' (Nota G)[/b] em 1843.\n\nEsse texto é considerado o [b]primeiro programa de computador da história[/b]! Ela percebeu que a máquina podia compor músicas, tecer padrões e desenhar se recebesse as instruções certas.",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]O que é um Algoritmo?[/b]\nUm algoritmo nada mais é do que uma receita passo a passo que o computador segue sem inventar nem pular etapas:\n• [b]1. Entrada (Ingredientes):[/b] O que colocamos no computador (dados);\n• [b]2. Processamento (Bater a Massa):[/b] As contas e transformações;\n• [b]3. Decisão (Checar o Palito):[/b] Testes com 'SE' (o cálculo acabou ou repete?);\n• [b]4. Saída (Servir o Bolo):[/b] O resultado final entregue a quem pediu.",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nQuando você abre o WhatsApp, pesquisa no Google, assiste a um vídeo no YouTube ou conversa com uma Inteligência Artificial, [b]todo esse mundo digital só existe por causa da lógica criada por Ada Lovelace[/b] há quase 200 anos!\n\nEla provou que uma mulher foi a primeira mente a programar na história da humanidade."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("ada")
		btn_next_stage.show()
		label_status.text = "Síntese consolidada! Clique no botão abaixo para avançar até 1945 com as ENIAC Girls."

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(2)
