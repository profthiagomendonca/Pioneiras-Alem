<#
.SYNOPSIS
    Coleta e consolida automaticamente os questionários do jogo Pioneiras & Além.
.DESCRIPTION
    1. Procura arquivos de resposta (JSON) na pasta Downloads e move para esta pasta.
    2. Lê todos os arquivos JSON desta pasta e compila uma planilha Excel/CSV consolidada.
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$downloadsDir = Join-Path $env:USERPROFILE "Downloads"
$csvPath = Join-Path $scriptDir "respostas_consolidadas.csv"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Pioneiras & Além - Consolidador de Questionários       " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Mover arquivos da pasta Downloads se existirem
$downloadedFiles = Get-ChildItem -Path $downloadsDir -Filter "Resposta_*.json" -ErrorAction SilentlyContinue
$downloadedFilesOld = Get-ChildItem -Path $downloadsDir -Filter "pesquisa_cotb_*.json" -ErrorAction SilentlyContinue
$allToMove = @($downloadedFiles) + @($downloadedFilesOld)

if ($allToMove.Count -gt 0) {
    Write-Host "[+] Encontrados $($allToMove.Count) arquivo(s) na pasta Downloads:" -ForegroundColor Green
    foreach ($f in $allToMove) {
        $dest = Join-Path $scriptDir $f.Name
        Move-Item -Path $f.FullName -Destination $dest -Force
        Write-Host "    -> Movido: $($f.Name)" -ForegroundColor Gray
    }
} else {
    Write-Host "[i] Nenhum novo arquivo pendente na pasta Downloads." -ForegroundColor Gray
}

# 2. Ler todos os arquivos JSON na pasta atual
$jsonFiles = Get-ChildItem -Path $scriptDir -Filter "*.json" -ErrorAction SilentlyContinue

if ($jsonFiles.Count -eq 0) {
    Write-Host "[-] Nenhum arquivo de resposta (.json) encontrado nesta pasta." -ForegroundColor Yellow
    Write-Host "    Jogue o jogo e clique em 'Salvar / Baixar Respostas' no final!" -ForegroundColor Gray
    exit
}

Write-Host "[+] Processando $($jsonFiles.Count) arquivo(s) de resposta..." -ForegroundColor Green

$rows = [System.Collections.ArrayList]::new()
$header = '"Data_Hora";"Nome";"Cidade";"Pontos";"Pre_Conhecia_Pioneiras";"Pre_Ja_Programou";"Ada_Tempo_s";"Ada_Tentativas";"Ada_Sintese";"ENIAC_Tempo_s";"ENIAC_Tentativas";"ENIAC_Sintese";"Grace_Tempo_s";"Grace_Tentativas";"Grace_Sintese";"Katherine_Tempo_s";"Katherine_Tentativas";"Katherine_Sintese";"Keller_Tempo_s";"Keller_Tentativas";"Keller_Sintese";"Margaret_Tempo_s";"Margaret_Tentativas";"Margaret_Sintese";"Edith_Epilogo";"Pos_Q1_Relacao_Moderna";"Pos_Q2_Percepcao_ODS5";"Pos_Q3_Metodologia_Facilitou";"Pos_Q4_Pioneirismo_Brasileiro"'
[void]$rows.Add($header)

foreach ($jf in $jsonFiles) {
    try {
        $content = Get-Content -Path $jf.FullName -Raw -Encoding UTF8
        $data = $content | ConvertFrom-Json

        $st = $data.stages_telemetry
        $pre = $data.pre_survey
        $pos = $data.post_test_answers

        $lineValues = @(
            $data.timestamp,
            $data.participante.nome,
            $data.participante.cidade,
            $data.total_score,
            $(if ($pre.conhecimento_previo_pioneiras) { "Sim" } else { "Nao" }),
            $(if ($pre.ja_programou_antes) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.ada.time_spent, 1),
            $st.ada.attempts,
            $(if ($st.ada.read_synthesis) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.eniac.time_spent, 1),
            $st.eniac.attempts,
            $(if ($st.eniac.read_synthesis) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.grace.time_spent, 1),
            $st.grace.attempts,
            $(if ($st.grace.read_synthesis) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.katherine.time_spent, 1),
            $st.katherine.attempts,
            $(if ($st.katherine.read_synthesis) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.keller.time_spent, 1),
            $st.keller.attempts,
            $(if ($st.keller.read_synthesis) { "Sim" } else { "Nao" }),
            [math]::Round([double]$st.margaret.time_spent, 1),
            $st.margaret.attempts,
            $(if ($st.margaret.read_synthesis) { "Sim" } else { "Nao" }),
            $(if ($data.edith_epilogue_viewed) { "Sim" } else { "Nao" }),
            $(if ($pos.compreendeu_relacao_moderna) { "Sim" } else { "Nao" }),
            $(if ($pos.percepcao_ods05_mulheres_ti) { "Sim" } else { "Nao" }),
            $(if ($pos.metodologia_facilitou_aprendizagem) { "Sim" } else { "Nao" }),
            $(if ($pos.valorizou_pioneirismo_brasileiro) { "Sim" } else { "Nao" })
        )

        $csvLine = '"' + ($lineValues -join '";"') + '"'
        [void]$rows.Add($csvLine)
    }
    catch {
        Write-Host "    [!] Erro ao ler $($jf.Name): $_" -ForegroundColor Red
    }
}

# Salvar CSV com codificação UTF8 e BOM para abrir direto no Excel
$csvContent = $rows -join "`r`n"
$utf8BOM = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($csvPath, $csvContent, $utf8BOM)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "[OK] Sucesso! Planilha gerada com $($rows.Count - 1) registro(s):" -ForegroundColor Green
Write-Host "     $csvPath" -ForegroundColor Yellow
Write-Host "     (Basta dar um duplo clique para abrir no Microsoft Excel!)" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
