# Pioneiras & Além: Desenvolvimento, Aplicação e Análise de um Jogo Digital Educativo para a Promoção da Equidade de Gênero e o Ensino do Pensamento Computacional

**Thiago Jesus de Mendonça¹**, **Leonardo Donadoni²**, **Daniela Farago de Lima³**  
¹²³ Mestrado Profissional em Ensino de Computação (PROFCOMP) — Universidade Estadual do Norte do Paraná (UENP)  
*E-mails:* `thiagojmendonca@hotmail.com`, `leonardodonadoni168@gmail.com`, `danifaragolima@gmail.com`

---

## Resumo (Abstract)

### Resumo
Ensinar conceitos fundamentais de Ciência da Computação na Educação Básica frequentemente esbarra na abstração conceitual e no desinteresse dos estudantes. Contudo, essa barreira pedagógica é profundamente agravada pela escassez de representatividade histórica feminina, fruto de um processo sociocultural de invisibilização e segregação de gênero no campo científico-tecnológico. Para responder de forma integrada a esses desafios, desenvolveu-se o **Pioneiras & Além**, uma aplicação web interativa desenvolvida na engine Godot 4. O jogo convida os estudantes a uma imersão temporal estruturada em seis Eras e um Epílogo, relacionando pilares do Pensamento Computacional às contribuições de sete cientistas emblemáticas: Ada Lovelace, as ENIAC Girls, Grace Hopper, Katherine Johnson, Irmã Mary Kenneth Keller, Margaret Hamilton e Edith Ranzini. Alinhado ao ODS 5 da ONU (Igualdade de Gênero) e às diretrizes da BNCC para a Computação na Educação Básica, o projeto articula o construcionismo pedagógico aos Estudos de Ciência, Tecnologia e Gênero (CTG). O artefato conta com um subsistema de telemetria formativa em tempo real integrado à nuvem. A intervenção prática realizada com 52 estudantes do 8º e 9º anos de uma escola pública estadual em Santa Mariana (Paraná) revelou elevado engajamento (100% de leitura de sínteses e acesso ao epílogo nacional), desmistificação do erro como etapa de depuração e transformação perceptiva sobre o protagonismo feminino na computação.

### Abstract
Teaching fundamental concepts of Computer Science in Basic Education often faces barriers of conceptual abstraction and student disengagement. However, this pedagogical hurdle is deeply compounded by the scarcity of historical female representation, resulting from a sociocultural process of invisibilization and gender segregation in science and technology. To address these interconnected challenges, this paper presents **Pioneiras & Além**, an interactive serious game developed using the Godot 4 engine and distributed via WebAssembly. The game guides students through a historical journey structured across six Eras and an Epilogue, mapping Computational Thinking pillars to the foundational contributions of seven iconic women scientists: Ada Lovelace, the ENIAC Girls, Grace Hopper, Katherine Johnson, Sister Mary Kenneth Keller, Margaret Hamilton, and Brazilian pioneer Edith Ranzini. Aligned with UN Sustainable Development Goal 5 (Gender Equality) and the Brazilian National Common Curricular Base (BNCC), the project combines constructionist pedagogy with Science, Technology, and Gender (STG) studies. The artifact features an integrated cloud-based real-time formative telemetry system. A practical intervention conducted with 52 students in an 8th and 9th grade cohort at a public school in Santa Mariana, Paraná, revealed high engagement (100% synthesis card engagement and national epilogue completion), resilience in iterative debugging, and a meaningful shift in gender perception regarding women's historical and contemporary role in computing.

---

## Palavras-chave (Keywords)

* **Palavras-chave:** Gamificação; Ensino de Computação; Pensamento Computacional; Jogo Digital Educativo; Representatividade Feminina; Ciência, Tecnologia e Gênero; ODS 5.
* **Keywords:** Gamification; Computer Science Education; Computational Thinking; Educational Digital Game; Female Representation; Science, Technology and Gender; SDG 5.

---

## Introdução

A inserção da Ciência da Computação na Educação Básica consolida-se contemporaneamente como uma exigência estrutural para a formação cidadã crítica e o desenvolvimento do raciocínio lógico no século XXI. A homologação das Normas sobre Computação na Educação Básica como complemento à Base Nacional Comum Curricular (BNCC) estabeleceu a necessidade de desenvolver competências de Pensamento Computacional, Mundo Digital e Cultura Digital desde as etapas iniciais da escolarização (Brasil, 2022). Todavia, a prática pedagógica tradicional frequentemente enfrenta dois obstáculos de grande envergadura: em primeiro lugar, o ensino de algoritmos e lógica costuma ser conduzido de maneira excessivamente abstrata e descontextualizada, gerando desmotivação e sensação de inatingibilidade entre os educandos; em segundo lugar, o ecossistema tecnológico e científico carrega uma histórica e marcante disparidade de gênero (Barros, 2022).

Historicamente, a gênese da computação moderna contou com o protagonismo direto de mulheres que fundaram bases conceituais, metodológicas e práticas indispensáveis: desde o desenvolvimento do primeiro algoritmo por Ada Lovelace em 1843, passando pela programação física do primeiro computador eletrônico digital pelas programadoras do ENIAC em 1945, a criação do compilador e a consolidação de linguagens de alto nível por Grace Hopper em 1947, os cálculos de mecânica orbital de Katherine Johnson em 1962, a democratização do ensino com a linguagem BASIC pela Irmã Mary Kenneth Keller em 1965, até a fundação da Engenharia de Software por Margaret Hamilton no Projeto Apollo 11 em 1969. No contexto latino-americano, destaca-se pioneiramente a atuação da Profa. Dra. Edith Ranzini no desenvolvimento do primeiro minicomputador brasileiro, o *Patinho Feio*, em 1972 (Lima, 2013).

A despeito dessa riqueza factual, operou-se ao longo da segunda metade do século XX um processo sistemático de masculinização da área tecnológica e apagamento memorial da atuação feminina (Schiebinger, 1999). Com a emergência dos computadores domésticos comercializados primordialmente como artefatos masculinos a partir dos anos 1980, as taxas de ingresso e permanência de mulheres nos cursos de Ciências Exatas e Tecnologia sofreram retração acentuada — fenômeno sociológico conhecido como segregação horizontal ou territorial (Carneiro, 2018). Essa ausência de modelos representativos de identificação (*role models*) nos currículos escolares retroalimenta estereótipos que afastam precocemente meninas de carreiras de base tecnológica.

Com o propósito de superar concomitantemente a abstração dos conceitos de computação e combater a invisibilização histórica feminina, desenvolveu-se o jogo digital educativo **Pioneiras & Além**. A aplicação web articula a resolução de problemas algorítmicos ao resgate histórico das cientistas precursoras, estruturando uma transposição didática amparada no construcionismo e alinhada ao Objetivo de Desenvolvimento Sustentável 5 da Organização das Nações Unidas (ODS 5: Igualdade de Gênero). 

O presente artigo apresenta o percurso completo da pesquisa: a fundamentação teórica e análise de trabalhos correlatos, as escolhas de engenharia e materiais de desenvolvimento do jogo, os procedimentos metodológicos da intervenção prática em escola pública, a apresentação dos resultados quanti-qualitativos obtidos por telemetria e observação participativa, e a discussão aprofundada dos impactos educacionais e sociais observados.

---

## Fundamentação Teórica / Trabalhos Relacionados

### Fundamentação Teórica: Pensamento Computacional e Aprendizagem Baseada em Jogos (GBL)
O Pensamento Computacional (PC), conceituado por Wing (2006), compreende os processos mentais envolvidos na formulação de problemas e na expressão de suas soluções de modo que um agente processador de informações (seja ele humano ou computacional) possa executá-las com eficácia. Seus quatro pilares estruturantes englobam a decomposição, o reconhecimento de padrões, a abstração e o pensamento algorítmico. Gresse von Wangenheim et al. (2019) salientam que a apropriação do PC na Educação Básica não deve restringir-se à memorização precoce de sintaxes de linguagens profissionais de programação, florescendo com maior robustez quando mediado por atividades interativas, lúdicas e ricas em significado.

Nesse prisma, a Aprendizagem Baseada em Jogos (*Game-Based Learning* — GBL) desponta como paradigma pedagógico fecundo ao integrar mecânicas lúdicas a metas instrucionais intencionais (Barradas & Lencastre, 2017). Essa perspectiva vincula-se diretamente ao construcionismo de Seymour Papert (1980) e à aprendizagem criativa de Mitchel Resnick (2013): o conhecimento é construído de maneira mais significativa quando o aprendiz engaja-se ativamente na confecção e manipulação de um artefato palpável dentro de um "micromundo" dinâmico. No jogo educativo, a mecânica funciona como espelho conceitual do conteúdo curricular (Gomes & Melo, 2018), ressignificando o erro: o *bug* ou a falha deixam de ser motivo de frustração e passam a atuar como convite à análise lógica e depuração iterativa (*debugging*).

### Fundamentação Teórica: Estudos de Ciência, Tecnologia e Gênero (CTG) e o Efeito *Role Model*
A dimensão sociocultural desta investigação apoia-se nos Estudos de Ciência, Tecnologia e Gênero (CTG), consolidados por Schiebinger (1999), Garcia e Sedeño (2006) e Barros (2022). O campo CTG desmistifica a neutralidade axiológica da ciência, evidenciando como relações de poder historicamente privilegiaram a presença masculina nos centros de decisão técnica. A literatura categoriza a sub-representação feminina em duas formas de segregação complementares: a vertical ("teto de vidro", barreiras que impedem a ascensão a postos de liderança) e a horizontal ("campos murados", direcionamento sociocultural que afasta mulheres de áreas tecnológicas) (Carneiro, 2018). 

A psicologia social e a pedagogia crítica demonstram que a presença explícita de modelos femininos de referência (*role models*) exerce influência determinante sobre a percepção de autoeficácia de estudantes do gênero feminino (Bandura, 1997; Lima, 2013). Ao testemunharem que mulheres foram as criadoras de conceitos estruturantes da tecnologia que utilizam em seus cotidianos, as estudantes desconstroem o sentimento de inadequação e ampliam seu horizonte vocacional.

### Trabalhos Relacionados e Análise Comparativa
A análise da literatura científica revela iniciativas educacionais que podem ser categorizadas em três vertentes principais:
1. **Jogos Digitais Comerciais de Lógica (*LightBot*, *CodeCombat*, *Human Resource Machine*):** exercitam quebra-cabeças e lógica de programação de forma eficiente, porém com foco estritamente abstrato e impessoal, desprovidos de contextualização humana, histórica e social;
2. **Jogos Educativos Físicos e Desplugados (*SplashCode*, *Storytelling de Dados*):** jogos de tabuleiro e cartas nacionais (Gresse von Wangenheim et al., 2019; Barbosa et al., 2020) que introduzem algoritmos com sucesso em oficinas presenciais, mas enfrentam barreiras de distribuição física em larga escala e não dispõem de coleta automatizada de telemetria de aprendizagem;
3. **Iniciativas Institucionais de Gênero (Programa *Meninas Digitais* — SBC):** redes e projetos de fomento que realizam oficinas práticas e palestras essenciais em todo o país, mas que carecem de jogos digitais narrativos próprios onde as biografias das cientistas sejam a própria mecânica interativa central.

A Tabela 1 sintetiza o posicionamento do *Pioneiras & Além* em relação ao estado da arte:

| Dimensão de Análise | Jogos Tradicionais de Lógica (*LightBot*) | Jogos de Tabuleiro (*SplashCode*) | Oficinas Formativas (*Meninas Digitais*) | **Pioneiras & Além (Este Trabalho)** |
| :--- | :---: | :---: | :---: | :---: |
| **Ensino de Pensamento Computacional** | Alto (lógica pura) | Médio (desplugado) | Médio (práticas pontuais) | **Alto (pilares do PC contextualizados)** |
| **Resgate Histórico de Mulheres Pioneiras** | Inexistente | Inexistente | Alto (palestras/exposições) | **Alto (diálogo em 1ª pessoa em 6 Eras)** |
| **Mecânica Fundada em Metáforas Ativas** | Média (comandos geométricos) | Alta (cartas físicas) | Não aplicável | **Alta (metáfora espelha o conceito da Era)** |
| **Soberania e História da Computação Nacional** | Inexistente | Baixa | Média | **Alta (Epílogo Edith Ranzini / Patinho Feio)** |
| **Acessibilidade Web sem Instalação Local** | Alta (Web/App) | Inexistente (físico) | Não aplicável | **Alta (Godot 4 WebAssembly / HTML5 leve)** |
| **Telemetria Formativa em Tempo Real** | Baixa ou ausente | Inexistente | Questionários Manuais | **Alta (Webhook silencioso + nuvem + JSON)** |

O diferencial do *Pioneiras & Além* consiste na integração indissociável entre narrativa biográfica empática, metáforas pedagógicas concretas, tecnologia web leve e instrumento de telemetria científica integrada.

---

## Materiais e Métodos ou Desenvolvimento

### Abordagem Metodológica
A pesquisa adota uma abordagem mista (quanti-qualitativa), de natureza aplicada e intervencionista, estruturada a partir da metodologia da **pesquisa-ação educacional** (Thiollent, 2011). O ciclo metodológico contemplou quatro etapas iterativas: (1) Diagnóstico Inicial de carências e sondagem prévia; (2) Concepção e Engenharia de Software do jogo educativo na engine Godot 4; (3) Intervenção Pedagógica Prática em laboratório escolar com 52 estudantes do 8º e 9º anos do Ensino Fundamental de uma escola pública estadual em Santa Mariana (Paraná); e (4) Avaliação Formativa e Tabulação estatística cruzada dos dados comportamentais (telemetria em tempo real) e perceptivos (questionários e observação participativa).

### Arquitetura Tecnológica e Acessibilidade Web
Para assegurar democratização do acesso em laboratórios escolares públicos heterogêneos e sem necessidade de permissões administrativas de instalação, o jogo foi concebido sob a seguinte arquitetura técnica:
* **Engine e Linguagem:** Godot Engine 4 (v4.6), utilizando GDScript com tipagem estática rigorosa para garantir estabilidade operacional e desempenho consistente;
* **Pipeline de Exportação:** compilação para **WebAssembly (Wasm)** e **HTML5 Canvas**, permitindo que a aplicação seja executada diretamente em qualquer navegador moderno (Chrome, Edge, Firefox, Safari);
* **Hospedagem e CDN:** publicação automatizada via Continuous Deployment na plataforma Netlify (`https://pioneirasealem.netlify.app/`), com alta disponibilidade e baixo tempo de carregamento;
* **Compatibilidade e Responsividade Mobile/Tablet:** implementação de *overlay* vetorial inteligente em CSS/DOM que detecta a orientação do dispositivo, orientando o usuário a girar para o modo paisagem (`landscape.lock`) e suporte a caixas de diálogo nativas do navegador para digitação fluida em teclados virtuais touch (Android e iOS).

### Design Mecânico e Proposta Pedagógica (As Fases do Jogo)
O jogo estrutura-se em uma introdução diagnóstica, seis Eras históricas e um Epílogo especial brasileiro. Em cada Era, o estudante interage com um diálogo em primeira pessoa no qual a cientista expõe o problema histórico enfrentado. Em seguida, assume a postura ativa de solucionar o desafio mecânico regido por uma **metáfora pedagógica**, recebendo feedback dedutivo imediato. Ao concluir, abre-se o *Cartão de Síntese Teórica*, relacionando a vivência prática ao conceito formal de computação e ao ODS 5:

1. **Era 1 — Ada Lovelace (1843):**
   * *Conceito:* Algoritmos, Sequenciamento Lógico e Estruturas de Controle (Entrada, Processamento, Decisão e Saída).
   * *Metáfora Pedagógica:* A receita do bolo da Máquina Analítica. O jogador aprende que não se pode misturar a massa sem ingredientes na bancada (processar sem entrada) nem servir o prato sem antes testar se está assado (saída sem decisão condicional).
   * *Mecânica:* Ordenação sequencial de quatro cartões perfurados conceituais em slots sequenciais.
2. **Era 2 — ENIAC Girls (1945):**
   * *Conceito:* Arquitetura de Computadores, Circuitos Físicos e Fluxo de Dados.
   * *Metáfora Pedagógica:* A orquestra eletrônica regida pelo *Master Programmer*. As programadoras precisavam unir módulos físicos manualmente.
   * *Mecânica:* *Patch panel* interativo no qual o estudante conecta cabos funcionais entre o relógio de pulso central, os acumuladores aritméticos e a unidade de impressão.
3. **Era 3 — Grace Hopper (1947):**
   * *Conceito:* Depuração (*Debugging*) e Compiladores (Linguagens de Alto Nível).
   * *Metáfora Pedagógica:* A caça à mariposa física nos relés eletromecânicos do Harvard Mark II e o compilador como um tradutor poliglota entre a linguagem humana e os transistores.
   * *Mecânica:* Localização do relé travado por uma falha física e correspondência direta entre instruções em inglês e microoperações binárias de máquina.
4. **Era 4 — Katherine Johnson (1962):**
   * *Conceito:* Modelagem Matemática, Parâmetros Críticos e Verificação Humana de Sistemas Automatizados.
   * *Metáfora Pedagógica:* O estreito corredor atmosférico de reentrada orbital da cápsula espacial *Friendship 7* (Missão Mercury-Atlas 6).
   * *Mecânica:* Calibração em tempo real de três parâmetros numéricos interdependentes (ângulo de incidência, velocidade orbital e temporização dos retrofoguetes), exigindo atenção à precisão analítica.
5. **Era 5 — Irmã Mary Kenneth Keller (1965):**
   * *Conceito:* Democratização da Linguagem, Variáveis de Memória e Entrada Interativa.
   * *Metáfora Pedagógica:* Perguntar e guardar na gaveta rotulada (`NOME$`).
   * *Mecânica:* Organização de quatro linhas semânticas de código em linguagem BASIC (`REM`, `PRINT`, `INPUT`, `PRINT`) e subsequente execução de um terminal Teletype interativo que lê o nome real do estudante e o cumprimenta na tela.
6. **Era 6 — Margaret Hamilton (1969):**
   * *Conceito:* Engenharia de Software, Priorização de Processos Assíncronos e Tolerância a Falhas Críticas.
   * *Metáfora Pedagógica:* A triagem médica de emergência durante a saturação do computador de bordo (AGC) na descida do Módulo Lunar da Apollo 11 (Alarme 1202).
   * *Mecânica:* O jogador gerencia a CPU sobrecarregada a 130%, desativando processos supérfluos (radar de acoplamento de subida) para reduzir o consumo para níveis seguros (<85%) sem desligar os sistemas vitais de descida.
7. **Epílogo Especial — Edith Ranzini (1972, Brasil):**
   * *Conceito:* Soberania Tecnológica, Hardware Nacional e Descentralização Geográfica da História.
   * *Metáfora Pedagógica:* O "Patinho Feio" que se transformou em cisne da informática nacional.
   * *Conteúdo:* Painel documental interativo apresentando a trajetória da Profa. Dra. Edith Ranzini na Escola Politécnica da USP e seu pioneirismo na montagem do primeiro computador digital brasileiro.

### Sistema de Telemetria Formativa e Coleta em Nuvem
O artefato incorpora um sistema de telemetria não intrusivo com fluxo automatizado: registro de consentimento e pré-sondagem diagnóstica; monitoramento de tempo decorrido em segundos por fase (precisão decimal), contagem de tentativas e erros cometidos; e disparo assíncrono via Webhook HTTP POST (Google Apps Script) para consolidação instantânea em planilha do Google Sheets, com redundância local em arquivo tabular `.csv`.

---

## Resultados (quando aplicável)

A intervenção pedagógica foi realizada com **52 estudantes** do 8º e 9º anos do Ensino Fundamental no laboratório de informática da escola pública estadual em Santa Mariana (Paraná), mediada em três momentos didáticos: *Descoberta Autônoma*, *Mediação Formativa* e *Roda de Conversa Avaliativa*.

### Sondagem Diagnóstica Pré-Jogo (N = 52)
A sondagem inicial revelou a urgência e a pertinência social do projeto:
* **Conhecimento Prévio de Pioneiras:** Apenas **5,8%** dos estudantes (3 de 52) relataram já ter ouvido falar sobre mulheres pioneiras na Ciência da Computação. Ou seja, **94,2%** desconheciam por completo a participação feminina fundacional na informática;
* **Experiência Prévia com Programação:** Somente **9,6%** dos educandos (5 de 52) já haviam tido contato anterior com programação ou algoritmos, evidenciando que mais de **90%** da turma era composta por iniciantes absolutos.

### Telemetria Comportamental das Fases
A análise dos dados registrados em tempo real revelou padrões consistentes de engajamento e persistência:
* **Engajamento e Conclusão:** 100% dos estudantes que finalizaram a intervenção abriram e leram os Cartões de Síntese Teórica em todas as Eras, e 100% acessaram o módulo documental de Edith Ranzini no Epílogo;
* **Pontuação Média da Turma:** Os estudantes acumularam em média **1.257 pontos** (mediana: 1.240 pontos; máximo: 1.540 pontos);
* **Curva de Aprendizagem e Dificuldade Cognitiva:** A Tabela 2 apresenta as métricas empíricas consolidadas por fase.

| Era / Fase | Cientista Homenageada | Conceito Computacional | Tempo Médio (s) | Mediana (s) | Média de Tentativas | Síntese Lida (%) |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| **Era 1** | Ada Lovelace | Algoritmos e Sequenciamento | 96,1 s | 81,5 s | 2,12 | 100% |
| **Era 2** | ENIAC Girls | Arquitetura e Fluxo de Dados | 53,6 s | 46,7 s | 2,27 | 100% |
| **Era 3** | Grace Hopper | Depuração e Compiladores | 89,2 s | 52,3 s | 2,23 | 100% |
| **Era 4** | Katherine Johnson | Modelagem e Parâmetros Críticos | 103,2 s | 95,3 s | 5,31 | 100% |
| **Era 5** | Mary Kenneth Keller | Sintaxe BASIC e Variáveis | 134,6 s | 113,1 s | 13,23 | 100% |
| **Era 6** | Margaret Hamilton | Engenharia de Software / Apollo 11 | 88,0 s | 61,8 s | 6,60 | 100% |
| **Epílogo**| Edith Ranzini | Soberania e Hardware Nacional | - | - | - | 100% (Leitura) |

Os dados revelam que a Era 2 (ENIAC) foi a de mais rápida assimilação visual (53,6 s). Por outro lado, a Era 5 (Keller) e a Era 4 (Katherine) exigiram o maior esforço analítico e depuração iterativa, demandando em média 13,2 e 5,3 tentativas até a execução correta, o que atesta a resiliência dos estudantes mediada pelo feedback dedutivo imediato.

> **Visualização de Dados:**  
> A consolidação gráfica individual de todos os 52 participantes e o resumo estatístico detalhado constam nos artefatos visuais `tabela_telemetria_pesquisa.png` e `tabela_telemetria_resumo_estatistico.png`.

---

## Discussão

### A Efetividade das Metáforas Pedagógicas na Superação da Abstração
Os achados empíricos confirmam os postulados de Papert (1980) e Resnick (2013) sobre o construcionismo digital. Ao traduzir o conceito abstrato de variáveis e memória na imagem palpável de "guardar numa gaveta rotulada" (Era 5) ou a execução algorítmica na lógica de "uma receita de bolo" (Era 1), o *Pioneiras & Além* reduziu sensivelmente a ansiedade computacional. O momento de interação com o terminal BASIC da Irmã Keller — no qual o aluno digita o próprio nome e recebe uma resposta personalizada gerada pelo código construído — foi relatado por múltiplos estudantes como o ponto alto da atividade, gerando sentimento concreto de autoria e domínio técnico.

### Desconstrução de Estereótipos e Ganho de Autoeficácia Feminina (ODS 5)
O impacto mais profundo manifestou-se no contraste entre a sondagem prévia e o encerramento da oficina. No diagnóstico inicial, 94,2% dos alunos desconheciam pioneiras mulheres na computação, reproduzindo o androcentrismo histórico apontado por Barros (2022). Ao vivenciarem as narrativas em primeira pessoa, 100% dos educandos passaram a identificar os feitos de Ada Lovelace, Grace Hopper, Margaret Hamilton e Edith Ranzini. 

A ressignificação do erro (introduzida na fase de Grace Hopper com a caça ao inseto e continuada na priorização de tarefas de Margaret Hamilton) desmistificou o mito da perfeição instantânea em exatas. As alunas puderam constatar que programar é uma atividade iterativa de hipótese, teste e correção, o que gerou ganho direto de autoeficácia e despertou interesse vocacional genuíno.

### Soberania Tecnológica e Viabilidade em Escolas Públicas
A inclusão de Edith Ranzini no Epílogo gerou um momento ímpar de conscientização cidadã: os estudantes manifestaram surpresa e orgulho ao descobrirem que o primeiro computador brasileiro (*Patinho Feio*) foi desenvolvido em uma universidade pública por uma engenheira brasileira. 

Tecnicamente, a arquitetura Godot 4 WebAssembly provou-se plenamente viável: os 52 acessos simultâneos no laboratório escolar rodaram sem qualquer necessidade de instalação local ou suporte especializado, e a telemetria em nuvem gravou com precisão de 100% cada etapa cumprida pelos participantes.

---

## Conclusão e Trabalhos Futuros

O desenvolvimento e a aplicação do **Pioneiras & Além** demonstraram a viabilidade e o alto impacto de integrar o ensino de fundamentos do Pensamento Computacional ao resgate da memória e do protagonismo feminino na ciência e tecnologia. Fundamentado no construcionismo de Papert e nos Estudos de Ciência, Tecnologia e Gênero, o jogo superou a barreira da abstração conceitual, ressignificou o erro pedagógico por meio da depuração interativa e promoveu significativo ganho de autoeficácia e engajamento entre os educandos, em especial entre as meninas.

O projeto configurou-se como uma tecnologia social educacional acessível, sustentável e plenamente alinhada às diretrizes da BNCC para a Computação e ao ODS 5 da ONU.

Como desdobramentos e trabalhos futuros, indicam-se:
1. **Estudos Longitudinais Multicêntricos:** ampliação da amostra para redes públicas municipais e estaduais de outras regiões do país, avaliando o impacto da metodologia na escolha de itinerários formativos de Ensino Médio;
2. **Dashboard Analítico para Professores:** desenvolvimento de um painel web que permita aos docentes visualizarem as métricas de tempo, tentativas e erros da turma em tempo real durante as aulas;
3. **Módulo de Pioneiras na Inteligência Artificial:** expansão das fases do jogo com a inclusão de cientistas contemporâneas que lideram pesquisas em ética e aprendizado de máquina (como Timnit Gebru e Joy Buolamwini), debatendo vieses algorítmicos e diversidade na IA.

---

## Agradecimentos

Os autores expressam sinceros agradecimentos à Universidade Estadual do Norte do Paraná (UENP) e ao corpo docente do Programa de Pós-Graduação em Ensino de Computação (PROFCOMP). Estendemos nosso agradecimento especial à equipe diretiva, aos professores e, sobretudo, aos 52 estudantes da escola pública estadual de Santa Mariana participante da pesquisa, cuja curiosidade e dedicação foram fundamentais para a realização deste trabalho.

---

## Declaração de Uso de Inteligência Artificial

Em consonância com as diretrizes de transparência, integridade acadêmica e conduta ética preconizadas pela Sociedade Brasileira de Computação (SBC) e pela comissão do *Computer on the Beach*, os autores declaram formalmente que ferramentas de Inteligência Artificial Generativa foram empregadas estritamente como suporte instrumental para:
1. Apoio na revisão gramatical e polimento de fluidez estilística do texto em língua portuguesa e inglesa;
2. Formatação visual do documento conforme os padrões normativos da chamada.

Declara-se de modo categórico que a concepção epistemológica e pedagógica, o desenvolvimento do jogo digital na engine Godot, o planejamento da pesquisa-ação, a mediação com os estudantes, a coleta de telemetria, a análise empírica dos dados e as conclusões foram idealizadas, executadas e validadas integralmente pelos autores humanos signatários, que assumem plena responsabilidade científica e ética pelo conteúdo do artigo.

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
