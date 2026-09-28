# Создаёт ключ подписи для Google Play и файл android/key.properties.
# Запуск (из папки проекта):
#   powershell -ExecutionPolicy Bypass -File tool\create_upload_key.ps1
$ErrorActionPreference = 'Stop'

$keytool = Join-Path $env:ProgramFiles 'Android\Android Studio\jbr\bin\keytool.exe'
if (-not (Test-Path $keytool)) {
    $cmd = Get-Command keytool -ErrorAction SilentlyContinue
    if ($cmd) { $keytool = $cmd.Source } else { throw 'Не найден keytool (ставится вместе с Android Studio).' }
}

$dir = Join-Path $env:USERPROFILE 'keys'
New-Item -ItemType Directory -Force $dir | Out-Null
$keystore = Join-Path $dir 'wine-explorer-upload.jks'
$props = Join-Path $PSScriptRoot '..\android\key.properties'

if (Test-Path $keystore) { throw "Ключ уже существует: $keystore — не перезаписываю." }
if (Test-Path $props) { throw "Файл уже существует: $props — не перезаписываю." }

function Read-Password([string]$prompt) {
    $secure = Read-Host $prompt -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

Write-Host ''
Write-Host 'Пароль: минимум 6 символов, только латинские буквы и цифры.' -ForegroundColor Yellow
Write-Host 'При вводе символы не видны — это нормально.' -ForegroundColor Yellow
$p1 = Read-Password 'Придумайте пароль'
$p2 = Read-Password 'Повторите пароль'
if ($p1 -ne $p2) { throw 'Пароли не совпадают. Запустите скрипт ещё раз.' }
if ($p1.Length -lt 6) { throw 'Пароль короче 6 символов.' }
if ($p1 -notmatch '^[A-Za-z0-9]+$') { throw 'В пароле допустимы только латинские буквы и цифры.' }

& $keytool -genkeypair -v -keystore $keystore -keyalg RSA -keysize 2048 -validity 10000 `
    -alias upload -storepass $p1 -keypass $p1 -dname 'CN=Vitali Ermisco, L=Chisinau, C=MD'
if ($LASTEXITCODE -ne 0) { throw 'keytool завершился с ошибкой.' }

$storeFile = $keystore -replace '\', '/'
@(
    "storePassword=$p1"
    "keyPassword=$p1"
    'keyAlias=upload'
    "storeFile=$storeFile"
) | Set-Content -Path $props -Encoding ascii

Write-Host ''
Write-Host "Готово! Ключ: $keystore" -ForegroundColor Green
Write-Host "Настройки сборки: $((Resolve-Path $props).Path)" -ForegroundColor Green
Write-Host 'Сохраните копию .jks и пароль в надёжном месте (менеджер паролей, флешка).' -ForegroundColor Yellow
