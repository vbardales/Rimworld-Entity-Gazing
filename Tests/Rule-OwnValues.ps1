param([Parameter(Mandatory)][string]$ModRoot, [string]$SharedDir)

# Own values and facts of Entity Gazing: the recreation kind, job and giver (Anomaly-gated by MayRequire), the hidden settings
# shortcut, the viewing-distance settings contract (Source/EntityGazingMod.cs), the patch of the vanilla holders and the gated
# optional patch of the holders of other mods (OptionalCompat.xml), the six holder defNames applied by the settings code, the
# About identity and the single shipped DLL. One consumer, nothing shareable; Tests/Test-Mod.ps1 (generated) runs it after the
# shared checks. Prints findings, exit 1 on any.
# The generic checks live in the shared scripts: Check-ModBasics (XML, defNames, About shape), Check-PatchTargets and
# Check-PatchGuards (patch targets and gating), Check-DefRefs, Check-Translations, Check-ConfigErrors.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ModRoot).Path
$mod = Join-Path $root 'Mod'
$script:findings = @()

# One rule: the block returns its problems; each is printed under the rule name.
function It([string]$name, [scriptblock]$body) {
    try { $problems = @(& $body | Where-Object { $_ }) } catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    foreach ($p in $problems) { $script:findings += "[$name] $p" }
}
function Read-Text([string]$p) { Get-Content -LiteralPath $p -Raw -Encoding UTF8 }

$vanillaHolders = 'HoldingPlatform', 'HoldingSpot'
$compatHolders = 'SmallHoldingPlatform', 'SmallHoldingSpot', 'HM_Mini_HoldingPlatform', 'HM_Mini_HoldingSpot'
$platforms = 'HoldingPlatform', 'SmallHoldingPlatform', 'HM_Mini_HoldingPlatform'

It 'Recreation kind, job and giver exist, gated on Anomaly, and agree' {
    [xml]$doc = Read-Text (Join-Path $mod 'Defs/EntityGazing.xml')
    foreach ($type in 'JoyKindDef', 'JobDef', 'JoyGiverDef') {
        $nodes = @($doc.SelectNodes("/Defs/$type"))
        if ($nodes.Count -ne 1) { "Expected one $type, got $($nodes.Count)"; continue }
        if ($nodes[0].GetAttribute('MayRequire') -cne 'Ludeon.RimWorld.Anomaly') { "$type must carry MayRequire=Ludeon.RimWorld.Anomaly" }
    }
    $kind = $doc.SelectSingleNode('/Defs/JoyKindDef/defName').InnerText
    if ($kind -cne 'EG_EntityGazing') { "Wrong joy kind defName: $kind" }
    $job = $doc.SelectSingleNode('/Defs/JobDef')
    if ($job.defName -cne 'EG_WatchEntity') { 'Wrong job defName' }
    if ($job.driverClass -cne 'JobDriver_WatchBuilding') { 'The job must use the vanilla JobDriver_WatchBuilding' }
    if ($job.joyKind -cne 'EG_EntityGazing') { 'The job joyKind must be EG_EntityGazing' }
    $giver = $doc.SelectSingleNode('/Defs/JoyGiverDef')
    if ($giver.defName -cne 'EG_WatchEntity') { 'Wrong giver defName' }
    if ($giver.giverClass -cne 'EntityGazing.JoyGiver_WatchEntity') { 'Giver class disconnected' }
    if ($giver.jobDef -cne 'EG_WatchEntity') { 'The giver must give the EG_WatchEntity job' }
    if ($giver.joyKind -cne 'EG_EntityGazing') { 'The giver joyKind must be EG_EntityGazing' }
    if ($giver.desireSit -cne 'false') { 'The giver must set desireSit false' }
    if (@($giver.requiredCapacities.li) -notcontains 'Sight') { 'The giver must require Sight' }
    $things = @($giver.thingDefs.li)
    if (($things -join ',') -cne ($vanillaHolders -join ',')) { "The giver base thingDefs must be exactly the two vanilla holders, got: $($things -join ', ')" }
}

It 'Settings shortcut is hidden by default and points to the worker' {
    [xml]$doc = Read-Text (Join-Path $mod 'Defs/SettingsButton.xml')
    $button = $doc.SelectSingleNode('/Defs/MainButtonDef')
    if ($button.defName -cne 'EG_Settings') { 'Wrong shortcut defName' }
    if ($button.workerClass -cne 'EntityGazing.MainButtonWorker_EntityGazingSettings') { 'Settings shortcut worker disconnected' }
    if ($button.buttonVisible -cne 'false') { 'Settings shortcut must be hidden by default (buttonVisible false)' }
}

It 'Patch of the vanilla holders: values and node placement' {
    [xml]$doc = Read-Text (Join-Path $mod 'Patches/HoldingPlatforms.xml')
    $text = $doc.OuterXml
    foreach ($name in $vanillaHolders) {
        if (-not $text.Contains("defName=""$name""")) { "HoldingPlatforms.xml does not patch $name" }
    }
    if ([regex]::Matches($text, '<watchBuildingStandDistanceRange>2~6</watchBuildingStandDistanceRange>').Count -ne 2) { 'Both vanilla holders must get the default distance range 2~6' }
    if ([regex]::Matches($text, '<JoyGainFactor>1</JoyGainFactor>').Count -ne 1) { 'The platform must get JoyGainFactor 1' }
    if ([regex]::Matches($text, '<JoyGainFactor>0.8</JoyGainFactor>').Count -ne 1) { 'The spot must get JoyGainFactor 0.8' }
}

It 'Optional compat patch: four holders, each gated on the def, each added to the giver, same values as vanilla' {
    $path = Join-Path $mod 'Patches/OptionalCompat.xml'
    [xml]$doc = Read-Text $path
    $ops = @($doc.SelectNodes('/Patch/Operation'))
    if ($ops.Count -ne $compatHolders.Count) { "Expected $($compatHolders.Count) gated operations, got $($ops.Count)" }
    $seen = @()
    foreach ($op in $ops) {
        if ($op.GetAttribute('Class') -cne 'PatchOperationConditional') { 'Every compat operation must be a PatchOperationConditional'; continue }
        if ($op.xpath -notmatch '^Defs/ThingDef\[defName="([^"]+)"\]$') { "Unexpected gate xpath: $($op.xpath)"; continue }
        $def = $Matches[1]
        $seen += $def
        if ($compatHolders -notcontains $def) { "Unexpected compat holder $def" }
        $inner = @($op.match.operations.li)
        $adds = @($inner | Where-Object { $_.xpath -eq 'Defs/JoyGiverDef[defName="EG_WatchEntity"]/thingDefs' })
        if ($adds.Count -ne 1 -or $adds[0].value.li -cne $def) { "$def must be added once to the thingDefs of EG_WatchEntity, in its own gated sequence" }
        $xml = $op.OuterXml
        $factor = if ($platforms -contains $def) { '1' } else { '0.8' }
        if (-not $xml.Contains("<JoyGainFactor>$factor</JoyGainFactor>")) { "$def must get JoyGainFactor $factor" }
        if (-not $xml.Contains('<watchBuildingStandDistanceRange>2~6</watchBuildingStandDistanceRange>')) { "$def must get the default distance range 2~6" }
        if (-not $xml.Contains('<watchBuildingInSameRoom>true</watchBuildingInSameRoom>')) { "$def must get watchBuildingInSameRoom true" }
        if (-not $xml.Contains('<li>PlaceWorker_WatchArea</li>')) { "$def must get PlaceWorker_WatchArea" }
        # building: absent only on SmallHoldingPlatform (created at the root); inside the existing node on the three others.
        $rootOp = ($op.match.operations.li | Where-Object { $_.xpath -eq "Defs/ThingDef[defName=""$def""]" })
        $inside = ($op.match.operations.li | Where-Object { $_.xpath -eq "Defs/ThingDef[defName=""$def""]/building" })
        if ($def -ceq 'SmallHoldingPlatform') {
            if ($null -ne $inside) { 'SmallHoldingPlatform has no <building> of its own: it must be created at the root, not added inside' }
            if (-not $rootOp.OuterXml.Contains('<building>')) { 'SmallHoldingPlatform must get its <building> at the root' }
        } else {
            if ($null -eq $inside) { "$def has a <building>: the joyKind and distance must be added inside it" }
            if ($rootOp.OuterXml.Contains('<building>')) { "$def must not get a second <building> at the root" }
        }
    }
    foreach ($def in $compatHolders) { if ($seen -notcontains $def) { "Compat holder $def has no gated operation" } }
}

It 'The settings code applies the distance to exactly the six holder defNames' {
    $code = Read-Text (Join-Path $root 'Source/EntityGazingMod.cs')
    if ($code -notmatch 'HolderDefNames\s*=\s*\{(?<body>[^}]*)\}') { 'HolderDefNames array not found in Source/EntityGazingMod.cs'; return }
    $names = @([regex]::Matches($Matches['body'], '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
    $expected = @($vanillaHolders + $compatHolders)
    foreach ($n in $expected) { if ($names -notcontains $n) { "HolderDefNames lacks $n" } }
    foreach ($n in $names) { if ($expected -notcontains $n) { "HolderDefNames holds an unpatched defName: $n" } }
    foreach ($needle in 'minimumDistance = 2', 'maximumDistance = 6', 'Math.Min(20', 'Math.Max(1,', 'GetNamedSilentFail') {
        if (-not $code.Contains($needle)) { "Settings contract: '$needle' missing from Source/EntityGazingMod.cs" }
    }
}

It 'About identity and dependency' {
    [xml]$about = Read-Text (Join-Path $mod 'About/About.xml')
    $meta = $about.ModMetaData
    if ($meta.name -cne 'Entity Gazing') { 'Wrong title' }
    if ($meta.packageId -cne 'nelim.entitygazing') { 'Wrong packageId' }
    if (@($meta.supportedVersions.li) -notcontains '1.6') { 'RimWorld 1.6 support missing' }
    if (@($meta.modDependencies.li.packageId) -notcontains 'Ludeon.RimWorld.Anomaly') { 'Missing dependency Ludeon.RimWorld.Anomaly' }
}

It 'Single shipped DLL' {
    $dlls = @(Get-ChildItem -LiteralPath (Join-Path $mod 'Assemblies') -Filter *.dll -File)
    if ($dlls.Count -ne 1 -or $dlls[0].Name -cne 'EntityGazing.dll') { "Expected only Mod/Assemblies/EntityGazing.dll, got: $($dlls.Name -join ', ')" }
}

if ($script:findings.Count -gt 0) {
    $script:findings | ForEach-Object { Write-Host "FAIL: $_" }
    exit 1
}
Write-Host 'PASS: Entity Gazing own values and facts'
exit 0
