$path = "C:\LapRecorder\Result"
$file = "index.html"
$fullPath = Join-Path $path $file

$lastWrite = (Get-Item $fullPath).LastWriteTime

Write-Host "Watching for changes..."

while ($true) {

    Start-Sleep -Seconds 5

    $currentWrite = (Get-Item $fullPath).LastWriteTime

    if ($currentWrite -ne $lastWrite) {

        $lastWrite = $currentWrite

        Write-Host "Change detected at $currentWrite"

        $content = Get-Content $fullPath -Encoding Default
        Set-Content $fullPath -Value $content -Encoding UTF8

        Set-Location $path
        git add .
        git commit -m "auto update"
        git push

        Write-Host "Converted & Pushed"
    }
}