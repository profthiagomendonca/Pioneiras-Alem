# Pioneiras & Além: O Código Invisível

> Jogo educacional e narrativo em Godot 4 sobre o protagonismo feminino na história da computação, desenvolvido para que as mulheres reconheçam e aprendam seu lugar na história, sendo alinhado ao ODS 05 (Igualdade de Gênero).

Pioneiras & Além é um jogo educacional e narrativo desenvolvido em Godot Engine 4, concebido como instrumento de pesquisa acadêmica para submissão e apresentação no congresso científico Computer on the Beach (COTB). O projeto articula os campos de Jogos Digitais, Informática na Educação e Mulheres na Computação, alinhando-se diretamente aos Objetivos de Desenvolvimento Sustentável da Organização das Nações Unidas, em especial o ODS 05 (Igualdade de Gênero) e o ODS 04 (Educação de Qualidade).

O objetivo central da obra é resgatar o protagonismo de cientistas mulheres nos marcos fundacionais da computação, traduzindo suas contribuições teóricas e práticas em desafios interativos que estimulam o raciocínio lógico e a compreensão histórica da área.

## Contexto Científico e Metodologia

O jogo foi estruturado não apenas como entretenimento reflexivo, mas como um ambiente controlado de experimentação pedagógica para pesquisas de pós-graduação. 

Ao longo da experiência, o sistema registra automaticamente a telemetria do jogador em cada fase, contabilizando o tempo despendido em segundos e o número de tentativas necessárias para a resolução dos problemas. Ao término da jornada, na tela de encerramento, o participante responde a itens de percepção prévia e impacto formativo, sendo disponibilizada a exportação desses dados em formato JSON estruturado. Esse mecanismo viabiliza a coleta empírica de métricas quantitativas e qualitativas para embasamento de artigos e estudos de usabilidade.

## Estrutura das Fases Históricas

A progressão pedagógica compreende seis eras fundamentais da computação, cada qual contextualizada por diálogos históricos e mecânicas de jogo condizentes com os métodos da época.

### Fase 1: Ada Lovelace (1843)
Apresenta a autoria do primeiro algoritmo da história humana, documentado na Nota G para a Máquina Analítica de Charles Babbage. O jogador assume o desafio de analisar a lógica de cálculo dos Números de Bernoulli, organizando sequencialmente os cartões perfurados responsáveis por entrada de dados, controle de repetição, cálculo analítico e impressão de resultados.

### Fase 2: As Garotas do ENIAC (1945)
Homenageia o grupo de programadoras pioneiras do Electronic Numerical Integrator and Computer, formado por Kathleen McNulty, Frances Bilas, Betty Jean Jennings, Ruth Lichterman, Elizabeth Snyder e Marlyn Wescoff. A mecânica aborda a programação física por meio de cabos de manobra e chaves rotativas, desafiando o participante a interconectar o gerador de pulso mestre, os acumuladores de dados e a unidade de integração balística.

### Fase 3: Grace Hopper (1947)
Retrata o episódio de catalogação do primeiro bug documentado na história dos computadores eletromecânicos, ocorrido no Harvard Mark II, além de introduzir a gênese dos compiladores modernos e linguagens de alto nível como o COBOL. O jogador deve inspecionar os bancos de relés físicos para localizar a obstrução causada pela mariposa e restabelecer a condução do circuito lógico.

### Fase 4: Katherine Johnson (1962)
Explora o trabalho da matemática e física orbital da NASA durante o Projeto Mercury e as missões Apollo. Diante das desconfianças iniciais da equipe em relação aos recém-introduzidos computadores eletrônicos IBM, o jogador realiza a validação analítica das variáveis de empuxo, azimute e altitude para garantir a trajetória orbital segura do astronauta John Glenn.

### Fase 5: Irmã Mary Kenneth Keller (1965)
Dedicada à primeira mulher a obter o título de Doutora em Ciência da Computação nos Estados Unidos, co-criadora da linguagem de programação BASIC no Dartmouth College e pioneira na aplicação de computadores na educação. O desafio consiste em recompor instruções fundamentais de programação estruturada voltadas à pesquisa iniciante e à democratização do acesso à tecnologia.

### Fase 6: Margaret Hamilton (1969)
Destaca a atuação da diretora de Engenharia de Software do MIT para o Programa Apollo da NASA. A bordo do Módulo Lunar da Apollo 11, a menos de três minutos do pouso e a 3000 metros da superfície lunar, o Apollo Guidance Computer (AGC) entra em regime de sobrecarga de 115% devido a leituras espúrias do radar de aproximação (Alarme 1202). O jogador deve aplicar os princípios do agendamento assíncrono por prioridade, descartando processos não essenciais sem comprometer os motores de descida e a navegação inercial, possibilitando a autorização segura do pouso na Lua.

## Especificações Técnicas e Arquitetura

O projeto foi construído sobre a arquitetura da Godot Engine 4, utilizando GDScript estruturado de forma modular e independente de plugins proprietários.

1. Renderização: Configurado com o backend de compatibilidade gráfica gl_compatibility (WebGL 2.0), garantindo tempo mínimo de carregamento e alta fidelidade visual em navegadores móveis e desktops.
2. Interface do Usuário: Resolução base de 1280x720 pixels com adaptação vetorial de fontes e elementos gráficos em formato SVG, assegurando legibilidade em diferentes escalas de tela sem degradação visual.
3. Sonorização: Combina temas musicais dedicados na tela inicial com sistema próprio de áudio procedural para efeitos sonoros de clique, validação, erro e conclusão de etapas.
4. Cabeçalhos de Isolamento de Origem: Para assegurar a operação das threads de WebAssembly e dos recursos de SharedArrayBuffer no navegador, a distribuição em produção conta com os cabeçalhos HTTP Cross-Origin-Opener-Policy (same-origin) e Cross-Origin-Embedder-Policy (require-corp) devidamente configurados no servidor.

## Execução Local

Para compilar ou executar o projeto a partir do código-fonte:

1. Instale o Godot Engine versão 4.2 ou superior (suporte nativo testado com Godot 4.6).
2. Clone o repositório utilizando o Git:
   git clone https://github.com/profthiagomendonca/Pioneiras-Alem.git
3. No inicializador do Godot, selecione a opção Importar e aponte para o diretório raiz do projeto onde reside o arquivo project.godot.
4. Pressione a tecla F5 para iniciar a execução em modo local.

## Demonstração Online

A versão web compilada para avaliação direta encontra-se acessível publicamente no seguinte endereço:

https://pioneirasealem.netlify.app/
