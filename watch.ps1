$path = "C:\LapRecorder\Result"
$filter = "index.html"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.Filter = $filter
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    Start-Sleep -Seconds 2

    Set-Location $path
    git add .
    git commit -m "auto update"
    git push

    Write-Host "Pushed at $(Get-Date)"
}

Write-Host "Watching for changes..."
while ($true) { Start-Sleep 5 }