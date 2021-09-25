if ((Test-Path env:SYSTEM_DEFAULTWORKINGDIRECTORY) -and $env:SYSTEM_DEFAULTWORKINGDIRECTORY) {
  Write-Host "##vso[task.setvariable variable=COMPlus_DbgEnableMiniDump]1"
  Write-Host "##vso[task.setvariable variable=COMPlus_DbgMiniDumpName]$env:SYSTEM_DEFAULTWORKINGDIRECTORY/dotnet-%d.%t.core"
} else {
  $env:COMPlus_DbgEnableMiniDump = 1
  $env:COMPlus_DbgMiniDumpName = "$PWD/dotnet-%d.%t.core"
}
