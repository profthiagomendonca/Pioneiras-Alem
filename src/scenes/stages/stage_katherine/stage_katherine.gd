extends Control

@onready var dialogue_box = $DialogueBox
@onready var slider_angle: HSlider = %SliderAngle
@onready var slider_velocity: HSlider = %SliderVelocity
@onready var slider_retro: HSlider = %SliderRetro
@onready var val_angle: Label = %ValAngle
@onready var val_velocity: Label = %ValVelocity
@onready var val_retro: Label = %ValRetro
@onready var label_status: Label = %LabelStatus
@onready var label_corridor: Label = %LabelCorridor
@onready var btn_calculate: Button = %BtnCalculate
@onready var btn_next_stage: Button = %BtnNextStage
@onready var btn_learning_card: Button = %BtnLearningCard
@onready var btn_menu: Button = %BtnMenu

var ruler_texture = preload("res://src/assets/textures/icons/Regua_nasa.png")
var synthesis_modal_scene = preload("res://src/scenes/stages/stage_synthesis_modal.tscn")
var synthesis_modal: PanelContainer = null
var start_time: float = 0.0

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.0
	GameState.record_attempt("katherine")
	var portrait_icon = TextureRect.new()
	portrait_icon.custom_minimum_size = Vector2(38, 38)
	portrait_icon.texture = preload("res://src/assets/textures/portraits/Katherine Johnson.png")
	portrait_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	$HeaderPanel/Margin/HeaderBar.add_child(portrait_icon)
	$HeaderPanel/Margin/HeaderBar.move_child(portrait_icon, 0)

	btn_calculate.icon = ruler_texture
	btn_calculate.expand_icon = true
	btn_menu.pressed.connect(func():
		AudioManager.play_click()
		GameState.go_to_main_menu()
	)
	btn_calculate.pressed.connect(_on_btn_calculate_pressed)
	btn_next_stage.pressed.connect(_on_btn_next_stage_pressed)
	btn_next_stage.hide()

	if btn_learning_card:
		btn_learning_card.pressed.connect(_on_btn_learning_card_pressed)

	# Instanciar modal de síntese
	synthesis_modal = synthesis_modal_scene.instantiate()
	add_child(synthesis_modal)
	synthesis_modal.closed.connect(_on_synthesis_closed)

	slider_angle.value_changed.connect(_on_slider_changed)
	slider_velocity.value_changed.connect(_on_slider_changed)
	slider_retro.value_changed.connect(_on_slider_changed)

	_update_labels()
	_start_intro_dialogue()

func _on_btn_learning_card_pressed() -> void:
	AudioManager.play_click()
	synthesis_modal.show_synthesis(_get_synthesis_data(), false)

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Olá! Sou Katherine Johnson, matemática da NASA. Em 1962, os primeiros computadores eletrônicos da IBM calcularam a trajetória do astronauta John Glenn na cápsula Friendship 7."
		},
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Glenn desconfiava das máquinas novas e disse: 'Peçam para a garota conferir os números na ponta do lápis. Se ela disser que estão certos, estou pronto para voar!'"
		},
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Seu desafio: consulte o meu Caderno de Anotações no topo da tela, deduza os valores seguros e clique em 'Simular Trajetória' para testar a rota!"
		}
	]
	dialogue_box.start_dialogue(lines)

func _on_slider_changed(_val: float) -> void:
	_update_labels()

func _update_labels() -> void:
	var a = slider_angle.value
	var v = slider_velocity.value
	var r = slider_retro.value

	val_angle.text = str(snapped(a, 0.1)) + "°"
	val_velocity.text = str(int(v)) + " mph"
	val_retro.text = str(int(r)) + " s"

	# Atualização limpa da telemetria sem dar spoiler antecipado
	label_corridor.text = "Telemetria Atual: Ângulo: " + str(snapped(a, 0.1)) + "° | Velocidade: " + str(int(v)) + " mph | Freio: " + str(int(r)) + " s"
	label_corridor.modulate = Color(0.75, 0.88, 1.0)

func _on_btn_calculate_pressed() -> void:
	var a = slider_angle.value
	var v = slider_velocity.value
	var r = slider_retro.value

	var ok_a = (a >= 6.5 and a <= 7.1)
	var ok_v = (v >= 17300 and v <= 17700)
	var ok_r = (r >= 28 and r <= 32)

	if ok_a and ok_v and ok_r:
		AudioManager.play_success()
		var duration = (Time.get_ticks_msec() / 1000.0) - start_time
		GameState.complete_stage("katherine", duration, 220)
		GameState.unlock_next_stage(4)

		label_corridor.text = "✨ SIMULAÇÃO BEM-SUCEDIDA: A nave entrou suavemente no corredor atmosférico!"
		label_corridor.modulate = Color(0.3, 1.0, 0.5)

		label_status.text = "POUSO CONFIRMADO NO OCEANO! O astronauta John Glenn foi resgatado com total segurança graças aos seus cálculos!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_calculate.disabled = true

		var win_lines: Array[Dictionary] = [
			{
				"speaker": "Katherine Johnson (1962)",
				"color": Color(0.35, 0.6, 0.95),
				"text": "Simulação perfeita! Seus cálculos dedutivos garantiram a reentrada com precisão milimétrica."
			},
			{
				"speaker": "Katherine Johnson (1962)",
				"color": Color(0.35, 0.6, 0.95),
				"text": "Você provou por que a mente humana é insubstituível na verificação científica. Veja agora no nosso Cartão de Conquista como nós, mulheres negras na NASA, fizemos história!"
			}
		]
		dialogue_box.start_dialogue(win_lines)
		dialogue_box.dialogue_finished.connect(func():
			synthesis_modal.show_synthesis(_get_synthesis_data(), true)
		, CONNECT_ONE_SHOT)
	else:
		AudioManager.play_error()
		var diag = ""
		if not ok_a:
			if a > 7.1:
				diag = "🔥 Simulação Falhou: Ângulo de " + str(snapped(a, 0.1)) + "° é íngreme demais! A nave aqueceu acima de 1.600°C e o escudo térmico quase queimou. Dica do Caderno: Suavize a inclinação!"
			else:
				diag = "🌌 Simulação Falhou: Ângulo de " + str(snapped(a, 0.1)) + "° é deitado demais! A cápsula bateu no ar e quicou para o vácuo espacial. Dica do Caderno: Incline um pouco mais a cápsula!"
		elif not ok_v:
			diag = "⚡ Simulação Falhou: Velocidade de " + str(int(v)) + " mph fora do limite orbital! Dica do Caderno: Ajuste a velocidade para perto de 17.500 mph para a descida suave."
		else:
			diag = "🌊 Simulação Falhou: Tempo de freio dos retrofoguetes de " + str(int(r)) + " s incorreto! A nave caiu fora do ponto de resgate. Dica do Caderno: O freio a jato precisa queimar por cerca de meio minuto (30s)!"

		label_corridor.text = "⚠️ Alerta de Reentrada: Parâmetros inseguros detectados na simulação!"
		label_corridor.modulate = Color(1.0, 0.65, 0.3)
		label_status.text = diag
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _get_synthesis_data() -> Dictionary:
	return {
		"stage_title": "Era 4: Katherine Johnson (1962)",
		"pioneer_text": "[b][color=#ffd54f]Quem foi a pioneira?[/color][/b]\nKatherine Coleman Goble Johnson (1918–2020) foi uma brilhante matemática e física aeroespacial norte-americana que trabalhou na NASA.\n\n[b][color=#ef5350]Barreiras Históricas (ODS 5 e ODS 10):[/color][/b]\nKatherine enfrentou uma dupla barreira esmagadora: o sexismo científico e a violenta segregação racial (Leis Jim Crow nos EUA). Ela era obrigada a usar banheiros separados a centenas de metros de distância e não tinha direito a assinar os relatórios científicos que escrevia, até conquistar o respeito de todos pela pura genialidade de suas contas.",
		"history_text": "[b][color=#4fc3f7]Contribuição Histórica:[/color][/b]\nEla calculou a trajetória do voo de Alan Shepard (primeiro americano no espaço), a rota da cápsula Friendship 7 de John Glenn e as janelas de lançamento da histórica missão Apollo 11 que levou a humanidade à Lua em 1969.\n\nSua precisão manual foi o padrão de ouro que validou a transição para os computadores eletrônicos na NASA.",
		"concept_text": "[b][color=#81c784]O que você acabou de aprender?[/color][/b]\n[b]Auditoria e Confiabilidade de Sistemas:[/b]\nUm computador apenas calcula o que os seres humanos mandam. Se o programa tiver um erro nas contas, a máquina errará na velocidade da luz!\n\nKatherine nos ensina que a [b]auditoria humana, o pensamento crítico e a verificação matemática[/b] são fundamentais para que sistemas críticos (em aviões, hospitais e foguetes) nunca falhem.",
		"today_text": "[b][color=#ff8a65]Por que isso importa na sua vida hoje?[/color][/b]\nQuando você pega um avião com piloto automático, usa o GPS do carro ou confia em um robô cirúrgico, esses sistemas utilizam os mesmos princípios de verificação e segurança desenvolvidos por Katherine Johnson!\n\nSua trajetória é um dos maiores símbolos mundiais de resiliência e combate ao racismo e à desigualdade de gênero."
	}

func _on_synthesis_closed(is_victory: bool) -> void:
	if is_victory:
		GameState.mark_synthesis_read("katherine")
		btn_next_stage.show()
		label_status.text = "Síntese consolidada! Clique no botão abaixo para avançar até 1964 com a Irmã Mary Kenneth Keller."

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(5)
