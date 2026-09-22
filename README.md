# Pioneiras & Além: O Código Invisível

> Jogo educacional e narrativo em Godot 4 sobre o protagonismo feminino na história da computação, desenvolvido para que as mulheres reconheçam e aprendam seu lugar na história, sendo alinhado ao ODS 05 (Igualdade de Gênero).

Pioneiras & Além é um jogo sério educacional e narrativo concebido para resgatar, valorizar e visibilizar o papel fundacional das mulheres na construção da ciência da computação. Historicamente, muitas das maiores contribuições femininas para o desenvolvimento de hardware, software, linguagens de programação e mecânica espacial foram minimizadas, esquecidas ou atribuídas exclusivamente a figuras masculinas. O jogo confronta esse apagamento histórico ao colocar a liderança intelectual de cientistas mulheres no centro da experiência pedagógica.

Alinhado ao Objetivo de Desenvolvimento Sustentável 05 (Igualdade de Gênero) e ao ODS 04 (Educação de Qualidade), o projeto busca despertar o sentimento de representatividade e pertencimento em meninas e jovens estudantes, demonstrando que a tecnologia não é apenas um espaço a ser conquistado por mulheres, mas um campo que foi fundado, programado e consolidado por elas.

## Proposta Pedagógica e Representatividade

A experiência foi planejada para superar a transmissão passiva de dados biográficos. Em vez de apenas ler sobre essas pioneiras, o participante vivencia os desafios conceituais enfrentados por cada uma, compreendendo na prática como suas decisões arquiteturais e matemáticas moldaram o mundo moderno.

O ambiente de jogo integra instrumentos de avaliação de aprendizagem e percepção sobre o papel da mulher nas ciências exatas. A cada partida, o sistema monitora métricas de raciocínio, tempo de dedução e tentativas, permitindo avaliar a eficácia do jogo na conscientização histórica e na desconstrução de estereótipos de gênero que ainda permeiam a área tecnológica.

## As Seis Eras do Protagonismo Feminino

A progressão do jogo acompanha seis momentos decisivos da evolução computacional, evidenciando como a liderança de mulheres foi indispensável para o sucesso de cada empreendimento.

### Fase 1: Ada Lovelace (1843) — A Visão do Software
Muito antes da existência dos computadores eletrônicos, Ada Lovelace foi a primeira pessoa a compreender que a Máquina Analítica de Charles Babbage não se limitava a cálculos aritméticos, podendo manipular símbolos e compor arte caso fosse instruída por regras lógicas. O desafio recria a Nota G, na qual Lovelace documentou o primeiro algoritmo da história humana para o cálculo dos Números de Bernoulli, exigindo do jogador a estruturação lógica correta do fluxo de instruções e laços condicionais.

### Fase 2: As Garotas do ENIAC (1945) — As Pioneiras da Programação Prática
Quando o primeiro computador eletrônico de grande escala entrou em operação, a construção do hardware foi amplamente divulgada, mas a programação da máquina foi relegada aos bastidores e confiada a seis matemáticas: Kathleen McNulty, Frances Bilas, Betty Jean Jennings, Ruth Lichterman, Elizabeth Snyder e Marlyn Wescoff. Sem linguagens formais, manuais ou sistemas operacionais, elas decifraram diagramas lógicos e programaram o ENIAC manipulando centenas de cabos e chaves manuais. O jogo homenageia essas pioneiras desafiando o jogador a interconectar fisicamente acumuladores e unidades de controle balístico.

### Fase 3: Grace Hopper (1947) — A Gênese dos Compiladores
Almirante da Marinha norte-americana e cientista da computação, Grace Hopper desafiou o consenso de sua época ao defender que humanos deveriam programar utilizando linguagens próximas da fala cotidiana em vez de código de máquina binário. Criadora do primeiro compilador (A-0) e precursora do COBOL, Hopper também imortalizou o termo bug ao registrar a retirada de uma mariposa presa nos relés do Harvard Mark II. O jogador assume o desafio de inspecionar os bancos de relés eletromecânicos, localizar a falha física e compilar instruções estruturadas.

### Fase 4: Katherine Johnson (1962) — A Precisão que Conquistou o Espaço
Matemática brilhante que superou as profundas barreiras da segregação racial e de gênero nos Estados Unidos, Katherine Johnson tornou-se referência indispensável na NASA por sua excepcional acurácia de cálculo em mecânica orbital. Sua perícia era tão respeitada que o astronauta John Glenn recusou-se a embarcar na missão orbital Friendship 7 até que Katherine verificasse manualmente as trajetórias calculadas pelos novos computadores da IBM. O desafio coloca o jogador no papel de Katherine, auditando variáveis de empuxo, azimute e ângulo de reentrada atmosférica.

### Fase 5: Irmã Mary Kenneth Keller (1965) — A Educação e a Popularização da Computação
Primeira mulher a concluir o doutorado em Ciência da Computação nos Estados Unidos, pela Universidade de Wisconsin, a Irmã Mary Kenneth Keller anteviu que o computador deveria ser uma extensão do raciocínio humano aberta a todas as áreas do conhecimento. Co-desenvolvedora da linguagem BASIC no Dartmouth College, Keller dedicou sua vida a democratizar a tecnologia, fundar departamentos acadêmicos e acolher pesquisadores iniciantes. O jogo recria seu espírito pedagógico através de desafios de sintaxe estruturada pensados para ensinar a programar com clareza.

### Fase 6: Margaret Hamilton (1969) — A Criação da Engenharia de Software
Diretora da Divisão de Engenharia de Software do Laboratório de Instrumentação do MIT, Margaret Hamilton cunhou o próprio termo Engenharia de Software para exigir que o desenvolvimento de sistemas recebesse o mesmo rigor conferido a outras engenharias tradicionais. Sua arquitetura de agendamento assíncrono por prioridade evitou uma catástrofe a três minutos do pouso da Apollo 11: quando o radar de acoplamento sobrecarregou a CPU do computador de bordo (Alarme 1202), o software de Hamilton descartou tarefas supérfluas e manteve os motores operantes, assegurando a chegada segura da humanidade à Lua. O jogador assume o controle desse agendador crítico para estabilizar o sistema e autorizar o pouso no solo lunar.

## Especificações Técnicas e Arquitetura

O projeto foi inteiramente concebido na Godot Engine 4, utilizando GDScript modular sem dependências externas proprietárias.

1. Compatibilidade Gráfica: Desenvolvido sobre o backend WebGL 2.0 (gl_compatibility), garantindo carregamento ágil e execução responsiva em computadores e dispositivos móveis.
2. Identidade Visual Vetorial: Telas em resolução nativa de 1280x720 pixels com renderização SVG para ícones e botões, prevenindo problemas de incompatibilidade de fontes ou caracteres especiais.
3. Sonorização Procedural: Integração de trilha temática na tela inicial com sistema próprio de síntese sonora em tempo real para os efeitos de interação, clique e validação em cada desafio.
4. Isolamento de Origem: Configuração robusta de cabeçalhos HTTP no servidor de produção, incluindo Cross-Origin-Opener-Policy (same-origin) e Cross-Origin-Embedder-Policy (require-corp), essenciais para viabilizar os recursos de memória compartilhada (SharedArrayBuffer) do WebAssembly em navegadores atualizados.

## Execução a partir do Código-Fonte

Para explorar o projeto localmente no ambiente de desenvolvimento:

1. Obtenha o Godot Engine versão 4.2 ou superior.
2. Clone este repositório:
   git clone https://github.com/profthiagomendonca/Pioneiras-Alem.git
3. Abra o gerenciador de projetos do Godot, selecione a opção Importar e escolha o arquivo project.godot presente na raiz deste repositório.
4. Pressione F5 para executar o jogo.

## Acesso Direto à Versão Web

A versão do jogo pronta para execução imediata em navegador está hospedada no seguinte endereço:

https://pioneirasealem.netlify.app/
