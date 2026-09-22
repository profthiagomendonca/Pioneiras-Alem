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
@onready var btn_menu: Button = %BtnMenu

var ruler_texture = preload("res://src/assets/textures/icons/Regua_nasa.png")
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

	slider_angle.value_changed.connect(_on_slider_changed)
	slider_velocity.value_changed.connect(_on_slider_changed)
	slider_retro.value_changed.connect(_on_slider_changed)

	_update_labels()
	_start_intro_dialogue()

func _start_intro_dialogue() -> void:
	var lines: Array[Dictionary] = [
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Olá! Sou Katherine Johnson, matemática e física da NASA. Em 1962, os novos computadores eletrônicos da IBM calcularam a trajetória orbital para o astronauta John Glenn."
		},
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Glenn não confiava nas máquinas cegas e pediu: 'Peçam para a garota conferir os números na mão. Se ela disser que estão certos, estou pronto para voar!'"
		},
		{
			"speaker": "Katherine Johnson (1962)",
			"color": Color(0.35, 0.6, 0.95),
			"text": "Ajuste os 3 parâmetros orbitais para calibrar a janela de reentrada na atmosfera: ângulo de descida, velocidade orbital e tempo de retrofoguetes!"
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

	# Verificação dinâmica do corredor
	var ok_a = (a >= 6.5 and a <= 7.1)
	var ok_v = (v >= 17300 and v <= 17700)
	var ok_r = (r >= 28 and r <= 32)

	if ok_a and ok_v and ok_r:
		label_corridor.text = "CORREDOR DE REENTRADA: PERFEITO (TRAJETÓRIA SEGURA)"
		label_corridor.modulate = Color(0.3, 1.0, 0.5)
	elif not ok_a:
		if a > 7.1:
			label_corridor.text = "ALERTA: Ângulo muito íngreme! Risco de calor excessivo."
		else:
			label_corridor.text = "ALERTA: Ângulo muito raso! A cápsula ricocheteará no espaço."
		label_corridor.modulate = Color(1.0, 0.4, 0.4)
	else:
		label_corridor.text = "CORREDOR DE REENTRADA: FORA DA JANELA NOMINAL"
		label_corridor.modulate = Color(1.0, 0.85, 0.3)

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

		label_status.text = "Trajetória confirmada! Friendship 7 pousou no Oceano Atlântico com sucesso milimétrico!"
		label_status.modulate = Color(0.3, 1.0, 0.5)
		btn_calculate.disabled = true
		btn_next_stage.show()

		var win_lines: Array[Dictionary] = [
			{
				"speaker": "Katherine Johnson (1962)",
				"color": Color(0.35, 0.6, 0.95),
				"text": "Fantástico! John Glenn completou as três órbitas ao redor da Terra e retornou em segurança."
			},
			{
				"speaker": "Katherine Johnson (1962)",
				"color": Color(0.35, 0.6, 0.95),
				"text": "Nossos cálculos manuais na NASA demonstraram que a mente humana é o coração de qualquer avanço tecnológico."
			},
			{
				"speaker": "Katherine Johnson (1962)",
				"color": Color(0.35, 0.6, 0.95),
				"text": "Vamos agora avançar para 1965 e conhecer a Irmã Mary Kenneth Keller, a primeira pessoa a obter um Ph.D. em Computação!"
			}
		]
		dialogue_box.start_dialogue(win_lines)
	else:
		AudioManager.play_error()
		label_status.text = "Cálculo orbital instável! Alinhe o ângulo (~6.8°), a velocidade (~17.500 mph) e o tempo de queima (~30s)."
		label_status.modulate = Color(1.0, 0.4, 0.4)

func _on_btn_next_stage_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_stage(5)
