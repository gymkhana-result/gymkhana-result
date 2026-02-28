$path = "C:\LapRecorder\Result"
$file = "index.html"
$fullPath = Join-Path $path $file

Write-Host "Watching for changes..."

$lastWrite = (Get-Item $fullPath).LastWriteTime

while ($true) {

    Start-Sleep -Seconds 5

    $currentWrite = (Get-Item $fullPath).LastWriteTime

    if ($currentWrite -ne $lastWrite) {

        Write-Host "Change detected at $currentWrite"

        # Shift_JIS → UTF-8 変換
        $content = Get-Content $fullPath -Encoding Default
        Set-Content $fullPath -Value $content -Encoding UTF8

        # 変換後の更新時刻を再取得（無限ループ防止）
        $lastWrite = (Get-Item $fullPath).LastWriteTime

        Set-Location $path
        git add .
        git commit -m "auto update (utf8)"
        git push

        Write-Host "Converted to UTF8 & Pushed"
    }
}