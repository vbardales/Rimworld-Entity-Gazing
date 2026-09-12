<#
.SYNOPSIS
  Asks the installed game whether it still does what this mod hands it to do. No RimWorld launched.

.DESCRIPTION
  Run-Tests.ps1 beside this one checks the shape of the mod: well-formed XML, fields that still
  exist, translation keys that match. None of that says the mod works, because this mod owns
  almost none of its own behaviour. One class of one method is the whole assembly; the walking,
  the facing and the joy gain belong to the base game's television logic, and the two holding
  platforms become recreation sources through a patch. Every one of those hand-offs fails
  SILENTLY when the game moves underneath it - no error, no log line, a mod that loads cleanly
  and does nothing.

  So the questions here are different:

    - is the mod's one override still an override, or has it become a method nobody calls?
    - does the game still read every setting the defs write, or is one of them inert?
    - does the patch still land on the defs it aims at, and leave them in one piece?

  All of it by reflection and IL against the installed game's own Assembly-CSharp, plus the real
  Anomaly def files. Nothing is asserted from memory; the numbers in the README are recomputed.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
#>
param(
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data'
)

$ErrorActionPreference = 'Stop'
$ModRoot = Split-Path -Parent $PSScriptRoot
$Mod     = Join-Path $ModRoot 'Mod'

# ---------------------------------------------------------------------------------------------
# Harness
# ---------------------------------------------------------------------------------------------

$script:pass = 0; $script:fail = 0; $script:n = 0
function Test-That([string]$name, [scriptblock]$body) {
    $script:n++
    try {
        $r = & $body
        if (($r -is [string]) -and ($r -eq 'skip')) {
            Write-Host ("  {0,2}. SKIP  {1}" -f $script:n, $name) -ForegroundColor DarkGray
            return
        }
        if ($r) { $script:pass++; Write-Host ("  {0,2}. ok    {1}" -f $script:n, $name) -ForegroundColor DarkGreen }
        else    { $script:fail++; Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red }
    } catch {
        $script:fail++
        Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red
        Write-Host ("        {0}" -f $_.Exception.Message) -ForegroundColor DarkRed
    }
}
function Note([string]$text) { Write-Host ("        " + $text) -ForegroundColor DarkGray }

# Always with -Encoding UTF8: Windows PowerShell 5.1 reads a BOM-less file through the system code
# page, and a test looking for a word finds mojibake instead.
function Read-Text([string]$p) { Get-Content $p -Raw -Encoding UTF8 }

# ---------------------------------------------------------------------------------------------
# The game, by reflection
# ---------------------------------------------------------------------------------------------

# Assembly-CSharp names Unity assemblies that are not next to this script. Remember what has been
# tried: an unresolvable name asked for twice recurses to a stack overflow rather than an error.
# The null guard matters because the handler lives on the process AppDomain, which outlives this
# script's scope.
$script:probeDirs = @($Managed, (Join-Path $Mod 'Assemblies'))
$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $script:probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

# GetTypes() always throws here - Unity is missing - but the exception carries every type it did
# resolve, which is all of them but a handful. PowerShell wraps it, so both shapes are caught.
function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$gameTypes = Get-AssemblyTypes (Join-Path $Managed 'Assembly-CSharp.dll')
$modDll    = Join-Path $Mod 'Assemblies\EntityGazing.dll'
$modTypes  = @(Get-AssemblyTypes $modDll)

$TypeIndex = @{}
foreach ($t in $gameTypes) {
    if ($t.Name -and -not $TypeIndex.ContainsKey($t.Name)) { $TypeIndex[$t.Name] = $t }
    if ($t.FullName -and -not $TypeIndex.ContainsKey($t.FullName)) { $TypeIndex[$t.FullName] = $t }
}
$BF = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'

$defsXml  = New-Object System.Xml.XmlDocument; $defsXml.Load((Join-Path $Mod 'Defs\EntityGazing.xml'))
$patchXml = New-Object System.Xml.XmlDocument; $patchXml.Load((Join-Path $Mod 'Patches\HoldingPlatforms.xml'))
$anomaly  = Join-Path $GameData 'Anomaly\Defs\ThingDefs_Buildings\Buildings_Misc.xml'

Write-Host ""
Write-Host "Entity Gazing - functional tests" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------------------------
# 0. The harness itself
# ---------------------------------------------------------------------------------------------
Write-Host " Harness" -ForegroundColor Cyan

# A test written in the negative - "no def does X", "this field is gone" - passes for free when
# its inputs are empty. Everything below reads from these four, so they are counted first.
Test-That "the game, the mod assembly and both XML files loaded" {
    Note ("game types {0}, mod types {1}, defs {2}, patch operations {3}" -f `
        $gameTypes.Count, $modTypes.Count, $defsXml.SelectNodes('/Defs/*').Count, $patchXml.SelectNodes('/Patch/Operation').Count)
    ($gameTypes.Count -gt 10000) -and ($modTypes.Count -ge 1) -and
    ($defsXml.SelectNodes('/Defs/*').Count -eq 3) -and ($patchXml.SelectNodes('/Patch/Operation').Count -eq 2) -and
    (Test-Path $anomaly)
}

# ---------------------------------------------------------------------------------------------
# 1. The mod's own code
# ---------------------------------------------------------------------------------------------
Write-Host " The one class" -ForegroundColor Cyan

$giverType = $modTypes | Where-Object { $_.Name -eq 'JoyGiver_WatchEntity' } | Select-Object -First 1

Test-That "the giver derives from the vanilla one the defs rely on" {
    $giverType -and $giverType.BaseType.FullName -eq 'RimWorld.JoyGiver_WatchBuilding'
}

# The trap this guards is invisible: C# lets you widen accessibility on an override, and it lets
# you write `new` where you meant `override`. Both compile, both load, and the second is never
# called - colonists would gaze at EMPTY platforms with no error anywhere. Accessibility is not
# what decides it; the vtable slot is.
Test-That "CanInteractWith really overrides, and does not take a new slot" {
    $m = $giverType.GetMethods($BF) | Where-Object { $_.Name -eq 'CanInteractWith' -and $_.DeclaringType -eq $giverType }
    if (-not $m) { Note "the mod declares no CanInteractWith at all"; return $false }
    $newSlot = ($m.Attributes -band [System.Reflection.MethodAttributes]::NewSlot) -ne 0
    $base    = $m.GetBaseDefinition()
    Note ("base definition {0}.{1}, newslot {2}" -f $base.DeclaringType.FullName, $base.Name, $newSlot)
    $m.IsVirtual -and (-not $newSlot) -and $base.DeclaringType.Assembly -ne $giverType.Assembly
}

Test-That "its signature still matches the game's" {
    $ours   = ($giverType.GetMethods($BF) | Where-Object { $_.Name -eq 'CanInteractWith' -and $_.DeclaringType -eq $giverType })[0]
    $theirs = ($TypeIndex['JoyGiver_WatchBuilding'].GetMethods($BF) | Where-Object { $_.Name -eq 'CanInteractWith' })[0]
    $a = ($ours.GetParameters()   | ForEach-Object { $_.ParameterType.FullName }) -join ','
    $b = ($theirs.GetParameters() | ForEach-Object { $_.ParameterType.FullName }) -join ','
    Note "($b)"
    $a -ceq $b
}

# The condition the class exists for. No reflection trick: the members it reaches for have to be
# there, and HeldPawn has to be a Pawn for `.Dead` to mean anything.
Test-That "the occupancy check still has something to read" {
    $comp = $TypeIndex['CompEntityHolderPlatform']
    if (-not $comp) { Note 'CompEntityHolderPlatform is gone from the game'; return $false }
    $held = $comp.GetProperty('HeldPawn', $BF)
    $dead = $TypeIndex['Pawn'].GetProperty('Dead', $BF)
    Note ("{0}.HeldPawn -> {1}, Pawn.Dead -> {2}" -f $comp.FullName, $held.PropertyType.Name, $dead.PropertyType.Name)
    $held -and $dead -and $held.PropertyType.Name -eq 'Pawn'
}

# The class lives in Assembly-CSharp like all DLC code, which is why the mod needs no reflection
# and loads with Anomaly off. If it ever moved into a DLC assembly of its own, this breaks.
Test-That "that comp is in Assembly-CSharp, so the assembly loads without the DLC" {
    $TypeIndex['CompEntityHolderPlatform'].Assembly.GetName().Name -eq 'Assembly-CSharp'
}

# A trap that killed half of two other mods in this repository, found on Fieldwork Companions and
# Contented Livestock. Krafs.Publicizer grants access to the game's non-public members with an
# [assembly: IgnoresAccessChecksTo] that the SDK writes into the generated AssemblyInfo - and
# <GenerateAssemblyInfo>false</GenerateAssemblyInfo>, which this csproj carries, deletes that file.
# The attribute TYPE stays embedded, the grant is never applied, the build is clean, and the CLR
# throws FieldAccessException or MethodAccessException at the first real access, behind a startup
# that says nothing.
#
# This mod is not exposed, and the proof is a compile rather than an argument: its source builds
# against the game's REAL Assembly-CSharp, where protected stays protected. A member it could not
# legally touch would be a compile error here, not a silent failure in play. That is the same test
# as "drop the publicizer and rebuild", gone one step further - there is no publicizer to drop.
Test-That "the source compiles against the un-publicized game assembly" {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { Note 'dotnet not on PATH'; return 'skip' }
    $probe = Join-Path ([System.IO.Path]::GetTempPath()) ('eg-access-' + [guid]::NewGuid().ToString('N').Substring(0,8))
    New-Item -ItemType Directory $probe | Out-Null
    try {
        Copy-Item (Join-Path $ModRoot 'Source\*.cs') $probe
        @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Library</OutputType><TargetFramework>net48</TargetFramework>
    <AssemblyName>EgAccessProbe</AssemblyName>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Assembly-CSharp"><HintPath>$Managed\Assembly-CSharp.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine.CoreModule"><HintPath>$Managed\UnityEngine.CoreModule.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine"><HintPath>$Managed\UnityEngine.dll</HintPath><Private>false</Private></Reference>
  </ItemGroup>
</Project>
"@ | Set-Content (Join-Path $probe 'Probe.csproj') -Encoding UTF8
        $out = & dotnet build (Join-Path $probe 'Probe.csproj') -c Release -v q --nologo 2>&1 | Out-String
        $errors = @([regex]::Matches($out, '(?m)error CS\d+.*$') | ForEach-Object { $_.Value })
        if ($errors) { Note ($errors | Select-Object -First 3) }
        # CS0122 is the one that matters - "inaccessible due to its protection level".
        $errors.Count -eq 0
    } finally { Remove-Item $probe -Recurse -Force -ErrorAction SilentlyContinue }
}

# Belt and braces on the same fault, and the check that does NOT lie: read the attribute through
# reflection. Grepping the DLL for the string finds the type name whether the grant was applied or
# not, which is exactly the shape of the trap.
Test-That "no access grant is claimed that the build could not have applied" {
    $data = [System.Reflection.Assembly]::LoadFrom($modDll).GetCustomAttributesData()
    $grant = @($data | Where-Object { $_.AttributeType.Name -eq 'IgnoresAccessChecksToAttribute' })
    $publicized = (Read-Text (Join-Path $ModRoot 'Source\EntityGazing.csproj')) -match '<Publicize\b'
    Note ("publicizer declared: {0}; access grant present: {1}" -f $publicized, ($grant.Count -gt 0))
    # Either both or neither. A publicizer with no grant is the silent failure; a grant with no
    # publicizer is harmless but means the csproj changed under the test.
    $publicized -eq ($grant.Count -gt 0)
}

# ---------------------------------------------------------------------------------------------
# 2. What the mod hands to the base game
# ---------------------------------------------------------------------------------------------
Write-Host " The hand-off to vanilla" -ForegroundColor Cyan

# JobDriver_SitFacingBuilding blows up on a Plant - that is why an anima tree cannot be wired up
# this way. A holding platform is a Building, which is what lets this mod ship one method.
Test-That "both holders are Buildings, which is what the driver needs" {
    $b = $TypeIndex['Building_HoldingPlatform']
    Note ("Building_HoldingPlatform : " + (@($b.BaseType.Name, $b.BaseType.BaseType.Name) -join ' <- '))
    $b -and $TypeIndex['Building'].IsAssignableFrom($b)
}

Test-That "the driver and giver the defs name are real, and of the right family" {
    $drv = $defsXml.SelectSingleNode('/Defs/JobDef/driverClass').InnerText
    $gvr = $defsXml.SelectSingleNode('/Defs/JoyGiverDef/giverClass').InnerText
    $d = $TypeIndex[$drv]
    $g = ($modTypes | Where-Object { $_.FullName -eq $gvr })[0]
    Note "$drv / $gvr"
    $d -and $g -and $TypeIndex['JobDriver'].IsAssignableFrom($d) -and $TypeIndex['JoyGiver'].IsAssignableFrom($g)
}

# JoyUtility credits the recreation with the JOB's joyKind, and counts what the map offers with
# the BUILDING's. Both have to be set, and they are two different fields - naming only one of
# them gives a source that shows up and credits nothing, or credits and never shows up.
Test-That "the two joyKind fields the game reads are both written" {
    $job   = $defsXml.SelectSingleNode('/Defs/JobDef/joyKind').InnerText
    # Under //value//, not //building//: only one of the two operations wraps its settings in a
    # <building> element. The other targets the <building> the def already has, so its children
    # sit directly under <value> - which is the whole asymmetry this mod has to live with.
    $bld   = $patchXml.SelectNodes('//value//joyKind') | ForEach-Object { $_.InnerText }
    $kind  = $defsXml.SelectSingleNode('/Defs/JoyKindDef/defName').InnerText
    Note ("JoyKindDef {0}; JobDef says {1}; the patch writes {2} building joyKind(s)" -f $kind, $job, @($bld).Count)
    ($job -ceq $kind) -and (@($bld).Count -eq 2) -and (@($bld | Where-Object { $_ -cne $kind }).Count -eq 0)
}

# ---------------------------------------------------------------------------------------------
# 3. The reverse sweep: who reads what this mod writes
# ---------------------------------------------------------------------------------------------
Write-Host " Inert settings" -ForegroundColor Cyan

# The fault no other kind of test sees: a setting the defs write that nothing on its code path
# ever reads. Point a def at a different giver and requireChair goes quiet - no error, no log
# line, just a rule that stopped applying. So: walk every method body in the game and look for
# the field token.
#
# Both load forms matter. A reference-typed field is read with ldfld; a STRUCT field is reached
# with ldflda, load-field-ADDRESS, because you need an address to call a method on it. Searching
# ldfld alone reports watchBuildingStandDistanceRange - an IntRange - as read by nobody, which is
# a lie that looks exactly like a real finding.
Add-Type -TypeDefinition @'
using System;using System.Collections.Generic;using System.Reflection;
public static class EgFieldSweep {
  // One pass over every method body, all tokens at once. Within a module a field's
  // MetadataToken is the same integer the IL carries, so no per-instruction ResolveMember.
  public static Dictionary<int,List<string>> Run(Type[] types, int[] tokens) {
    var want = new HashSet<int>(tokens);
    var res  = new Dictionary<int,List<string>>();
    foreach (var tk in tokens) res[tk] = new List<string>();
    foreach (var t in types) {
      try {
        // The enclosing type, not the compiler-generated one: a body inside <MakeNewToils>d__5
        // would otherwise be reported under a name two dozen classes share.
        Type outer = t; while (outer.DeclaringType != null) outer = outer.DeclaringType;
        var ms = new List<MethodBase>();
        ms.AddRange(t.GetMethods((BindingFlags)62));
        ms.AddRange(t.GetConstructors((BindingFlags)62));
        foreach (var m in ms) {
          byte[] il;
          try { var b = m.GetMethodBody(); if (b == null) continue; il = b.GetILAsByteArray(); } catch { continue; }
          if (il == null) continue;
          for (int i = 0; i + 4 < il.Length; i++) {
            byte op = il[i];
            // ldfld ldflda stfld ldsfld ldsflda stsfld
            if (op != 0x7B && op != 0x7C && op != 0x7D && op != 0x7E && op != 0x7F && op != 0x80) continue;
            int tok = BitConverter.ToInt32(il, i + 1);
            if (!want.Contains(tok)) continue;
            string name = outer.FullName + "." + m.Name;
            if (!res[tok].Contains(name)) res[tok].Add(name);
          }
        }
      } catch { }   // a half-loaded type throws from DeclaringType as readily as from GetMethods
    }
    return res;
  }
}
'@

# Every setting these defs and this patch write, with the class that has to read it for the
# setting to mean anything. A reader list that no longer contains that class is the finding.
$watched = @(
    @{ Type='BuildingProperties'; Field='joyKind';                         Wants='JoyUtility' },
    @{ Type='BuildingProperties'; Field='watchBuildingStandDistanceRange'; Wants='WatchBuildingUtility' },
    @{ Type='BuildingProperties'; Field='watchBuildingStandRectWidth';     Wants='WatchBuildingUtility' },
    @{ Type='BuildingProperties'; Field='watchBuildingInSameRoom';         Wants='WatchBuildingUtility' },
    @{ Type='ThingDef';           Field='socialPropernessMatters';         Wants='SocialProperness' },
    @{ Type='JobDef';             Field='joyDuration';                     Wants='JobDriver_WatchBuilding' },
    @{ Type='JobDef';             Field='joyMaxParticipants';              Wants='JobDriver_WatchBuilding' },
    @{ Type='JoyGiverDef';        Field='desireSit';                       Wants='JoyGiver_WatchBuilding' },
    @{ Type='JoyGiverDef';        Field='baseChance';                      Wants='JoyGiver' },
    @{ Type='JoyGiverDef';        Field='requiredCapacities';              Wants='JoyGiver' }
)
$tokens = @{}
foreach ($w in $watched) {
    $f = $TypeIndex[$w.Type].GetField($w.Field, $BF)
    if ($f) { $tokens[[int]$f.MetadataToken] = $w }
}
$readers = [EgFieldSweep]::Run($gameTypes, [int[]]$tokens.Keys)

Test-That "the sweep found the fields at all" {
    Note ("{0} of {1} fields still exist on their 1.6 class" -f $tokens.Count, $watched.Count)
    $tokens.Count -eq $watched.Count
}

foreach ($tk in @($tokens.Keys)) {
    $w = $tokens[$tk]
    $r = $readers[$tk]
    Test-That ("{0}.{1} is read by {2}" -f $w.Type, $w.Field, $w.Wants) {
        $hit = @($r | Where-Object { $_ -like ('*' + $w.Wants + '.*') })
        if ($hit.Count -eq 0) { Note ("readers: " + (($r | Select-Object -First 6) -join ', ')) }
        $hit.Count -gt 0
    }
}

# ---------------------------------------------------------------------------------------------
# 4. The patch, run through the game's own engine
# ---------------------------------------------------------------------------------------------
Write-Host " The patch engine" -ForegroundColor Cyan

# PatchOperationConditional, PatchOperationSequence and PatchOperationAdd are ordinary classes and
# run outside the game. The operations are rebuilt FROM THE SHIPPED XML rather than written out
# here by hand - writing them here would test the copy, not the file that ships.
$target = New-Object System.Xml.XmlDocument
$target.Load($anomaly)

function New-PatchOp([System.Xml.XmlNode]$node) {
    $cls = $node.GetAttribute('Class')
    if (-not $cls) { return $null }
    $t = $TypeIndex[$cls]
    if (-not $t) { return $null }
    $op = [System.Activator]::CreateInstance($t)

    $xp = $node.SelectSingleNode('xpath')
    if ($xp) { $TypeIndex['PatchOperationPathed'].GetField('xpath', $BF).SetValue($op, $xp.InnerText) }

    # XmlContainer holds a single XmlNode field. PatchOperationAdd does the ImportNode itself.
    $val = $node.SelectSingleNode('value')
    if ($val -and $t.GetField('value', $BF)) {
        $box = [System.Activator]::CreateInstance($TypeIndex['XmlContainer'])
        $TypeIndex['XmlContainer'].GetField('node', $BF).SetValue($box, $val)
        $t.GetField('value', $BF).SetValue($op, $box)
    }

    # success is private on PatchOperation, so it is invisible to GetField on the subclass.
    $sn = $node.SelectSingleNode('success')
    if ($sn) {
        $f = $TypeIndex['PatchOperation'].GetField('success', $BF)
        $f.SetValue($op, [System.Enum]::Parse($f.FieldType, $sn.InnerText))
    }

    $m = $node.SelectSingleNode('match')
    if ($m) { $t.GetField('match', $BF).SetValue($op, (New-PatchOp $m)) }
    $nm = $node.SelectSingleNode('nomatch')
    if ($nm) { $t.GetField('nomatch', $BF).SetValue($op, (New-PatchOp $nm)) }

    $ops = $node.SelectNodes('operations/li')
    if ($ops.Count -gt 0) {
        $listT = [System.Collections.Generic.List[object]]
        $list = $t.GetField('operations', $BF)
        $inner = [System.Activator]::CreateInstance([System.Collections.Generic.List``1].MakeGenericType($TypeIndex['PatchOperation']))
        foreach ($o in $ops) { $inner.Add((New-PatchOp $o)) }
        $list.SetValue($op, $inner)
    }
    return $op
}

# Apply opens on `if (DeepProfiler.enabled)`, which is true outside the game while the profiler's
# buffers are null. Turn it off and the real Apply runs, success handling included.
$TypeIndex['DeepProfiler'].GetField('enabled', $BF).SetValue($null, $false)

$applyOk = $true
Test-That "every operation in the shipped patch file rebuilds and applies" {
    foreach ($node in $patchXml.SelectNodes('/Patch/Operation')) {
        $op = New-PatchOp $node
        if (-not $op) { Note "could not rebuild an operation"; $script:applyOk = $false; return $false }
        $r = $op.Apply($target)
        if (-not $r) { Note ("Apply returned false on " + $node.SelectSingleNode('xpath').InnerText); $script:applyOk = $false; return $false }
    }
    $true
}

# The one real trap in this mod, and it is inverted between the two defs. HoldingPlatform has a
# statBases and NO building node; HoldingSpot has both. So the platform's settings are created at
# the root and the spot's are added inside the node it already has. Reverse the two and you get
# two sibling nodes, of which the game reads one - silently, on a holder that looks normal.
# Hashtables, not pairs: PowerShell flattens nested arrays in a foreach and $pair would come out
# holding the whole case rather than one field of it, silently.
foreach ($case in @(@{ Def='HoldingPlatform'; Factor='1' }, @{ Def='HoldingSpot'; Factor='0.8' })) {
    $defName = $case.Def
    $factor  = $case.Factor
    Test-That ("$defName came out of the patch in one piece") {
        $d = $target.SelectSingleNode("Defs/ThingDef[defName=`"$defName`"]")
        $counts = @{}
        foreach ($n in 'statBases','building','placeWorkers') { $counts[$n] = $d.SelectNodes($n).Count }
        Note ("statBases x{0}, building x{1}, placeWorkers x{2}" -f $counts['statBases'], $counts['building'], $counts['placeWorkers'])
        ($counts['statBases'] -eq 1) -and ($counts['building'] -eq 1) -and ($counts['placeWorkers'] -eq 1)
    }

    Test-That ("$defName kept its own settings alongside the new ones") {
        $d = $target.SelectSingleNode("Defs/ThingDef[defName=`"$defName`"]")
        $stats = @($d.SelectNodes('statBases/*') | ForEach-Object { $_.LocalName })
        $bld   = @($d.SelectNodes('building/*')  | ForEach-Object { $_.LocalName })
        Note ("statBases: " + ($stats -join ', '))
        ($stats -contains 'MaxHitPoints') -and ($stats -contains 'JoyGainFactor') -and
        ($bld -contains 'joyKind') -and ($bld -contains 'watchBuildingInSameRoom') -and
        ($d.SelectSingleNode('statBases/JoyGainFactor').InnerText -ceq $factor)
    }
}

# HoldingSpot's own building settings are the half that a reversed patch loses. Naming them
# explicitly is what turns "one building node" into "the RIGHT building node".
Test-That "the holding spot still carries its own building settings" {
    $d = $target.SelectSingleNode('Defs/ThingDef[defName="HoldingSpot"]')
    $bld = @($d.SelectNodes('building/*') | ForEach-Object { $_.LocalName })
    Note ($bld -join ', ')
    ($bld -contains 'sowTag') -and ($bld -contains 'artificialForMeditationPurposes')
}

Test-That "the place worker the patch adds is a real type" {
    $names = @($patchXml.SelectNodes('//placeWorkers/li') | ForEach-Object { $_.InnerText } | Select-Object -Unique)
    Note ($names -join ', ')
    (@($names | Where-Object { -not $TypeIndex[$_] }).Count -eq 0) -and $names.Count -ge 1
}

# ---------------------------------------------------------------------------------------------
# 5. The claims the documentation makes about the game
# ---------------------------------------------------------------------------------------------
Write-Host " Claims recomputed from the game" -ForegroundColor Cyan

$dataDirs = Get-ChildItem $GameData -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'Defs') }

function Count-In([string]$dir, [string]$needle) {
    $c = 0
    foreach ($f in Get-ChildItem (Join-Path $dir 'Defs') -Recurse -Filter *.xml -ErrorAction SilentlyContinue) {
        $c += ([regex]::Matches((Get-Content $f.FullName -Raw -Encoding UTF8), [regex]::Escape($needle))).Count
    }
    return $c
}

# The whole reason the mod exists. If a future Anomaly update ships any recreation content, this
# goes red and the README's opening paragraph is the thing to rewrite.
Test-That "Anomaly still ships no recreation content at all" {
    $a = Join-Path $GameData 'Anomaly'
    $k = Count-In $a '<JoyKindDef'; $g = Count-In $a '<JoyGiverDef'; $j = Count-In $a '<joyKind>'
    Note ("JoyKindDef {0}, JoyGiverDef {1}, joyKind {2}" -f $k, $g, $j)
    ($k -eq 0) -and ($g -eq 0) -and ($j -eq 0)
}

# The README says ten types, five of them from a building. Computed, so a release that moves
# either number is reported instead of quietly ageing the page.
Test-That "Core still has ten recreation types, five of them from a building" {
    $core = Join-Path $GameData 'Core'
    $kinds = @()
    $fromBuilding = @()
    foreach ($f in Get-ChildItem (Join-Path $core 'Defs') -Recurse -Filter *.xml) {
        $x = New-Object System.Xml.XmlDocument
        try { $x.Load($f.FullName) } catch { continue }
        foreach ($n in $x.SelectNodes('//JoyKindDef/defName')) { $kinds += $n.InnerText }
        foreach ($n in $x.SelectNodes('//building/joyKind'))   { $fromBuilding += $n.InnerText }
    }
    $fromBuilding = @($fromBuilding | Sort-Object -Unique)
    Note ("{0} types; from a building: {1}" -f @($kinds).Count, ($fromBuilding -join ', '))
    (@($kinds).Count -eq 10) -and ($fromBuilding.Count -eq 5)
}

# The design claim: watchers stand inside the nociosphere's pain field. Both numbers are read,
# never recalled - widen the range past the field and this test says the price is gone.
Test-That "the watch range still overlaps the nociosphere's pain field" {
    $x = New-Object System.Xml.XmlDocument
    $x.Load((Join-Path $GameData 'Anomaly\Defs\ThingDefs_Races\Races_Entities_Misc.xml'))
    $node = $x.SelectSingleNode('//ThingDef[defName="Nociosphere"]//li[hediff="PainField"]/range')
    $range = [double]$node.InnerText
    $watch = $patchXml.SelectSingleNode('(//watchBuildingStandDistanceRange)[1]').InnerText
    $lo = [double]$watch.Split('~')[0]
    Note ("PainField {0} cells; watchers stand {1}" -f $range, $watch)
    $lo -lt $range
}

# The README says two holders and no more. A third one appearing is content the mod would miss.
Test-That "Anomaly still ships exactly the two entity holders the mod covers" {
    $found = @()
    foreach ($d in $dataDirs) {
        foreach ($f in Get-ChildItem (Join-Path $d.FullName 'Defs') -Recurse -Filter *.xml) {
            $raw = Get-Content $f.FullName -Raw -Encoding UTF8
            if ($raw -notmatch 'CompProperties_EntityHolderPlatform') { continue }
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($f.FullName) } catch { continue }
            foreach ($n in $x.SelectNodes('//ThingDef[comps/li[@Class="CompProperties_EntityHolderPlatform"]]/defName')) { $found += $n.InnerText }
        }
    }
    $found = @($found | Sort-Object -Unique)
    $ours  = @($defsXml.SelectNodes('/Defs/JoyGiverDef/thingDefs/li') | ForEach-Object { $_.InnerText } | Sort-Object)
    Note ("game: " + ($found -join ', ') + "   |   mod covers: " + ($ours -join ', '))
    ($found.Count -eq 2) -and (($found -join ',') -ceq ($ours -join ','))
}

# Read off the vanilla cousins rather than judged by taste: the JobDefs that run on the same
# driver give the range a joyDuration may sit in, and likewise for baseChance.
Test-That "joyDuration and baseChance sit inside the vanilla range for the same classes" {
    $durations = @(); $chances = @()
    foreach ($d in $dataDirs) {
        foreach ($f in Get-ChildItem (Join-Path $d.FullName 'Defs') -Recurse -Filter *.xml) {
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($f.FullName) } catch { continue }
            foreach ($n in $x.SelectNodes('//JobDef[driverClass="JobDriver_WatchBuilding"]/joyDuration')) { $durations += [int]$n.InnerText }
            foreach ($n in $x.SelectNodes('//JoyGiverDef[giverClass="JoyGiver_WatchBuilding"]/baseChance')) { $chances += [double]$n.InnerText }
        }
    }
    if ($durations.Count -eq 0 -or $chances.Count -eq 0) { Note 'no vanilla cousins found'; return $false }
    $ourD = [int]$defsXml.SelectSingleNode('/Defs/JobDef/joyDuration').InnerText
    $ourC = [double]$defsXml.SelectSingleNode('/Defs/JoyGiverDef/baseChance').InnerText
    Note ("joyDuration {0} in [{1}..{2}]; baseChance {3} in [{4}..{5}]" -f `
        $ourD, ($durations | Measure-Object -Minimum).Minimum, ($durations | Measure-Object -Maximum).Maximum,
        $ourC, ($chances | Measure-Object -Minimum).Minimum, ($chances | Measure-Object -Maximum).Maximum)
    ($ourD -ge ($durations | Measure-Object -Minimum).Minimum) -and ($ourD -le ($durations | Measure-Object -Maximum).Maximum) -and
    ($ourC -ge ($chances   | Measure-Object -Minimum).Minimum) -and ($ourC -le ($chances   | Measure-Object -Maximum).Maximum)
}

# Every vanilla watch building sets it. The mod not setting it was a real gap, closed on
# 2026-09-11; this is what keeps it closed.
Test-That "the same-room requirement matches what every vanilla watch building does" {
    $vanilla = 0; $with = 0
    foreach ($d in $dataDirs) {
        foreach ($f in Get-ChildItem (Join-Path $d.FullName 'Defs') -Recurse -Filter *.xml) {
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($f.FullName) } catch { continue }
            foreach ($n in $x.SelectNodes('//building[watchBuildingStandDistanceRange]')) {
                $vanilla++
                if ($n.SelectSingleNode('watchBuildingInSameRoom')) { $with++ }
            }
        }
    }
    $oursTotal = $patchXml.SelectNodes('//value//watchBuildingStandDistanceRange').Count
    $oursSame  = $patchXml.SelectNodes('//value//watchBuildingInSameRoom').Count
    Note ("vanilla {0}/{1} set it; this mod {2}/{3}" -f $with, $vanilla, $oursSame, $oursTotal)
    ($with -eq $vanilla) -and ($oursSame -eq $oursTotal) -and ($oursTotal -eq 2)
}

# ---------------------------------------------------------------------------------------------
Write-Host ""
Write-Host ("  {0} passed, {1} failed, {2} total" -f $script:pass, $script:fail, $script:n) `
    -ForegroundColor $(if ($script:fail) { 'Red' } else { 'Green' })
Write-Host ""
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)
if ($script:fail) { exit 1 }

# ---------------------------------------------------------------------------------------------
# What has been seen to fail
#
# Fifteen of the thirty-five tests here have been watched turning red, driven by Run-Mutations.ps1
# beside this file: 2, 3, 8, 10, 11, 23, 24, 25, 26, 27, 29, 32, 33, 34, 35.
#
# The other twenty have not, and most of them cannot be. Tests 4 to 6, 9, 12 to 22, 30 and 31 ask
# questions about Assembly-CSharp itself - does this field still exist, does this class still read
# it - and no mutation of a copy of the mod reaches them. Reddening those means editing the
# question rather than the answer: rename the field or the class this file asks for, and watch each
# one name what it can no longer find. That is a weaker claim than a real mutation and is worth
# saying plainly rather than leaving a reader to assume otherwise.
#
# Test 1 is the harness guard, and test 28 would need a patch that REPLACES the holding spot's
# building node rather than duplicating it, which no plausible edit of this file produces.
#
# Test 7 is the odd one out and worth naming. To redden it, a mutation would have to compile
# against Krafs.Rimworld.Ref and fail against the real Assembly-CSharp - which, with no publicizer
# in the csproj, nothing does: the reference package keeps the game's own accessibility, so an
# illegal access is a compile error on both sides and the mutated assembly is never built at all.
# The test still earns its place. It is the standing proof that this mod takes nothing from the
# game it is not allowed to take, and it is what would speak first if a publicizer were ever added
# here - which test 8, and only test 8, would then catch.
#
# One thing the campaign changed rather than confirmed: the reverse sweep originally looked for
# ldfld alone, and reported watchBuildingStandDistanceRange - an IntRange, so a struct - as read by
# nobody. A struct field is reached with ldflda, load-field-ADDRESS. The missing opcode looked
# exactly like a real finding.
