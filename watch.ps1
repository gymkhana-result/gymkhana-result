$path = "C:\LapRecorder\Result"
$file = "index.html"
$fullPath = Join-Path $path $file

Write-Host "Watching for changes..."

$lastWrite = (Get-Item $fullPath).LastWriteTime

while ($true) {

    Start-Sleep -Seconds 5
    $currentWrite = (Get-Item $fullPath).LastWriteTime

    if ($currentWrite -ne $lastWrite) {

        Write-Host "Change detected. Waiting for file to stabilize..."

        # 安定待ち（10秒）
        Start-Sleep -Seconds 10

        $checkWrite = (Get-Item $fullPath).LastWriteTime

        # 10秒後に変更がなければ確定
        if ($checkWrite -eq $currentWrite) {

            Write-Host "File stabilized. Converting & Pushing..."

            # Shift_JIS(Default)で読む
            $content = Get-Content $fullPath -Encoding Default

            # charsetを書き換え
            $content = $content -replace "charset=shift_jis", "charset=utf-8"

            # UTF8(BOM付き)で保存
            $utf8 = New-Object System.Text.UTF8Encoding $true
            [System.IO.File]::WriteAllLines($fullPath, $content, $utf8)

            $lastWrite = (Get-Item $fullPath).LastWriteTime

            Set-Location $path
            git add .
            git commit -m "auto update (stable)"
            git push

            Write-Host "Converted & Pushed"
        }
        else {
            Write-Host "File still changing. Skipped."
        }
    }
}