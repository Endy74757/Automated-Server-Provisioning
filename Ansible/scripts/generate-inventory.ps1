param(
  [string]$TerraformDir = "..\..\Terraform",
  [string]$OutputFile = "..\inventory\hosts.ini"
)

Push-Location $PSScriptRoot
try {
  $tf = Resolve-Path $TerraformDir
  Push-Location $tf

  $json = terraform output -json vm_ips | ConvertFrom-Json
  if (-not $json) { throw "No Terraform output 'vm_ips'. Run 'terraform apply' first." }

  # Collect entries per group to avoid brittle index math
  $groups = @{
    web_nodes = @()
    docker_nodes = @()
    k8s_nodes = @()
    ungrouped = @()
  }

  $json.PSObject.Properties | ForEach-Object {
    $name = $_.Name
    $ip = $_.Value
    $entry = "$name ansible_host=$ip"
    if ($name -match "web") { $groups.web_nodes += $entry }
    elseif ($name -match "docker") { $groups.docker_nodes += $entry }
    elseif ($name -match "k8s") { $groups.k8s_nodes += $entry }
    else { $groups.ungrouped += $entry }
  }

  $lines = @(
    "# Generated from Terraform vm_ips on $(Get-Date -Format o)",
    "[all:vars]",
    "ansible_user=vagrant",
    "ansible_ssh_private_key_file=~/.ssh/vagrant_insecure",
    "",
    "[web_nodes]"
  )
  $lines += $groups.web_nodes
  $lines += @("", "[docker_nodes]")
  $lines += $groups.docker_nodes
  $lines += @("", "[k8s_nodes]")
  $lines += $groups.k8s_nodes
  if ($groups.ungrouped.Count -gt 0) {
    $lines += ""
    $lines += $groups.ungrouped
  }

  $outPath = Join-Path $PSScriptRoot $OutputFile
  $outDir = Split-Path $outPath -Parent
  if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }
  # Write without BOM to avoid stray host entry (\xEF\xBB\xBF)
  $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
  [System.IO.File]::WriteAllLines($outPath, $lines, $utf8NoBom)
  Write-Host "Inventory written to $outPath"
}
finally {
  Pop-Location
  Pop-Location
}

