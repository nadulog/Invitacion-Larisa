Add-Type -AssemblyName System.Drawing

$assets = Join-Path $PSScriptRoot 'assets'
$source = Join-Path (Split-Path $PSScriptRoot -Parent) 'Invitacion Delfina\assets'
$fontBodoni = 'C:\Windows\Fonts\BOD_R.TTF'
$fontArial = 'C:\Windows\Fonts\arial.ttf'

function New-Font([string]$path, [float]$size, [System.Drawing.FontStyle]$style = [System.Drawing.FontStyle]::Regular) {
  $private = [System.Drawing.Text.PrivateFontCollection]::new()
  $private.AddFontFile($path)
  $font = [System.Drawing.Font]::new($private.Families[0], $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
  return @{ Font = $font; Collection = $private }
}

function Draw-CenteredText($graphics, [string]$text, $font, $brush, [float]$y, [float]$canvasWidth) {
  $size = $graphics.MeasureString($text, $font)
  $graphics.DrawString($text, $font, $brush, ($canvasWidth - $size.Width) / 2, $y)
}

function Draw-SpacedText($graphics, [string]$text, $font, $brush, [float]$x, [float]$y, [float]$spacing) {
  foreach ($character in $text.ToCharArray()) {
    $part = [string]$character
    $graphics.DrawString($part, $font, $brush, $x, $y)
    $x += $graphics.MeasureString($part, $font).Width + $spacing
  }
}

# Portada: usa la fotografía original sin alterar la identidad ni la pose.
$photo = [System.Drawing.Image]::FromFile((Join-Path $assets 'larisa-portada.jpeg'))
$cover = [System.Drawing.Bitmap]::new(941, 1412)
$g = [System.Drawing.Graphics]::FromImage($cover)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($photo, [System.Drawing.Rectangle]::new(0, 0, 941, 1412))
$shade = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(34, 0, 4, 14))
$g.FillRectangle($shade, 0, 0, 941, 1412)
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 245, 247))
$silver = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(219, 222, 230))
$smallFontData = New-Font $fontArial 28
$nameFontData = New-Font $fontBodoni 205
Draw-SpacedText $g 'MIS XV' $smallFontData.Font $white 72 208 11
$g.DrawString('Lari', $nameFontData.Font, $silver, 37, 228)
$smallFontData.Font.Dispose(); $smallFontData.Collection.Dispose()
$nameFontData.Font.Dispose(); $nameFontData.Collection.Dispose()
$white.Dispose(); $silver.Dispose(); $shade.Dispose(); $g.Dispose(); $photo.Dispose()
$cover.Save((Join-Path $assets 'portada-xv-lari.jpeg'), [System.Drawing.Imaging.ImageFormat]::Jpeg)
$cover.Dispose()

# Fecha: conserva labios, composición y botón originales; reemplaza solo los datos necesarios.
$date = [System.Drawing.Bitmap]::new((Join-Path $source 'fecha-hora-2026.png'))
$g = [System.Drawing.Graphics]::FromImage($date)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$black = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black)
$blue = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(8, 54, 245))
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 237, 242))
$g.FillRectangle($black, 35, 175, 520, 475)
$g.FillRectangle($black, 70, 1430, 790, 83)
$dayFontData = New-Font $fontArial 31
$numberFontData = New-Font $fontBodoni 290
$timeFontData = New-Font $fontArial 27
Draw-SpacedText $g 'VIERNES' $dayFontData.Font $white 68 212 21
$g.DrawString('16', $numberFontData.Font, $blue, 48, 260)
Draw-CenteredText $g 'DE 22:00 A 04:30 HS' $timeFontData.Font $white 1446 941
$dayFontData.Font.Dispose(); $dayFontData.Collection.Dispose()
$numberFontData.Font.Dispose(); $numberFontData.Collection.Dispose()
$timeFontData.Font.Dispose(); $timeFontData.Collection.Dispose()
$black.Dispose(); $blue.Dispose(); $white.Dispose(); $g.Dispose()
$date.Save((Join-Path $assets 'fecha-hora-lari.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$date.Dispose()

# Ubicación: conserva el fondo y el botón de la placa original.
$location = [System.Drawing.Bitmap]::new((Join-Path $source 'como-llegar.png'))
$g = [System.Drawing.Graphics]::FromImage($location)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$black = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 2, 2, 3))
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 237, 242))
$g.FillRectangle($black, 30, 470, 881, 690)
$labelFontData = New-Font $fontArial 23
$titleFontData = New-Font $fontBodoni 118
$addressFontData = New-Font $fontArial 30
Draw-SpacedText $g 'NOS ENCONTRAMOS EN' $labelFontData.Font $white 180 500 10
Draw-CenteredText $g 'BIG PARTY' $titleFontData.Font $white 610 941
$g.DrawLine([System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(225, 230, 235), 2), 112, 940, 832, 940)
$bluePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(0, 91, 255), 4)
$g.DrawLine($bluePen, 410, 940, 535, 940)
Draw-CenteredText $g 'Polcos, Valle Viejo' $addressFontData.Font $white 1048 941
$labelFontData.Font.Dispose(); $labelFontData.Collection.Dispose()
$titleFontData.Font.Dispose(); $titleFontData.Collection.Dispose()
$addressFontData.Font.Dispose(); $addressFontData.Collection.Dispose()
$bluePen.Dispose(); $black.Dispose(); $white.Dispose(); $g.Dispose()
$location.Save((Join-Path $assets 'como-llegar-lari.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$location.Dispose()

# Confirmación: mantiene el túnel espejado y elimina la fecha límite no informada.
$rsvp = [System.Drawing.Bitmap]::new((Join-Path $source 'confirmar-asistencia.png'))
$g = [System.Drawing.Graphics]::FromImage($rsvp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$black = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black)
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 245, 247))
$soft = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(225, 228, 235))
$g.FillRectangle($black, 125, 500, 690, 500)
$titleFontData = New-Font $fontBodoni 124
$copyFontData = New-Font $fontArial 31
$question = ([string][char]0x00BF) + 'Ven' + ([string][char]0x00ED) + 's?'
$confirmCopy = 'Confirm' + ([string][char]0x00E1) + ' tu asistencia'
Draw-CenteredText $g $question $titleFontData.Font $white 515 941
Draw-CenteredText $g 'Quiero festejar esta noche' $copyFontData.Font $soft 750 941
Draw-CenteredText $g 'con vos.' $copyFontData.Font $soft 795 941
Draw-CenteredText $g $confirmCopy $copyFontData.Font $soft 890 941
$titleFontData.Font.Dispose(); $titleFontData.Collection.Dispose()
$copyFontData.Font.Dispose(); $copyFontData.Collection.Dispose()
$black.Dispose(); $white.Dispose(); $soft.Dispose(); $g.Dispose()
$rsvp.Save((Join-Path $assets 'confirmar-asistencia-lari.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$rsvp.Dispose()

Copy-Item -LiteralPath (Join-Path $source 'dress-code.png') -Destination (Join-Path $assets 'dress-code-lari.png') -Force

Write-Output 'Placas de Larisa generadas correctamente.'
