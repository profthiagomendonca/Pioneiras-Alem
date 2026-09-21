# Pioneiras & Além: O Código Invisível

**Pioneiras & Além** é um jogo educativo e narrativo em **Godot 4**, concebido especificamente para submissão ao evento científico **Computer on the Beach (COTB)**, alinhado à temática central do **ODS 05 (Igualdade de Gênero)** e aos tópicos de **Jogos Digitais / Jogos Educativos / Mulheres na Computação / Informática na Educação**.

---

## 🎯 Objetivo Científico & Acadêmico
O jogo tem como objetivo resgatar e valorizar o protagonismo de cientistas mulheres nos marcos fundacionais da computação, além de servir como instrumento pedagógico e de coleta de dados para artigos científicos (avaliação pré/pós-teste, tempo de resolução e escala SUS).

### As Fases do Jogo:
1. **Fase 1 — Ada Lovelace (1843):**
   - *Conceito:* O Primeiro Algoritmo da história da humanidade (Nota G para a Máquina Analítica de Charles Babbage).
   - *Puzzle:* Ordenação sequencial dos cartões perfurados para o cálculo dos Números de Bernoulli (Entrada -> Laço -> Operação Analítica -> Saída).
2. **Fase 2 — Grace Hopper (1947):**
   - *Conceito:* O Primeiro Bug Documentado e a Criação dos Compiladores modernos (A-0 / COBOL).
   - *Puzzle:* Inspeção física dos relés eletromecânicos do Harvard Mark II para extrair a traça presa e compilação de instruções de alto nível para código de máquina.
3. **Fase 3 — Margaret Hamilton (1969):**
   - *Conceito:* A criação do termo "Engenharia de Software" e o software de voo da missão Apollo 11.
   - *Puzzle:* Gestão da fila de tarefas concorrentes do Apollo Guidance Computer (AGC) durante a descida lunar, mitigando os alarmes críticos 1201 e 1202 através de escalonamento assíncrono por prioridade.
4. **Tela de Vitória & Telemetria Científica:**
   - Exibição de tempos gastos por fase, número de tentativas e questionário de pós-teste com botão para copiar relatório em formato JSON estruturado.

---

## 🚀 Como Executar no Godot 4
1. Abra o **Godot Engine 4** (versão 4.2+ ou 4.6).
2. Na janela de projetos, clique em **Importar** (Import).
3. Selecione a pasta deste projeto (`Pioneiras&Alem`) ou o arquivo `project.godot`.
4. Pressione **F5** (ou o botão Play no canto superior direito) para rodar o jogo!

---

## 🌐 Exportação e Hospedagem no Netlify
O projeto já conta com toda a arquitetura de headers e compatibilidade configurada para rodar em 60 FPS com gráficos nítidos no navegador:

- **Renderizador:** `gl_compatibility` (WebGL 2.0 leve e veloz).
- **Resolução:** 1280x720 com modo `canvas_items` (proporção dinâmica, sem perda de nitidez).
- **Áudio:** Síntese procedural nativa em tempo real (`AudioManager.gd`), sem perdas de áudio ou estalos na web.
- **Cabeçalhos HTTP (`_headers` e `netlify.toml`):** Configurados com `Cross-Origin-Opener-Policy: same-origin` e `Cross-Origin-Embedder-Policy: require-corp` para garantir total suporte a `SharedArrayBuffer` e WebAssembly.
