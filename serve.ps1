# Servidor estatico minimo, usado pelo start.bat quando o Node.js nao esta instalado.
# Serve a pasta dist/. So aceita conexoes de localhost.
param(
  [string]$Root = (Join-Path $PSScriptRoot 'dist'),
  [int]$Port = 3000
)

$Root = (Resolve-Path $Root).Path.TrimEnd('\')
$types = @{
  '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript; charset=utf-8'; '.css' = 'text/css; charset=utf-8'
  '.json' = 'application/json'; '.svg' = 'image/svg+xml'; '.png' = 'image/png'; '.jpg' = 'image/jpeg'
  '.ico' = 'image/x-icon'; '.woff2' = 'font/woff2'; '.map' = 'application/json'
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
try { $listener.Start() } catch {
  Write-Host "  Nao foi possivel usar a porta $Port. Ela ja esta em uso? Feche o outro servidor e tente de novo." -ForegroundColor Red
  exit 1
}
Write-Host "  Servindo $Root em http://localhost:$Port" -ForegroundColor Green

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $res = $ctx.Response
    $urlPath = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
    $file = [IO.Path]::GetFullPath((Join-Path $Root $urlPath.TrimStart('/')))

    if (-not $file.StartsWith($Root)) { $res.StatusCode = 403; $res.Close(); continue }

    if (Test-Path $file -PathType Container) {
      # /admin -> /admin/ para os caminhos relativos (app.js, styles.css) funcionarem
      if (-not $urlPath.EndsWith('/')) { $res.Redirect("$urlPath/"); $res.Close(); continue }
      $file = Join-Path $file 'index.html'
    }

    if (-not (Test-Path $file -PathType Leaf)) {
      $res.StatusCode = 404
      $msg = [Text.Encoding]::UTF8.GetBytes('404 - nao encontrado')
      $res.OutputStream.Write($msg, 0, $msg.Length); $res.Close()
      Write-Host "  404 $urlPath" -ForegroundColor Yellow
      continue
    }

    $bytes = [IO.File]::ReadAllBytes($file)
    $ext = [IO.Path]::GetExtension($file).ToLower()
    $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
    $res.Headers.Add('Cache-Control', 'no-cache')
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    $res.Close()
    Write-Host "  $($ctx.Request.HttpMethod) $urlPath"
  }
} finally {
  $listener.Stop()
}
