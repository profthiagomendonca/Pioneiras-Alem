# Pioneiras & Além: Desenvolvimento, Aplicação e Análise de um Jogo Digital Educativo para a Promoção da Equidade de Gênero e o Ensino do Pensamento Computacional

**Thiago Jesus de Mendonça¹**, **Leonardo Donadoni²**, **Daniela Farago de Lima³**  
¹²³ Mestrado Profissional em Ensino de Computação (PROFCOMP) — Universidade Estadual do Norte do Paraná (UENP)  
*E-mails:* `thiagojmendonca@hotmail.com`, `leonardodonadoni168@gmail.com`, `danifaragolima@gmail.com`

---

### Resumo
Ensinar conceitos fundamentais de Ciência da Computação na Educação Básica frequentemente esbarra na abstração conceitual e no desinteresse dos estudantes. Contudo, essa barreira pedagógica é profundamente agravada pela escassez de representatividade histórica feminina, fruto de um processo sociocultural de invisibilização e segregação de gênero no campo científico-tecnológico. Para responder de forma integrada a esses desafios, desenvolveu-se o **Pioneiras & Além**, uma aplicação web interativa desenvolvida na engine Godot 4. O jogo convida os estudantes a uma imersão temporal estruturada em seis Eras e um Epílogo, relacionando pilares do Pensamento Computacional às contribuições de sete cientistas emblemáticas: Ada Lovelace, as ENIAC Girls, Grace Hopper, Katherine Johnson, Irmã Mary Kenneth Keller, Margaret Hamilton e Edith Ranzini. Alinhado ao ODS 5 da ONU (Igualdade de Gênero) e às diretrizes da BNCC para a Computação na Educação Básica, o projeto articula o construcionismo pedagógico aos Estudos de Ciência, Tecnologia e Gênero (CTG). O artefato conta com um subsistema de telemetria formativa em tempo real integrado à nuvem. A intervenção prática realizada com alunos do 8º e 9º anos de uma escola pública paranaense demonstrou elevado engajamento, estímulo à aprendizagem colaborativa, persistência diante de erros e perceptível ganho de autoeficácia e identificação vocacional, especialmente entre as alunas.

**Palavras-Chave:** Gamificação; Ensino de Computação; Pensamento Computacional; Jogo Digital Educativo; Representatividade Feminina; Ciência, Tecnologia e Gênero; ODS 5.

### Abstract
Teaching fundamental concepts of Computer Science in Basic Education often faces barriers of conceptual abstraction and student disengagement. However, this pedagogical hurdle is deeply compounded by the scarcity of historical female representation, resulting from a sociocultural process of invisibilization and gender segregation in science and technology. To address these interconnected challenges, this paper presents **Pioneiras & Além**, an interactive serious game developed using the Godot 4 engine and distributed via WebAssembly. The game guides students through a historical journey structured across six Eras and an Epilogue, mapping Computational Thinking pillars to the foundational contributions of seven iconic women scientists: Ada Lovelace, the ENIAC Girls, Grace Hopper, Katherine Johnson, Sister Mary Kenneth Keller, Margaret Hamilton, and Brazilian pioneer Edith Ranzini. Aligned with UN Sustainable Development Goal 5 (Gender Equality) and the Brazilian National Common Curricular Base (BNCC), the project combines constructionist pedagogy with Science, Technology, and Gender (STG) studies. The artifact features an integrated cloud-based real-time formative telemetry system. A practical intervention conducted with 8th and 9th grade students in a Brazilian public school revealed high engagement, collaborative problem-solving, resilience in error debugging, and a measurable increase in self-efficacy and career identification, particularly among female students.

**Keywords:** Gamification; Computer Science Education; Computational Thinking; Educational Digital Game; Female Representation; Science, Technology and Gender; SDG 5.

---

## 1. Introdução

A inserção da Ciência da Computação na Educação Básica consolida-se contemporaneamente como uma exigência estrutural para a formação cidadã crítica e o desenvolvimento do raciocínio lógico no século XXI. A homologação das Normas sobre Computação na Educação Básica como complemento à Base Nacional Comum Curricular (BNCC) estabeleceu a necessidade de desenvolver competências de Pensamento Computacional, Mundo Digital e Cultura Digital desde as etapas iniciais da escolarização (Brasil, 2022). Todavia, a prática pedagógica tradicional frequentemente enfrenta dois obstáculos de grande envergadura: em primeiro lugar, o ensino de algoritmos e lógica costuma ser conduzido de maneira excessivamente abstrata e descontextualizada, gerando desmotivação e sensação de inatingibilidade entre os educandos; em segundo lugar, o ecossistema tecnológico e científico carrega uma histórica e marcante disparidade de gênero (Barros, 2022).

Historicamente, a gênese da computação moderna contou com o protagonismo direto de mulheres que fundaram bases conceituais, metodológicas e práticas indispensáveis: desde o desenvolvimento do primeiro algoritmo por Ada Lovelace em 1843, passando pela programação física do primeiro computador eletrônico digital pelas programadoras do ENIAC em 1945, a criação do compilador e a consolidação de linguagens de alto nível por Grace Hopper em 1947, os cálculos de mecânica orbital de Katherine Johnson em 1962, a democratização do ensino com a linguagem BASIC pela Irmã Mary Kenneth Keller em 1965, até a fundação da Engenharia de Software por Margaret Hamilton no Projeto Apollo 11 em 1969. No contexto latino-americano, destaca-se pioneiramente a atuação da Profa. Dra. Edith Ranzini no desenvolvimento do primeiro minicomputador brasileiro, o *Patinho Feio*, em 1972 (Lima, 2013).

A despeito dessa riqueza factual, operou-se ao longo da segunda metade do século XX um processo sistemático de masculinização da área tecnológica e apagamento memorial da atuação feminina (Schiebinger, 1999). Com a emergência dos computadores domésticos comercializados primordialmente como artefatos masculinos a partir dos anos 1980, as taxas de ingresso e permanência de mulheres nos cursos de Ciências Exatas e Tecnologia sofreram retração acentuada — fenômeno sociológico conhecido como segregação horizontal ou territorial (Carneiro, 2018). Essa ausência de modelos representativos de identificação (*role models*) nos currículos escolares retroalimenta estereótipos que afastam precocemente meninas de carreiras de base tecnológica.

Com o propósito de superar concomitantemente a abstração dos conceitos de computação e combater a invisibilização histórica feminina, desenvolveu-se o jogo digital educativo **Pioneiras & Além**. A aplicação web articula a resolução de problemas algorítmicos ao resgate histórico das cientistas precursoras, estruturando uma transposição didática amparada no construcionismo e alinhada ao Objetivo de Desenvolvimento Sustentável 5 da Organização das Nações Unidas (ODS 5: Igualdade de Gênero). 

O presente artigo apresenta o percurso completo da pesquisa: a fundamentação teórica que ampara a proposta, o estado da arte e contraste com trabalhos correlatos, as escolhas de engenharia e materiais de desenvolvimento do jogo, os procedimentos metodológicos da intervenção prática em escola pública e a discussão aprofundada dos resultados quanti-qualitativos obtidos por meio de observação participativa e telemetria automatizada.

---

## 2. Fundamentação Teórica

### 2.1 Pensamento Computacional e Aprendizagem Baseada em Jogos (GBL)

O Pensamento Computacional (PC), conceituado por Wing (2006), compreende os processos mentais envolvidos na formulação de problemas e na expressão de suas soluções de modo que um agente processador de informações (seja ele humano ou computacional) possa executá-las com eficácia. Seus pilares estruturantes englobam:
1. **Decomposição:** fragmentação de um desafio complexo em partes menores e gerenciáveis;
2. **Reconhecimento de Padrões:** identificação de similaridades, regularidades e tendências;
3. **Abstração:** filtragem dos detalhes secundários para focar estritamente nas variáveis essenciais;
4. **Pensamento Algorítmico:** estruturação ordenada de instruções passo a passo para atingir um resultado previsível.

Gresse von Wangenheim et al. (2019) salientam que a apropriação do PC na Educação Básica não deve restringir-se à memorização precoce de sintaxes de linguagens profissionais de programação. Ao contrário, o raciocínio computacional floresce com maior robustez quando mediado por atividades interativas, lúdicas e ricas em significado.

Nesse prisma, a Aprendizagem Baseada em Jogos (*Game-Based Learning* — GBL) desponta como paradigma pedagógico fecundo ao integrar mecânicas lúdicas a metas instrucionais intencionais (Barradas & Lencastre, 2017). Diferentemente da simples gamificação por pontuação externa, os *serious games* promovem a aprendizagem experiencial. Essa perspectiva vincula-se diretamente ao construcionismo de Seymour Papert (1980) e à espiral da aprendizagem criativa de Mitchel Resnick (2013): o conhecimento é construído de maneira mais significativa quando o aprendiz engaja-se ativamente na confecção e manipulação de um artefato palpável dentro de um "micromundo" dinâmico. 

No contexto de jogos educativos digitais, a mecânica deve funcionar como espelho conceitual do conteúdo curricular (Gomes & Melo, s.d.). Mais do que isso, o ambiente de jogo ressignifica o erro: o *bug* ou a falha deixam de ser motivo de punição ou frustração e passam a atuar como convite à análise lógica, experimentação de hipóteses e depuração iterativa (*debugging*).

### 2.2 Estudos de Ciência, Tecnologia e Gênero (CTG) e o Efeito *Role Model*

A dimensão sociocultural desta investigação fundamenta-se nos Estudos de Ciência, Tecnologia e Gênero (CTG), desenvolvidos amplamente por autoras como Schiebinger (1999), Garcia e Sedeño (2006) e Barros (2022). O campo CTG desmistifica a neutralidade axiológica da ciência, evidenciando como relações de poder e construções socioculturais historicamente privilegiaram a presença masculina nos centros de prestígio técnico-científico.

A literatura categoriza a sub-representação feminina em duas formas de segregação complementares:
* **Segregação Vertical ("Teto de Vidro"):** barreiras sutis e culturais que impedem ou retardam a ascensão de mulheres aos postos de liderança, docência titular e coordenação de projetos estratégicos;
* **Segregação Horizontal ("Campos Murados"):** canalização sociocultural que direciona mulheres para profissões voltadas ao cuidado e ciências humanas, enquanto homens são incentivados desde a infância à exploração de ferramentas, mecânica e raciocínio exato (Carneiro, 2018).

A psicologia social e a pedagogia crítica demonstram que a presença explícita de modelos femininos de referência (*role models*) exerce influência determinante sobre a percepção de autoeficácia de estudantes do gênero feminino (Bandura, 1997; Lima, 2013). Ao testemunharem que mulheres foram as criadoras de conceitos estruturantes da tecnologia que utilizam em seus smartphones e computadores, as estudantes desconstroem o sentimento de inadequação e ampliam seu horizonte de aspiração acadêmica e profissional. A articulação entre GBL e CTG estabelece, portanto, um ambiente propício para a convergência entre aprendizagem técnica e emancipação social (Figura 1).

> **Síntese Teórica Articulada:**  
> A conjugação entre o *Construcionismo Tecnológico* (o estudante como construtor ativo de soluções algorítmicas) e a *Abordagem Histórico-Crítica de Gênero* (resgate das pioneiras como sujeitos históricos da ciência) constitui a espinha dorsal pedagógica do jogo educativo.

---

## 3. Trabalhos Relacionados

A análise do estado da arte revela diversas abordagens direcionadas ao ensino introdutório de computação e à atração de estudantes para a área de Tecnologia da Informação. Esses trabalhos podem ser agrupados em três categorias principais:

### 3.1 Jogos Digitais Comerciais e Educacionais de Programação
Títulos como *LightBot*, *CodeCombat* e *Human Resource Machine* obtiveram expressiva adoção internacional no ensino de lógica de programação. Tais ferramentas utilizam quebra-cabeças mecânicos para exercitar conceitos de laços de repetição, condicionais e pilha de execução. Entretanto, esses artefatos concentram-se estritamente na mecânica algorítmica desprovida de qualquer contexto humano ou histórico. Neles, a tecnologia é retratada como um domínio abstrato, impessoal e desprovido de implicações socioculturais, perdendo a oportunidade de abordar questões de diversidade, empatia e contexto social.

### 3.2 Jogos Educativos Físicos e Desplugados Brasileiros
No cenário nacional, destacam-se iniciativas voltadas ao ensino lúdico na Educação Básica, como o jogo de tabuleiro *SplashCode* (Gresse von Wangenheim et al., 2019), desenvolvido para introduzir algoritmos e ordenação a crianças por meio de dinâmicas desplugadas. Projetos como os de Barbosa et al. (2020) exploram protótipos de jogos de cartas com elementos de *storytelling* para ensinar estruturas de dados no Ensino Médio. Embora altamente eficazes em oficinas presenciais, essas soluções físicas enfrentam gargalos de replicação e escalabilidade em redes públicas, dependem de custos de impressão e distribuição de materiais e não dispõem de mecanismos automatizados para coleta e registro contínuo de telemetria de aprendizagem.

### 3.3 Iniciativas Institucionais de Fomento à Participação Feminina
No Brasil, o principal referencial de incentivo à equidade de gênero na computação é o Programa *Meninas Digitais*, chancelado pela Sociedade Brasileira de Computação (SBC). O programa fomenta projetos em todo o território nacional através de palestras, minicursos práticos de robótica e rodas de conversa. Não obstante o inestimável impacto social das iniciativas, constata-se na literatura uma escassez de recursos didáticos digitais interativos dedicados — isto é, jogos estruturados onde a história das pioneiras não seja um mero anexo textual ou painel biográfico estático, mas sim o próprio motor da mecânica jogável.

### 3.4 Diferencial e Lacunas Preenchidas pelo *Pioneiras & Além*
A Tabela 1 sintetiza a comparação do *Pioneiras & Além* em relação às abordagens correlatas da literatura:

| Dimensão de Análise | Jogos Tradicionais de Lógica (*LightBot*, etc.) | Jogos de Tabuleiro (*SplashCode*) | Oficinas Formativas (*Meninas Digitais*) | **Pioneiras & Além (Este Trabalho)** |
| :--- | :---: | :---: | :---: | :---: |
| **Ensino de Pensamento Computacional** | Alto (sintaxe e lógica pura) | Médio (conceitos desplugados) | Médio/Variável (práticas pontuais) | **Alto (pilares do PC contextualizados)** |
| **Resgate Histórico de Mulheres Pioneiras** | Inexistente (ambiente fictício) | Inexistente | Alto (exposições e palestras) | **Alto (diálogo em 1ª pessoa em 6 Eras)** |
| **Mecânica Fundada em Metáforas Ativas** | Média (comandos geométricos) | Alta (cartas e tabuleiros) | Não aplicável | **Alta (metáfora espelha o conceito da Era)** |
| **Soberania e História da Computação Nacional** | Inexistente | Baixa | Média | **Alta (Epílogo Edith Ranzini / Patinho Feio)** |
| **Acessibilidade Web sem Instalação Local** | Alta (Web/App) | Inexistente (físico) | Não aplicável | **Alta (Godot 4 WebAssembly / HTML5 leve)** |
| **Telemetria de Aprendizagem em Tempo Real** | Baixa ou ausente | Inexistente | Manual/Questionários | **Alta (Webhook silencioso + nuvem + JSON)** |

O diferencial do *Pioneiras & Além* reside, portanto, na integração indissociável entre narrativa biográfica empática, metáforas pedagógicas concretas, tecnologia web acessível e instrumento científico de coleta automatizada de dados avaliativos.

---

## 4. Materiais e Métodos ou Desenvolvimento

### 4.1 Abordagem Metodológica
A pesquisa adota uma abordagem mista (quanti-qualitativa), de natureza aplicada e intervencionista, estruturada a partir da metodologia da **pesquisa-ação educacional** (Thiollent, 2011). O ciclo metodológico contemplou quatro etapas iterativas:
1. **Diagnóstico Inicial:** mapeamento de carências de infraestrutura na escola pública parceira e aplicação de sondagem diagnóstica sobre conhecimentos prévios e percepção de gênero;
2. **Concepção e Desenvolvimento:** engenharia do jogo na engine Godot 4, desenho instrucional das fases e implementação do pipeline de telemetria;
3. **Intervenção Pedagógica Prática:** aplicação de oficinas didáticas orientadas em laboratório de informática com estudantes do 8º e 9º anos do Ensino Fundamental;
4. **Avaliação Formativa e Tabulação:** consolidação e análise cruzada dos dados comportamentais (telemetria em tempo real) com os dados perceptivos (questionários pós-teste e observação etnográfica).

### 4.2 Arquitetura Tecnológica e Acessibilidade Web
As escolas públicas brasileiras frequentemente dispõem de laboratórios com máquinas heterogêneas, sistemas operacionais legados e restrições administrativas para instalação de softwares executáveis. Para garantir democratização do acesso, o *Pioneiras & Além* foi projetado sob as seguintes premissas de engenharia de software:
* **Engine e Linguagem:** Godot Engine 4 (v4.6), utilizando GDScript com tipagem estática rigorosa para garantir estabilidade operacional e desempenho consistente;
* **Pipeline de Exportação:** compilação para **WebAssembly (Wasm)** e **HTML5 Canvas**, permitindo que a aplicação seja executada diretamente em qualquer navegador moderno (Chrome, Edge, Firefox, Safari) sem dependências locais;
* **Hospedagem e CDN:** publicação automatizada via Continuous Deployment na plataforma Netlify (`https://pioneirasealem.netlify.app/`), assegurando baixo tempo de carregamento e alta disponibilidade;
* **Compatibilidade e Responsividade Mobile/Tablet:** implementação de *overlay* vetorial inteligente em CSS/DOM que detecta a orientação do dispositivo, orientando o usuário a girar para o modo paisagem (`landscape.lock`) e suporte a caixas de diálogo nativas do navegador para digitação fluida em teclados virtuais touch (Android e iOS).

### 4.3 Design Mecânico e Proposta Pedagógica (As Fases do Jogo)
O jogo divide-se em uma introdução diagnóstica, seis Eras cronológicas e um Epílogo nacional. Em cada Era, o educando interage inicialmente com um diálogo em primeira pessoa no qual a cientista expõe o dilema histórico e técnico enfrentado. Em seguida, o jogador assume a postura ativa de resolver um desafio mecânico regido por uma **metáfora pedagógica**, recebendo feedback dedutivo imediato. Ao triunfar, tem acesso ao *Cartão de Conquista e Síntese Teórica*, que relaciona o desafio superado ao conceito de computação formal e às metas do ODS 5:

1. **Era 1 — Ada Lovelace (1843):**
   * *Conceito Computacional:* Algoritmos, Sequenciamento Lógico e Estruturas de Controle (Entrada, Processamento, Decisão e Saída).
   * *Metáfora Pedagógica:* A receita do bolo da Máquina Analítica. O jogador aprende que não se pode misturar a massa sem ingredientes na bancada (tentativa de processar sem entrada) nem servir o prato sem antes testar se está assado (saída sem decisão condicional).
   * *Mecânica:* Ordenação sequencial de quatro cartões perfurados conceituais em slots designados.

2. **Era 2 — ENIAC Girls (1945):**
   * *Conceito Computacional:* Arquitetura de Computadores, Circuitos Físicos e Fluxo de Dados.
   * *Metáfora Pedagógica:* A orquestra eletrônica regida pelo *Master Programmer*. As programadoras precisavam unir módulos físicos manualmente.
   * *Mecânica:* *Patch panel* interativo no qual o estudante conecta cabos funcionais entre o relógio de pulso central, os acumuladores aritméticos e a unidade de impressão.

3. **Era 3 — Grace Hopper (1947):**
   * *Conceito Computacional:* Depuração (*Debugging*) e Compiladores (Linguagens de Alto Nível).
   * *Metáfora Pedagógica:* A caça à mariposa física nos relés eletromecânicos do Harvard Mark II e o compilador como um tradutor poliglota entre o pensamento humano e os interruptores da máquina.
   * *Mecânica:* Localização do relé travado por um inseto real e correspondência direta entre instruções em linguagem natural e microoperações binárias de baixo nível.

4. **Era 4 — Katherine Johnson (1962):**
   * *Conceito Computacional:* Modelagem Matemática, Parâmetros Críticos e Verificação Humana de Sistemas Automatizados.
   * *Metáfora Pedagógica:* O estreito corredor atmosférico de reentrada orbital da cápsula espacial *Friendship 7* (Missão Mercury-Atlas 6).
   * *Mecânica:* Calibração em tempo real de três parâmetros numéricos interdependentes (ângulo de incidência, velocidade orbital e temporização dos retrofoguetes), exigindo atenção à precisão analítica.

5. **Era 5 — Irmã Mary Kenneth Keller (1965):**
   * *Conceito Computacional:* Democratização da Linguagem, Variáveis de Memória e Entrada Interativa.
   * *Metáfora Pedagógica:* Perguntar e guardar na gaveta rotulada (`NOME$`).
   * *Mecânica:* Organização de quatro linhas semânticas de código em linguagem BASIC (`REM`, `PRINT`, `INPUT`, `PRINT`) e subsequente execução de um terminal Teletype interativo que lê o nome real do estudante e o cumprimenta na tela.

6. **Era 6 — Margaret Hamilton (1969):**
   * *Conceito Computacional:* Engenharia de Software, Priorização de Processos Assíncronos e Tolerância a Falhas Críticas.
   * *Metáfora Pedagógica:* A triagem médica de emergência durante a saturação do computador de bordo (AGC) na descida do Módulo Lunar da Apollo 11 (Alarme 1202).
   * *Mecânica:* O jogador gerencia a CPU sobrecarregada a 130%, desativando processos supérfluos (radar de acoplamento de subida) para reduzir o consumo para níveis seguros (<85%) sem desligar os sistemas vitais de descida.

7. **Epílogo Especial — Edith Ranzini (1972, Brasil):**
   * *Conceito Computacional:* Soberania Tecnológica, Hardware Nacional e Descentralização Geográfica da História.
   * *Metáfora Pedagógica:* O "Patinho Feio" que se transformou em cisne da informática nacional.
   * *Conteúdo:* Painel documental interativo apresentando a trajetória da Profa. Dra. Edith Ranzini na Escola Politécnica da USP e seu pioneirismo na montagem do primeiro computador digital brasileiro.

### 4.4 Sistema de Telemetria Formativa Integrada
Para subsidiar a pesquisa empírica com rigor métrico, o jogo incorpora uma camada de instrumentação de telemetria transparente aos educandos. A arquitetura opera em fluxo automatizado:
1. **Consentimento e Perfil Inicial:** registro de identificação básica (nome voluntário, município/escola) e três questões diagnósticas pré-jogo (conhecimento de pioneiras, contato prévio com programação e percepção de representatividade);
2. **Rastreamento Comportamental por Fase:** monitoramento do tempo decorrido em segundos (precisão de milissegundos), quantidade precisa de tentativas e erros cometidos antes do êxito e verificação booleana da leitura do cartão de síntese;
3. **Questionário Pós-Teste e Transmissão em Nuvem:** ao alcançar a tela de vitória, o jogo registra as respostas avaliativas em escala Likert e dispara um payload JSON assíncrono via requisição HTTP POST para um endpoint do **Google Apps Script**, alimentando instantaneamente uma planilha de consolidação de dados na nuvem, com gravação de redundância local em arquivo tabular `.csv`.

---

## 5. Resultados

A intervenção pedagógica foi realizada com turmas do 8º e 9º anos do Ensino Fundamental de uma escola pública estadual do Paraná, totalizando 42 estudantes participantes. As atividades foram mediadas no laboratório de informática escolar, organizadas em uma sequência didática de três momentos: *Descoberta Autônoma* (jogabilidade individual ou em duplas), *Mediação Formativa* (discussão dos conceitos à luz das sínteses) e *Roda de Conversa Final* (avaliação de gênero e debate da ODS 5).

### 5.1 Dinâmica de Engajamento e Resolução de Problemas
A análise dos registros comportamentais e das observações em sala de aula revelou um nível notável de imersão e engajamento dos educandos:
* **Fluidez e Baixa Desistência:** 95,2% dos estudantes concluíram todas as seis Eras e o Epílogo da Edith Ranzini. A curva de aprendizagem evidenciou tempos médios decrescentes na assimilação das mecânicas após a compreensão do modelo mental de cada fase;
* **Resiliência e Depuração Iterativa:** nas fases com maior demanda lógica (Era 4 — Katherine Johnson e Era 6 — Margaret Hamilton), a taxa de tentativas antes do sucesso situou-se entre 2,1 e 3,4 tentativas por aluno. Diferente de atividades tradicionais em papel, onde o erro frequentemente induz à inibição, o feedback dedutivo imediato do jogo estimulou os estudantes a testarem hipóteses ativamente, ressignificando o erro como parte natural do processo de depuração;
* **Aprendizagem Colaborativa Espontânea:** verificou-se intensa interação entre os pares. Estudantes que compreendiam primeiro o ajuste dos parâmetros orbitais ou a lógica de conexão dos cabos do ENIAC atuavam como monitores informais dos colegas, incentivando a cooperação mútua.

### 5.2 Desempenho e Métricas de Telemetria por Fase
A Tabela 2 apresenta o consolidado dos dados quantitativos capturados pelo sistema de telemetria durante a intervenção:

| Era / Fase | Cientista Homenageada | Tempo Médio de Resolução | Média de Tentativas | Taxa de Sucesso na 1ª Tentativa | Abertura do Cartão de Síntese |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Era 1** | Ada Lovelace | 1 min 14 s | 1,4 | 68,3% | 100% |
| **Era 2** | ENIAC Girls | 58 s | 1,2 | 81,0% | 97,6% |
| **Era 3** | Grace Hopper | 1 min 32 s | 1,6 | 59,5% | 100% |
| **Era 4** | Katherine Johnson | 2 min 18 s | 2,7 | 35,7% | 95,2% |
| **Era 5** | Irmã Mary Kenneth Keller | 1 min 45 s | 1,8 | 52,4% | 100% |
| **Era 6** | Margaret Hamilton | 2 min 05 s | 2,3 | 42,8% | 100% |
| **Epílogo**| Edith Ranzini | 1 min 20 s | - | 100% (Leitura Interativa) | 100% |

Os dados revelam que o nível de desafio cognitivo do jogo foi calibrado de forma progressiva. As Eras 4 e 6 exerceram a maior demanda analítica, exigindo múltiplas testagens iterativas, ao passo que as Eras 1 e 2 propiciaram ancoragem conceitual rápida e intuitiva.

---

## Discussão

### A Efetividade das Metáforas Pedagógicas na Superação da Abstração
Os resultados práticos corroboram as proposições de Papert (1980) e Resnick (2013) sobre o construcionismo digital. Ao personificar a instrução algorítmica na metáfora de uma "receita de bolo" ou o armazenamento de variáveis na imagem de "guardar na gaveta rotulada", o *Pioneiras & Além* converteu abstrações que costumam alienar estudantes iniciantes em referências familiares e manipuláveis. A experiência interativa com o terminal BASIC da Irmã Keller (Era 5) foi apontada pelos alunos como um dos momentos mais marcantes da oficina: o ato de visualizar o próprio nome impresso na teletype digital conferiu aos estudantes uma sensação concreta de agência e autoria sobre a tecnologia.

### Desconstrução de Estereótipos e Ganho de Autoeficácia Feminina
O impacto mais substancial do estudo manifestou-se na esfera sociocultural de gênero (CTG). No pré-teste, quando indagados sobre figuras marcantes da história da tecnologia, 83,3% dos estudantes citaram exclusivamente homens contemporâneos (como criadores de redes sociais e fundadores de grandes corporações de TI), e apenas 14,3% dos alunos relataram conhecer alguma mulher pioneira na computação.

No pós-teste e nas rodas de debate, observou-se uma transformação expressiva:
1. **Reconhecimento Histórico:** 100% dos estudantes passaram a identificar ao menos três cientistas mulheres e seus feitos fundamentais;
2. **Elevação da Autoeficácia entre as Alunas:** a quase totalidade das meninas (94,7%) declarou que conhecer as trajetórias de Margaret Hamilton, Grace Hopper e Edith Ranzini alterou positivamente sua percepção sobre a própria capacidade de lidar com programação e matemática;
3. **Valorização da Ciência Nacional:** a inclusão de Edith Ranzini no Epílogo gerou grande surpresa e orgulho cívico nos estudantes, que desconheciam o fato de o Brasil ter desenvolvido computadores próprios no início da década de 1970 com liderança feminina.

Esses achados confirmam os postulados de Barros (2022) e Lima (2013) quanto à urgência pedagógica de romper com a invisibilidade histórica: a representatividade feminina não atua como mera curiosidade biográfica, mas como um catalisador de inclusão e democratização científica.

### Viabilidade Operacional e Sustentabilidade Tecnológica
A opção técnica pelo Godot 4 WebAssembly revelou-se um acerto estratégico crucial: em nenhum computador do laboratório escolar houve necessidade de instalação de plugins ou suporte técnico complexo. O jogo funcionou com fluidez, contornando a obsolescência de hardware frequente nas redes estaduais de ensino. Além disso, o disparo automatizado dos dados via Webhook comprovou a viabilidade de aplicar instrumentos de avaliação e pesquisa em escala sem gerar sobrecarga administrativa aos professores regentes.

---

## 6. Conclusão e Trabalhos Futuros

O projeto **Pioneiras & Além** consolidou uma intervenção pedagógica que responde simultaneamente a duas urgências da Educação Básica: a alfabetização no Pensamento Computacional e o fomento ativo à equidade de gênero na ciência e tecnologia (ODS 5). Os resultados empíricos demonstraram que a articulação entre narrativas empáticas em primeira pessoa, mecânicas construcionistas fundadas em metáforas acessíveis e telemetria transparente constitui um modelo replicável e de alto impacto educacional.

O artefato superou a barreira do hermetismo técnico, desmistificou o erro como etapa natural da investigação científica e empoderou substancialmente as alunas, desconstruindo estereótipos androcêntricos que historicamente restringem a presença feminina nas carreiras de STEM.

Como desdobramentos e trabalhos futuros, delineiam-se as seguintes frentes de pesquisa:
1. **Estudos Longitudinais Ampliados:** aplicação da metodologia em uma amostra multicêntrica de escolas públicas de diferentes regiões do país, acompanhando a escolha de itinerários formativos dos estudantes no Ensino Médio;
2. **Dashboard Docente em Tempo Real:** desenvolvimento de uma interface web para que professores visualizem métricas de aprendizagem e pontos de dificuldade da turma instantaneamente durante a aula;
3. **Módulo de Mulheres na Inteligência Artificial:** expansão das Eras do jogo com a inclusão de cientistas contemporâneas que lideram pesquisas em ética e aprendizado de máquina (como Timnit Gebru e Joy Buolamwini), discutindo vieses algorítmicos e o futuro da inteligência artificial sob uma perspectiva inclusiva.

---

## Agradecimentos

Os autores agradecem à Universidade Estadual do Norte do Paraná (UENP) e ao Programa de Pós-Graduação em Ensino de Computação (PROFCOMP) pelo fomento institucional a esta pesquisa. Expressamos profundo reconhecimento à equipe gestora, ao corpo docente e, de modo especial, a todos os estudantes da escola pública participante, cuja curiosidade, dedicação e entusiasmo deram sentido prático a este projeto.

---

## Declaração de Uso de Inteligência Artificial

Em estrita conformidade com as diretrizes de ética, transparência e integridade acadêmica preconizadas pela Sociedade Brasileira de Computação (SBC) e pela comissão organizadora do *Computer on the Beach*, os autores declaram formalmente que ferramentas de Inteligência Artificial Generativa foram empregadas unicamente como recurso instrumental de apoio para:
1. Revisão gramatical e adequação da fluidez estilística do manuscrito;
2. Formatação visual do documento conforme os padrões normativos da conferência.

Ressalta-se categoricamente que todo o delineamento metodológico, a concepção pedagógica do jogo, a programação de software na engine Godot, a coleta de dados de telemetria, a mediação das oficinas com os estudantes e a interpretação crítica das análises e conclusões são de autoria intelectual e responsabilidade ética integral e exclusiva dos pesquisadores humanos signatários deste trabalho.

---

## Referências

BARBOSA, A. et al. Protótipo de jogo educativo com storytelling para o ensino de estruturas de dados. In: **CONGRESSO BRASILEIRO DE INFORMÁTICA NA EDUCAÇÃO (CBIE)**, 2020. Anais... Porto Alegre: SBC, p. 112-121, 2020.

BANDURA, A. **Self-efficacy: The exercise of control**. New York: W. H. Freeman and Company, 1997.

BARRADAS, R.; LENCASTRE, J. A. Aprendizagem baseada em jogos e gamificação no ensino de informática. **Revista de Estudos Curriculares**, v. 8, n. 2, p. 45-60, 2017.

BARROS, R. L. Ciência, tecnologia e gênero: a participação da mulher no campo científico e tecnológico. **Revista Brasileira de Pós-Graduação (RBPG)**, Brasília, v. 18, n. especial, p. 1-21, jul./dez. 2022.

BERNARDO, C.; PIRES, F.; PESSOA, M. Game design e narrativa para gamificação educacional. **Educação e Tecnologia**, v. 26, n. 1, p. 30-48, 2021.

BRASIL. Ministério da Educação. Conselho Nacional de Educação. **Resolução CNE/CP nº 1/2022: Normas sobre Computação na Educação Básica**. Diário Oficial da União, Brasília, Seção 1, p. 128, 4 de out. 2022.

CARNEIRO, L. B. **Teto de vidro: um estudo sobre os fatores determinantes deste fenômeno no Brasil**. 2018. 142 f. Dissertação (Mestrado em Administração) — Universidade Federal do Rio Grande (FURG), Rio Grande, 2018.

GARCIA, M. I. G.; SEDEÑO, E. P. **Ciência, Tecnologia e Gênero: abordagens teóricas e práticas**. Londrina: Editora IAPAR, 2006.

GOMES, T.; MELO, C. Game design pedagógico: integrando mecânicas lúdicas e objetivos curriculares. In: **SIMPÓSIO BRASILEIRO DE JOGOS E ENTRETENIMENTO DIGITAL (SBGames)**, 2018. Anais... SBC, 2018.

GRESSE VON WANGENHEIM, C. et al. SplashCode: um jogo de tabuleiro para o ensino de introdução aos algoritmos na Educação Básica. In: **SIMPÓSIO BRASILEIRO DE INFORMÁTICA NA EDUCAÇÃO (SBIE)**, 30., 2019, Brasília. Anais... Porto Alegre: SBC, p. 1383-1392, 2019.

LIMA, M. P. As pioneiras na computação e as barreiras invisíveis no Brasil. **Revista Estudos Feministas**, Florianópolis, v. 21, n. 3, p. 801-816, 2013.

PAPERT, S. **Mindstorms: Children, Computers, and Powerful Ideas**. New York: Basic Books, 1980.

RESNICK, M. Lifelong Kindergarten: Cultivating Creativity through Projects, Passion, Peers, and Play. **Educational Technology**, v. 53, n. 6, p. 24-27, 2013.

SCHIEBINGER, L. **Has Feminism Changed Science?** Cambridge: Harvard University Press, 1999.

THIOLLENT, M. **Metodologia da Pesquisa-Ação**. 18. ed. São Paulo: Cortez Editora, 2011.

WING, J. M. Computational Thinking. **Communications of the ACM**, New York, v. 49, n. 3, p. 33-35, 2006.
