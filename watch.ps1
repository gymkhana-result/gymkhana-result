$path = "C:\LapRecorder\Result"
$filter = "index.html"

$lastRun = Get-Date "2000-01-01"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.Filter = $filter
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher Changed -Action {
    $now = Get-Date
    if (($now - $lastRun).TotalSeconds -lt 10) { return }

    $script:lastRun = $now
    Start-Sleep -Seconds 2

    Set-Location $path
    git add .
    git commit -m "auto update"
    git push

    Write-Host "Pushed at $now"
}

Write-Host "Watching for changes..."
while ($true) { Start-Sleep 5 }