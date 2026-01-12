# Asegurar que estamos en el directorio correcto
Set-Location $PSScriptRoot

$port = 3000
$root = "$PSScriptRoot\public"
$countFile = "$PSScriptRoot\count.txt"

# Logging de error para debugging
function Log-Error($msg) {
    Add-Content -Path "server_error.log" -Value "[$(Get-Date)] $msg"
}

try {
    if (-not (Test-Path $countFile)) { Set-Content -Path $countFile -Value "0" }

    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://*:${port}/")
    # Nota: Usar '*' requiere Admin. Si falla, fallback a localhost
    
    try {
        $listener.Start()
    }
    catch {
        # Fallback a localhost si '*' falla
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://localhost:${port}/")
        $listener.Start()
    }

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $path = $request.Url.LocalPath
        $method = $request.HttpMethod
        
        # Headers CORS
        $response.AddHeader("Access-Control-Allow-Origin", "*")
        $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        $response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

        if ($method -eq "OPTIONS") {
            $response.StatusCode = 204
            $response.Close()
            continue
        }

        # Lógica Endpoints
        $currentCount = [int](Get-Content -Path $countFile)

        if ($path -eq "/api/increment" -and $method -eq "POST") {
            $currentCount++
            Set-Content -Path $countFile -Value $currentCount
            # Respond JSON
            $json = "{ ""count"": $currentCount }"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        elseif ($path -eq "/api/decrement" -and $method -eq "POST") {
            if ($currentCount -gt 0) { $currentCount-- }
            Set-Content -Path $countFile -Value $currentCount
            # Respond JSON
            $json = "{ ""count"": $currentCount }"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        elseif ($path -eq "/api/count" -and $method -eq "GET") {
            # Respond JSON
            $json = "{ ""count"": $currentCount }"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
            $response.ContentType = "application/json"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        else {
            # Static Files
            if ($path -eq "/") { $path = "/index.html" }
            $localPath = Join-Path $root $path.TrimStart('/')
            
            if (Test-Path $localPath -PathType Leaf) {
                $content = [System.IO.File]::ReadAllBytes($localPath)
                if ($localPath.EndsWith(".html")) { $response.ContentType = "text/html" }
                elseif ($localPath.EndsWith(".css")) { $response.ContentType = "text/css" }
                elseif ($localPath.EndsWith(".js")) { $response.ContentType = "text/javascript" }
                
                $response.ContentLength64 = $content.Length
                $response.OutputStream.Write($content, 0, $content.Length)
            }
            else {
                $response.StatusCode = 404
            }
        }
        $response.Close()
    }
}
catch {
    Log-Error $_.Exception.Message
}
