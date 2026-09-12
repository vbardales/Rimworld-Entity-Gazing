<#
.SYNOPSIS
  Breaks the mod on purpose, one fault at a time, and checks that the right test goes red.

.DESCRIPTION
  A suite that has never failed proves nothing: a test can be green because the mod is correct, or
  green because it never looks at anything. This tells the two apart. Each mutation is applied to a
  COPY of the mod - never to the real files - and the suite is run against that copy; the mutation
  passes if the test it is aimed at turns red.

  Three things learned writing it, all of them traps rather than preferences:

    - the suite runs in a CHILD process. Write-Host bypasses the pipeline in-process, so the parent
      would capture nothing and read every mutation as a miss; and Assembly.LoadFrom keeps the
      copied DLL locked, so the next mutation could not delete its folder.
    - a mutation has to COMPILE. Rebasing the giver on JoyGiver_InteractBuilding looked like the
      obvious way to break "derives from the vanilla one", but that class is abstract: the build
      failed, the old assembly stayed in place, and the mutation reported a miss that was its own
      fault. JoyGiver_InteractBuildingSitAdjacent is the concrete cousin that does compile.
    - -creplace everywhere. PowerShell's -replace is case-insensitive, and on XML that means a
      mutation aimed at one element quietly eats a differently-cased sibling.

  Collateral damage is expected and is not a fault: deleting a translation file also trips the
  harness guard, which is the guard doing its job.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Mutations.ps1

.EXAMPLE
  One mutation by name, which is how you work on a single test:

  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Mutations.ps1 -Only 'invented stat'
#>
param(
    # Short, and outside the session scratchpad: a NuGet restore under a deep temp path runs into
    # MAX_PATH and then cannot be cleaned up between mutations.
    [string]$Work = 'C:\Temp\egmut',
    [string[]]$Only = @()
)

$ErrorActionPreference = 'Stop'
$Src = Split-Path -Parent $PSScriptRoot

# n = what is broken; suite = form|func; expect = the test numbers that must turn red
$mutations = @(
  @{ n='malformed xml';            suite='form'; expect='2';  do={ Add-Content "$Work\Mod\Defs\EntityGazing.xml" -Value "<oops>" -Encoding UTF8 } }
  @{ n='bogus def element';        suite='form'; expect='3';  do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<desireSit>false</desireSit>','<desireSitz>false</desireSitz>' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='bogus patch field';        suite='form'; expect='4';  do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace '<socialPropernessMatters>','<socialProperlyMatters>' -creplace '</socialPropernessMatters>','</socialProperlyMatters>' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='bogus operation Class';    suite='form'; expect='5';  do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace 'Class="PatchOperationSequence"','Class="PatchOperationSequenz"' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='invented stat';            suite='form'; expect='6';  do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace 'JoyGainFactor>','JoyGainFactorz>' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='holder typo in thingDefs'; suite='form'; expect='7';  do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<li>HoldingSpot</li>','<li>HoldingSpotz</li>' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='MayRequire dropped';       suite='form'; expect='8';  do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<JoyKindDef MayRequire="Ludeon.RimWorld.Anomaly">','<JoyKindDef>' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='DefInjected folder case';  suite='form'; expect='9';  do={ Rename-Item "$Work\Mod\Languages\French\DefInjected\JobDef" 'tmpx'; Rename-Item "$Work\Mod\Languages\French\DefInjected\tmpx" 'Jobdef' } }
  @{ n='French handle typo';       suite='form'; expect='10'; do={ (Get-Content "$Work\Mod\Languages\French\DefInjected\JobDef\EntityGazing.xml" -Raw -Encoding UTF8) -creplace 'reportString','reportStrings' | Set-Content "$Work\Mod\Languages\French\DefInjected\JobDef\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='French label removed';     suite='form'; expect='11'; do={ Remove-Item "$Work\Mod\Languages\French\DefInjected\JoyKindDef\EntityGazing.xml" } }
  @{ n='stale assembly';           suite='form'; expect='12'; do={ (Get-Item "$Work\Source\JoyGiver_WatchEntity.cs").LastWriteTime = (Get-Date).AddDays(1) } }
  @{ n='wrong packageId';          suite='form'; expect='13'; do={ (Get-Content "$Work\Mod\About\About.xml" -Raw -Encoding UTF8) -creplace 'nelim.entitygazing','vbardales.entitygazing' | Set-Content "$Work\Mod\About\About.xml" -Encoding UTF8 } }
  @{ n='Renew suffix on the name'; suite='form'; expect='14'; do={ (Get-Content "$Work\Mod\About\About.xml" -Raw -Encoding UTF8) -creplace '<name>Entity Gazing</name>','<name>Entity Gazing Renew</name>' | Set-Content "$Work\Mod\About\About.xml" -Encoding UTF8 } }
  @{ n='script left inside Mod/';  suite='form'; expect='15'; do={ Set-Content "$Work\Mod\oops.ps1" -Value '# left behind' -Encoding UTF8 } }
  @{ n='preview wrong size';       suite='form'; expect='16'; do={ Copy-Item "$Work\Mod\About\ModIcon.png" "$Work\Mod\About\Preview.png" -Force } }
  @{ n='full-res source deleted';  suite='form'; expect='17'; do={ Remove-Item "$Work\Art\Preview-source.png" } }
  @{ n='licence changed';          suite='form'; expect='18'; do={ Set-Content "$Work\LICENSE" -Value 'All rights reserved.' -Encoding UTF8 } }
  @{ n='French crept into README'; suite='form'; expect='19'; do={ Add-Content "$Work\README.md" -Value 'Ce mod est une creation originale.' -Encoding UTF8 } }
  @{ n='factor changed, prose not';suite='form'; expect='20'; do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace '<JoyGainFactor>0.8<','<JoyGainFactor>0.9<' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='scenario added silently';  suite='form'; expect='21'; do={ Add-Content "$Work\TESTING.md" -Value "`n## 15. Something new`n" -Encoding UTF8 } }
  @{ n='test count drifted';      suite='form'; expect='22'; do={ (Get-Content "$Work\README.md" -Raw -Encoding UTF8) -creplace '23 form tests','24 form tests' | Set-Content "$Work\README.md" -Encoding UTF8 } }
  @{ n='docs name a ghost file';   suite='form'; expect='23'; do={ (Get-Content "$Work\README.md" -Raw -Encoding UTF8) -creplace 'TESTING.md','Platforms.xml' | Set-Content "$Work\README.md" -Encoding UTF8 } }

  @{ n='derives from the wrong base'; suite='func'; expect='2'; do={ (Get-Content "$Work\Source\JoyGiver_WatchEntity.cs" -Raw -Encoding UTF8) -creplace ': JoyGiver_WatchBuilding',': JoyGiver_InteractBuildingSitAdjacent' | Set-Content "$Work\Source\JoyGiver_WatchEntity.cs" -Encoding UTF8; & dotnet build "$Work\Source\EntityGazing.csproj" -c Release -v q --nologo | Out-Null } }
  @{ n='new instead of override';  suite='func'; expect='3';  do={ (Get-Content "$Work\Source\JoyGiver_WatchEntity.cs" -Raw -Encoding UTF8) -creplace 'protected override bool CanInteractWith','protected new bool CanInteractWith' -creplace 'if \(!base.CanInteractWith\(pawn, t, inBed\)\)','if (!true)' | Set-Content "$Work\Source\JoyGiver_WatchEntity.cs" -Encoding UTF8; & dotnet build "$Work\Source\EntityGazing.csproj" -c Release -v q --nologo | Out-Null } }
  @{ n='driverClass wrong family'; suite='func'; expect='8';  do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<driverClass>JobDriver_WatchBuilding</driverClass>','<driverClass>JoyGiver_WatchBuilding</driverClass>' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='job joyKind mismatched';   suite='func'; expect='9';  do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<joyKind>EG_EntityGazing</joyKind>\s*<allowOpportunisticPrefix>',"<joyKind>Television</joyKind>`n    <allowOpportunisticPrefix>" | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='xpath that matches nothing';suite='func';expect='21'; do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace ([regex]::Escape('"HoldingPlatform"]/statBases')), '"HoldingPlatform"]/statBasez' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='patch reversed on the spot';suite='func';expect='24'; do={
      $p = "$Work\Mod\Patches\HoldingPlatforms.xml"
      $t = Get-Content $p -Raw -Encoding UTF8
      $t = $t -creplace '(?s)(<xpath>Defs/ThingDef\[defName="HoldingSpot"\]/building</xpath>\s*<value>)(.*?)(</value>)', '<xpath>Defs/ThingDef[defName="HoldingSpot"]</xpath><value><building>$2</building>$3'
      Set-Content $p -Value $t -Encoding UTF8 } }
  @{ n='place worker typo';        suite='func'; expect='27'; do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace 'PlaceWorker_WatchArea','PlaceWorker_WatchAreaz' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='watchers out of the field';suite='func'; expect='30'; do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace '2~6','7~9' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
  @{ n='spot dropped from giver';  suite='func'; expect='31'; do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '\s*<li>HoldingSpot</li>','' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='joyDuration out of range'; suite='func'; expect='32'; do={ (Get-Content "$Work\Mod\Defs\EntityGazing.xml" -Raw -Encoding UTF8) -creplace '<joyDuration>4000</joyDuration>','<joyDuration>40000</joyDuration>' | Set-Content "$Work\Mod\Defs\EntityGazing.xml" -Encoding UTF8 } }
  @{ n='same-room dropped';        suite='func'; expect='33'; do={ (Get-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Raw -Encoding UTF8) -creplace '<watchBuildingInSameRoom>true</watchBuildingInSameRoom>','' | Set-Content "$Work\Mod\Patches\HoldingPlatforms.xml" -Encoding UTF8 } }
)

$missed = 0
foreach ($m in $mutations) {
    if ($Only.Count -and ($Only -notcontains $m.n)) { continue }

    if (Test-Path $Work) { Remove-Item $Work -Recurse -Force -ErrorAction SilentlyContinue }
    Copy-Item $Src $Work -Recurse -Force
    Remove-Item "$Work\.git", "$Work\.build" -Recurse -Force -ErrorAction SilentlyContinue
    & $m.do

    $script = if ($m.suite -eq 'form') { "$Work\_tools\Run-Tests.ps1" } else { "$Work\_tools\Run-Functional-Tests.ps1" }
    $ErrorActionPreference = 'Continue'   # a child writing to stderr is not this script's failure
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File $script 2>&1 | Out-String
    $ErrorActionPreference = 'Stop'

    $red   = [regex]::Matches($out, '(?m)^\s*(\d+)\. FAIL') | ForEach-Object { $_.Groups[1].Value }
    $want  = $m.expect -split ','
    $hit   = @($want | Where-Object { $red -contains $_ }).Count -eq $want.Count
    $extra = @($red | Where-Object { $want -notcontains $_ })
    if (-not $hit) { $missed++ }
    $verdict = if (-not $hit) { 'MISSED' } elseif ($extra.Count) { 'ok (+collateral)' } else { 'ok' }
    $colour  = if (-not $hit) { 'Red' } else { 'DarkGreen' }
    Write-Host ("{0,-30} {1,-5} want {2,-4} red: {3,-16} {4}" -f $m.n, $m.suite, $m.expect, ($red -join ','), $verdict) -ForegroundColor $colour
}

if (Test-Path $Work) { Remove-Item $Work -Recurse -Force -ErrorAction SilentlyContinue }
Write-Host ""
if ($missed) { Write-Host "  $missed mutation(s) went unnoticed" -ForegroundColor Red; exit 1 }
Write-Host "  every mutation woke its test" -ForegroundColor Green
