param(
  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]
  $ProcDumpOutputPath
)

Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path "$PSScriptRoot\..\.."
$procDumpOutputPath = Join-Path $repoRoot $ProcDumpOutputPath

if (Test-Path env:SYSTEM_PHASENAME) { $jobName = "$env:SYSTEM_PHASENAME" } else { $jobName = "$env:AGENT_OS" }
$artifactName = "${jobName}_Dumps"

[string[]]$files = Get-ChildItem "$env:SYSTEM_DEFAULTWORKINGDIRECTORY\dotnet-*.core"
if (Test-Path "$procDumpOutputPath") {
  $files += Get-ChildItem "$procDumpOutputPath\*.dmp"
}

foreach ($file in $files) {
  Write-Host "##vso[artifact.upload containerfolder=$artifactName;artifactname=$artifactName]$file"
}

if ($null -eq $files -or 0 -eq $files.Count) {
  Write-Warning "No core files found."
}
