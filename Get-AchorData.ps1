Param(
  [string]$Url  = "https://raw.githubusercontent.com/PaulJerimy/SecCertRoadmapHTML/refs/heads/main/Security-Certification-Roadmap9.html"
)
$Html = Invoke-WebRequest -Uri $Url -UseBasicParsing

# Load into HTML parser
$Doc = New-Object -ComObject "HTMLFile"
$Doc.IHTMLDocument2_write($Html.Content)
$Doc.Close()

# Extract anchors
$Anchors = @()
foreach ($a in $Doc.getElementsByTagName("a")) {
    $obj = [PSCustomObject]@{
        domain      = ([uri]($a.href)).DnsSafeHost
        href        = $a.href
        class       = $a.className
        tooltiptext = $a.getAttribute("tooltiptext")
        textContent = $a.innerText
    }
    $Anchors += $obj
}

# Export to JSON
$Anchors | ConvertTo-Json -Depth 2 | Out-File "anchors.json" -Encoding utf8
