# Gera os assets de imagem do site Star VIP a partir das imagens originais baixadas.
# Uso: powershell -ExecutionPolicy Bypass -File .\build-img.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src  = Join-Path $root 'img\_orig'
$out  = Join-Path $root 'img'
New-Item -ItemType Directory -Force -Path $out | Out-Null
Add-Type -AssemblyName System.Drawing

function Get-Crop([string]$path, [int]$x, [int]$y, [int]$w, [int]$h, [double]$scale) {
  $img = [System.Drawing.Image]::FromFile($path)
  $rect = [System.Drawing.Rectangle]::new($x, $y, $w, $h)
  $bmp = [System.Drawing.Bitmap]::new([int]($w * $scale), [int]($h * $scale))
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($img, ([System.Drawing.Rectangle]::new(0, 0, $bmp.Width, $bmp.Height)), $rect, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose(); $img.Dispose()
  return $bmp
}

function Save-Jpg([System.Drawing.Bitmap]$bmp, [string]$name, [long]$quality) {
  $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  $p = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $p.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $quality)
  $bmp.Save((Join-Path $out $name), $enc, $p)
  $bmp.Dispose()
}

# ---- LOGO com fundo transparente (recortado do flyer de feriado) ----
$logo = Get-Crop (Join-Path $src 'hi-feriado.jpg') 330 1128 420 148 3
$rect = [System.Drawing.Rectangle]::new(0, 0, $logo.Width, $logo.Height)
$data = $logo.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bytes = New-Object byte[] ($data.Stride * $logo.Height)
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
for ($i = 0; $i -lt $bytes.Length; $i += 4) {
  $b = [int]$bytes[$i]; $gr = [int]$bytes[$i + 1]; $r = [int]$bytes[$i + 2]
  $lum = 0.299 * $r + 0.587 * $gr + 0.114 * $b
  $mx  = [Math]::Max($r, [Math]::Max($gr, $b))
  if ($lum -lt 38 -and $mx -lt 72) { $bytes[$i + 3] = 0 }
  elseif ($lum -lt 95) {
    $a = [int](($lum - 38) * 4)
    if ($a -lt 0) { $a = 0 }; if ($a -gt 255) { $a = 255 }
    $bytes[$i + 3] = [byte]$a
  }
}
[System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
$logo.UnlockBits($data)
$logo.Save((Join-Path $out 'logo.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$logo.Dispose()

# ---- FOTOS (recortes limpos, sem textos/doodles dos flyers) ----
# Fachada do prédio (recorte interno, sem moldura nem pino do mapa)
Save-Jpg (Get-Crop (Join-Path $src 'c4-fachada.jpg') 20 20 695 570 1.6) 'fachada.jpg' 85
# Vestiário reformulado (faixa limpa do post "cara nova", sem o texto "arraste")
Save-Jpg (Get-Crop (Join-Path $src 'hi-caranova.jpg') 0 845 1080 345 1.3) 'vestiario.jpg' 84
# Teto com iluminação de LED + logo (faixa limpa, 1080x330)
Save-Jpg (Get-Crop (Join-Path $src 'c2-detalle-led.jpg') 0 0 1080 330 1.3) 'teto-led.jpg' 85
# Logo em alto-relevo na parede preta
Save-Jpg (Get-Crop (Join-Path $src 'c7-logo-parede.jpg') 0 0 737 726 1.5) 'logo-parede.jpg' 85
# Halteres (faixa limpa do destaque de horários)
Save-Jpg (Get-Crop (Join-Path $src 'hl-horarios.jpg') 0 0 480 168 2.5) 'halteres.jpg' 85

# ---- OG IMAGE (1200x630) composta: carvão + diagonais vermelhas + logo ----
$og = [System.Drawing.Bitmap]::new(1200, 630)
$g = [System.Drawing.Graphics]::FromImage($og)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::FromArgb(255, 18, 18, 20))
$red = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 208, 17, 27))
# faixas diagonais no canto superior direito
$g.FillPolygon($red, [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(820, 0), [System.Drawing.Point]::new(1200, 0),
    [System.Drawing.Point]::new(1200, 90), [System.Drawing.Point]::new(760, 90)))
$g.FillPolygon($red, [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(900, 120), [System.Drawing.Point]::new(1200, 120),
    [System.Drawing.Point]::new(1200, 165), [System.Drawing.Point]::new(870, 165)))
# faixa diagonal inferior esquerda
$g.FillPolygon($red, [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(0, 540), [System.Drawing.Point]::new(430, 540),
    [System.Drawing.Point]::new(400, 630), [System.Drawing.Point]::new(0, 630)))
$g.Dispose()
# logo centralizado
$lg = [System.Drawing.Image]::FromFile((Join-Path $out 'logo.png'))
$lw = 640; $lh = [int]($lg.Height * $lw / $lg.Width)
$g2 = [System.Drawing.Graphics]::FromImage($og)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.DrawImage($lg, [System.Drawing.Rectangle]::new(280, 235, $lw, $lh))
$g2.Dispose(); $lg.Dispose()
Save-Jpg $og 'og-image.jpg' 88

# ---- FAVICON (estrela vermelha do logo) ----
$fav = Get-Crop (Join-Path $src 'hi-feriado.jpg') 380 1128 110 110 2
$fav.Save((Join-Path $out 'favicon.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$fav.Dispose()

Write-Output 'Assets gerados:'
Get-ChildItem $out -File | ForEach-Object {
  $i = [System.Drawing.Image]::FromFile($_.FullName)
  '{0,-20} {1,5}x{2,-5} {3,7:N0} KB' -f $_.Name, $i.Width, $i.Height, ($_.Length / 1KB)
  $i.Dispose()
}
