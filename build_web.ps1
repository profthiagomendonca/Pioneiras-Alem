$ErrorActionPreference = "Stop"

$baseDir = $PSScriptRoot
$godotBin = "C:\Users\thiag\Downloads\Godot_v4.6.2-stable_win64.exe (1)\Godot_v4.6.2-stable_win64_console.exe"
$webBuildDir = Join-Path $baseDir "web_build"
$outerWebBuildDir = Resolve-Path (Join-Path $baseDir "..\web_build") -ErrorAction SilentlyContinue
$indexHtml = Join-Path $webBuildDir "index.html"

Write-Host "=== 1. EXPORTANDO GODOT WEB RELEASE ===" -ForegroundColor Cyan
& $godotBin --headless --export-release "Web" "web_build/index.html"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Godot export falhou com código de saída $LASTEXITCODE"
}
Write-Host "[OK] Export do Godot concluído com sucesso." -ForegroundColor Green

Write-Host "=== 2. VERIFICANDO OVERLAY DE ROTAÇÃO EM INDEX.HTML ===" -ForegroundColor Cyan
$content = [System.IO.File]::ReadAllText($indexHtml, [System.Text.Encoding]::UTF8)

if (-not $content.Contains("#rotate-screen-overlay")) {
    $overlayCss = @"

#rotate-screen-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	background: linear-gradient(135deg, #180e22 0%, #0d0814 100%);
	z-index: 100000;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	text-align: center;
	padding: 24px;
	box-sizing: border-box;
	color: #f7fafc;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

@media screen and (orientation: portrait) {
	#rotate-screen-overlay {
		display: flex !important;
	}
}

.rotate-phone-box {
	width: 80px;
	height: 80px;
	margin-bottom: 20px;
	color: #f6ad55;
	animation: rotateAnim 2.5s ease-in-out infinite;
}

.rotate-phone-svg {
	width: 100%;
	height: 100%;
}

@keyframes rotateAnim {
	0%, 15% {
		transform: rotate(0deg);
	}
	50%, 75% {
		transform: rotate(-90deg);
	}
	90%, 100% {
		transform: rotate(0deg);
	}
}

.rotate-title {
	font-size: 24px;
	font-weight: 700;
	margin: 0 0 12px 0;
	color: #f6ad55;
	text-shadow: 0 2px 8px rgba(0,0,0,0.4);
}

.rotate-desc {
	font-size: 16px;
	line-height: 1.5;
	color: #e2e8f0;
	max-width: 340px;
	margin: 0 0 24px 0;
}

.rotate-button {
	background: linear-gradient(135deg, #d69e2e 0%, #b7791f 100%);
	color: #1a202c;
	font-weight: bold;
	font-size: 15px;
	padding: 12px 24px;
	border: none;
	border-radius: 8px;
	box-shadow: 0 4px 14px rgba(214, 158, 46, 0.4);
	cursor: pointer;
	transition: transform 0.15s ease, background 0.2s ease;
}

.rotate-button:hover, .rotate-button:active {
	transform: scale(1.04);
	background: #ecc94b;
}
"@

    $overlayHtml = @"
		<div id="rotate-screen-overlay">
			<div class="rotate-phone-box">
				<svg class="rotate-phone-svg" viewBox="0 0 48 48" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
					<rect x="12" y="6" width="24" height="36" rx="4" />
					<circle cx="24" cy="36" r="1.5" fill="currentColor" />
					<path d="M 38 18 C 42 22, 42 28, 38 32" stroke="#f6ad55" stroke-width="2.5" />
					<polyline points="35,16 39,18 41,14" stroke="#f6ad55" stroke-width="2.5" />
				</svg>
			</div>
			<h2 class="rotate-title">Gire seu aparelho</h2>
			<p class="rotate-desc">
				Para melhor visualização e jogabilidade, use <strong>Pioneiras & Além</strong> na <strong>horizontal (modo paisagem)</strong>.
			</p>
			<button id="btn-rotate-fullscreen" class="rotate-button" onclick="requestLandscapeMode()">
				Girar e Entrar em Tela Cheia
			</button>
		</div>

"@

    $overlayJs = @"

function requestLandscapeMode() {
	var doc = document.documentElement;
	var req = doc.requestFullscreen || doc.webkitRequestFullscreen || doc.mozRequestFullScreen || doc.msRequestFullscreen;
	if (req) {
		req.call(doc).then(function() {
			if (screen.orientation && screen.orientation.lock) {
				screen.orientation.lock('landscape').catch(function(e) { console.log('Orientation lock not supported:', e); });
			}
		}).catch(function(e) {
			console.log('Fullscreen error:', e);
		});
	} else if (screen.orientation && screen.orientation.lock) {
		screen.orientation.lock('landscape').catch(function(e) { console.log('Orientation lock not supported:', e); });
	}
}
"@

    $content = $content.Replace("</style>", "$overlayCss`n`t`t</style>")
    $statusDiv = '<div id="status">'
    $content = $content.Replace($statusDiv, "$overlayHtml`t`t$statusDiv")
    $content = $content.Replace("</script>`r`n`t</body>", "$overlayJs`n`t`t</script>`r`n`t</body>")
    $content = $content.Replace("</script>`n`t</body>", "$overlayJs`n`t`t</script>`n`t</body>")

    [System.IO.File]::WriteAllText($indexHtml, $content, [System.Text.Encoding]::UTF8)
    Write-Host "[OK] Overlay de rotação injetado com sucesso em index.html" -ForegroundColor Green
} else {
    Write-Host "[INFO] Overlay de rotação já presente em index.html" -ForegroundColor Yellow
}

if ($outerWebBuildDir -and (Test-Path $outerWebBuildDir)) {
    Write-Host "=== 3. SINCRONIZANDO COM A PASTA EXTERNA ($outerWebBuildDir) ===" -ForegroundColor Cyan
    Copy-Item -Path "$webBuildDir\*" -Destination $outerWebBuildDir -Recurse -Force
    Write-Host "[OK] Pasta externa web_build sincronizada com sucesso!" -ForegroundColor Green
}

Write-Host "=== PROCESSO FINALIZADO COM SUCESSO! ===" -ForegroundColor Green
