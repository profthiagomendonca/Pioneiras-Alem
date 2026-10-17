extends Control

@onready var portrait_rect: TextureRect = %PortraitRect
@onready var title_label: Label = %TitleLabel
@onready var text_content: RichTextLabel = %TextContent
@onready var btn_section_1: Button = %BtnSection1
@onready var btn_section_2: Button = %BtnSection2
@onready var btn_section_3: Button = %BtnSection3
@onready var btn_finish: Button = %BtnFinish

var portrait_path: String = "res://src/assets/textures/portraits/Edith.png"
var portrait_fallback_path: String = "res://src/assets/textures/portraits/Edith_Ranzini.png"

func _ready() -> void:
	AudioManager.play_bgm()
	
	if ResourceLoader.exists(portrait_path):
		portrait_rect.texture = load(portrait_path)
	elif ResourceLoader.exists(portrait_fallback_path):
		portrait_rect.texture = load(portrait_fallback_path)
	
	btn_section_1.pressed.connect(func(): _show_section(1))
	btn_section_2.pressed.connect(func(): _show_section(2))
	btn_section_3.pressed.connect(func(): _show_section(3))
	btn_finish.pressed.connect(_on_btn_finish_pressed)
	
	_show_section(1)

func _show_section(sec: int) -> void:
	AudioManager.play_click()
	
	btn_section_1.modulate = Color(0.96, 0.82, 0.36) if sec == 1 else Color.WHITE
	btn_section_2.modulate = Color(0.96, 0.82, 0.36) if sec == 2 else Color.WHITE
	btn_section_3.modulate = Color(0.96, 0.82, 0.36) if sec == 3 else Color.WHITE
	
	match sec:
		1:
			text_content.text = "[b][color=#ffd54f]Profa. Dra. Edith Ranzini (1972) — Pioneira da Computação Brasileira[/color][/b]\n\n"
			text_content.text += "Nascida no Brasil, Edith Ranzini graduou-se em Engenharia Elétrica pela Escola Politécnica da USP (Poli-USP). Em uma época em que o campo da engenharia e da nascente computação era quase exclusivamente masculino, ela integrou o histórico Laboratório de Sistemas Digitais (LSD, atual LARC).\n\n"
			text_content.text += "Sua liderança e dedicação à docência estenderam-se por décadas na Poli-USP e na Pontifícia Universidade Católica de São Paulo (PUC-SP), onde atuou como professora titular e diretora, formando gerações pioneiras de cientistas da computação no país."
		2:
			text_content.text = "[b][color=#81c784]O Patinho Feio: O Primeiro Computador Projetado e Construído no Brasil[/color][/b]\n\n"
			text_content.text += "Em 1971-1972, o Brasil dependia integralmente da importação de grandes computadores estrangeiros. Diante do desafio de provar a capacidade técnico-científica nacional, a equipe da USP desenvolveu o [b]'Patinho Feio'[/b] — um minicomputador de 8 bits com memória de ferrite e circuitos integrados TTL.\n\n"
			text_content.text += "O sucesso do Patinho Feio demonstrou que o Brasil possuía competência para conceber hardware e software de ponta, abrindo caminho para a criação da empresa nacional COBRA e para a consolidação da pós-graduação em Computação no Brasil."
		3:
			text_content.text = "[b][color=#4fc3f7]ODS 5: Diversidade, Soberania e Representatividade Latino-Americana[/color][/b]\n\n"
			text_content.text += "A história de Edith Ranzini lembra que a história da tecnologia não ocorreu apenas no eixo Estados Unidos-Europa. No Brasil e na América Latina, mulheres engenheiras e pesquisadoras foram essenciais para a autonomia tecnológica e para o ensino superior.\n\n"
			text_content.text += "[b]Por que isso importa hoje?[/b]\n"
			text_content.text += "Incentivar meninas e mulheres a ingressarem nas carreiras de Ciência, Tecnologia, Engenharia e Matemática (STEM) é manter vivo esse legado de inovação e coragem. As mulheres não são visitantes na Computação: elas são fundadoras e construtoras do nosso futuro digital!"

func _on_btn_finish_pressed() -> void:
	AudioManager.play_click()
	GameState.go_to_victory()
