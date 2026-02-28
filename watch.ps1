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

        # Shift_JIS 明示指定で読む
        $content = Get-Content $fullPath -Encoding Shift_JIS

        # UTF8 (BOM付き) で明示保存
        $utf8 = New-Object System.Text.UTF8Encoding $true
        [System.IO.File]::WriteAllLines($fullPath, $content, $utf8)

        $lastWrite = (Get-Item $fullPath).LastWriteTime

        Set-Location $path
        git add .
        git commit -m "auto update (utf8)"
        git push

        Write-Host "Converted to UTF8 & Pushed"
    }
}