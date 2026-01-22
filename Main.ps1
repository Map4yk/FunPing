$servers = @(
    "play2.funtime.su:25565",
    "mc.funtime.su:25565",
    "tcp.funtime.sh:25565",
    "neo.funtime.sh:25565",
    "connect.funtime.su:25565",
    "tt.funtime.su:25565",
    "test-tcp.funtime.sh:25565",
    "test-neo.funtime.sh:25565",
    "tcpshield.funtime.me:25565",
    "neoprotect.funtime.me:25565",
    "tcpshield.funtime.su:25565",
    "neoprotect.funtime.su:25565",
    "tcpshield-ovh.funtime.su:25565"
)

function Test-Port {
    param([string]$h, [int]$p)
    try {
        $c = New-Object System.Net.Sockets.TcpClient
        $r = $c.BeginConnect($h, $p, $null, $null)
        $w = $r.AsyncWaitHandle.WaitOne(2000, $false)
        if ($w) { try { $c.EndConnect($r); $true } catch { $false } } else { $false }
        $c.Close()
    } catch { $false }
}

$results = @()

foreach ($s in $servers) {
    $h, $p = $s -split ":"
    Write-Host "[+] IP: $h - " -ForegroundColor Yellow -NoNewline

    $m = Measure-Command { $open = Test-Port $h $p }
    $tcp = [math]::Round($m.TotalMilliseconds, 2)
    $hops = (tracert -d -h 15 -w 1000 $h | Where-Object { $_ -match '^\s*\d+' }).Count

    if ($open) {
        $results += [PSCustomObject]@{Host=$s; Hops=$hops; TCP=$tcp}
        Write-Host "OK | Hops: $hops | Ping: $tcp ms" -ForegroundColor Green
    } else {
        Write-Host "CLOSED" -ForegroundColor Red
    }
}

$maxHops = ($results | Measure-Object -Property Hops -Maximum).Maximum
$maxTcp = ($results | Measure-Object -Property TCP -Maximum).Maximum

$scored = $results | ForEach-Object {
    $hopScore = if ($maxHops -gt 0) { $_.Hops / $maxHops } else { 0 }
    $tcpScore = if ($maxTcp -gt 0) { $_.TCP / $maxTcp } else { 0 }
    $_ | Add-Member -NotePropertyName Score -NotePropertyValue ([math]::Round($hopScore * 0.7 + $tcpScore * 0.3, 4)) -PassThru
}

Write-Host "`nTOP-5 SERVERS:" -ForegroundColor DarkYellow
$top5 = $scored | Sort-Object Score | Select-Object -First 5
$rank = 1
$top5 | ForEach-Object {
    $color = if ($rank -eq 1) { "Green" } else { "Gray" }
    Write-Host " #$rank $($_.Host) | Hops: $($_.Hops) | Ping: $($_.TCP) ms" -ForegroundColor $color
    $rank++
}

$best = $top5 | Select-Object -First 1
Write-Host "`nRecommended server: " -ForegroundColor Green -NoNewline
Write-Host $best.Host -ForegroundColor Yellow -NoNewline
Write-Host " (Ping: " -ForegroundColor Green -NoNewline
Write-Host "$($best.TCP) ms" -ForegroundColor Cyan -NoNewline
Write-Host ", Hops: " -ForegroundColor Green -NoNewline
Write-Host "$($best.Hops)" -ForegroundColor Cyan -NoNewline
Write-Host ")" -ForegroundColor Green
