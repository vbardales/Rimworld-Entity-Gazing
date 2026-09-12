<#
.SYNOPSIS
  Checks the shape of the mod: its XML, its translations, its packaging and its prose. No RimWorld
  launched.

.DESCRIPTION
  The companion suite, Run-Functional-Tests.ps1, asks whether the game still does what this mod
  hands it to do. This one asks a narrower question: is the mod well formed, and does it still say
  the same thing everywhere it says something?

  Two faults it is shaped around, both silent in game:

    - an XML element matching no field on the 1.6 class. RimWorld does not stop on one; it logs a
      line, leaves the field unset, and carries on. The mod loads and is simply wrong.
    - a DefInjected path whose folder case does not match the def type. Windows finds the file,
      Linux does not, so the translation vanishes for half the players and nobody here can see it.

  The rest is documentation kept honest against the defs. Every number the README, the changelog
  and the scenarios quote is read back out of the XML: a value changed in the defs and not in the
  prose turns this suite red instead of quietly ageing the page.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1
#>
param(
    [string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed'
)

$ErrorActionPreference = 'Stop'
$ModRoot = Split-Path -Parent $PSScriptRoot
$Mod     = Join-Path $ModRoot 'Mod'

$script:pass = 0; $script:fail = 0; $script:n = 0
function Test-That([string]$name, [scriptblock]$body) {
    $script:n++
    try {
        $r = & $body
        if (($r -is [string]) -and ($r -eq 'skip')) { Write-Host ("  {0,2}. SKIP  {1}" -f $script:n, $name) -ForegroundColor DarkGray; return }
        if ($r) { $script:pass++; Write-Host ("  {0,2}. ok    {1}" -f $script:n, $name) -ForegroundColor DarkGreen }
        else    { $script:fail++; Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red }
    } catch {
        $script:fail++
        Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red
        Write-Host ("        {0}" -f $_.Exception.Message) -ForegroundColor DarkRed
    }
}
function Note([string]$t) { Write-Host ("        " + $t) -ForegroundColor DarkGray }

# Prose is always read with -Encoding UTF8. Without it, Windows PowerShell 5.1 reads a file with
# no BOM through the system code page, and a test looking for a word finds mojibake instead.
function Read-Text([string]$p) { Get-Content $p -Raw -Encoding UTF8 }

$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $s = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($s)) { return $null }
    $script:probed[$s] = $true
    foreach ($d in @($Managed, (Join-Path $Mod 'Assemblies'))) {
        $p = Join-Path $d "$s.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$gameTypes = Get-AssemblyTypes (Join-Path $Managed 'Assembly-CSharp.dll')
$modTypes  = @(Get-AssemblyTypes (Join-Path $Mod 'Assemblies\EntityGazing.dll'))
$TypeIndex = @{}
foreach ($t in @($gameTypes) + $modTypes) {
    if ($t.Name     -and -not $TypeIndex.ContainsKey($t.Name))     { $TypeIndex[$t.Name] = $t }
    if ($t.FullName -and -not $TypeIndex.ContainsKey($t.FullName)) { $TypeIndex[$t.FullName] = $t }
}
$BF = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,DeclaredOnly'

$xmlFiles = @(Get-ChildItem $Mod -Recurse -Filter *.xml)
$readme   = Read-Text (Join-Path $ModRoot 'README.md')
$changes  = Read-Text (Join-Path $ModRoot 'CHANGELOG.md')
$testing  = Read-Text (Join-Path $ModRoot 'TESTING.md')

Write-Host ""
Write-Host "Entity Gazing - form tests" -ForegroundColor Cyan
Write-Host ""
Write-Host " Harness" -ForegroundColor Cyan

Test-That "the game, the mod and its documents are all there" {
    Note ("{0} game types, {1} mod types, {2} xml files" -f $gameTypes.Count, $modTypes.Count, $xmlFiles.Count)
    ($gameTypes.Count -gt 10000) -and ($modTypes.Count -ge 1) -and ($xmlFiles.Count -eq 5) -and
    ($readme.Length -gt 500) -and ($changes.Length -gt 300) -and ($testing.Length -gt 1000)
}

# ---------------------------------------------------------------------------------------------
Write-Host " The XML" -ForegroundColor Cyan

# Before anything parses a document. A malformed file would otherwise take the whole suite down
# on its first Load, with a .NET message and no test number - the one fault that would be
# reported worst of all.
$failuresBefore = $script:fail
Test-That "every XML file is well formed" {
    $bad = @()
    foreach ($f in $xmlFiles) {
        try { $d = New-Object System.Xml.XmlDocument; $d.Load($f.FullName) } catch { $bad += ($f.Name + ': ' + $_.Exception.InnerException.Message) }
    }
    if ($bad) { Note ($bad -join ' | ') }
    $bad.Count -eq 0
}
# Only this test's own failure stops the run. Keying the early exit on the running total instead
# made a failing harness guard swallow the whole suite, which cost a mutation its verdict.
if ($script:fail -gt $failuresBefore) {
    Write-Host ""
    Write-Host "  stopping here: nothing below can run against XML that does not parse" -ForegroundColor Red
    Write-Host ("  {0} passed, {1} failed, {2} total" -f $script:pass, $script:fail, $script:n) -ForegroundColor Red
    Write-Host ""
    exit 1
}

$defsXml  = New-Object System.Xml.XmlDocument; $defsXml.Load((Join-Path $Mod 'Defs\EntityGazing.xml'))
$patchXml = New-Object System.Xml.XmlDocument; $patchXml.Load((Join-Path $Mod 'Patches\HoldingPlatforms.xml'))
$about    = New-Object System.Xml.XmlDocument; $about.Load((Join-Path $Mod 'About\About.xml'))

# RimWorld's loader reads public and non-public fields, own and inherited. An element matching no
# field is dropped with one log line and the def loads without it - which is why this is checked
# here rather than trusted to show up in play.
function Get-FieldNames([Type]$t) {
    $names = @{}
    $cur = $t
    while ($cur -and $cur.FullName -ne 'System.Object') {
        foreach ($f in $cur.GetFields($BF)) { $names[$f.Name] = $true }
        $cur = $cur.BaseType
    }
    return $names
}

Test-That "every element of the three defs is a field the 1.6 class still has" {
    $bad = @()
    foreach ($defNode in $defsXml.SelectNodes('/Defs/*')) {
        $t = $TypeIndex[$defNode.LocalName]
        if (-not $t) { $bad += ("unknown def type " + $defNode.LocalName); continue }
        $fields = Get-FieldNames $t
        foreach ($child in $defNode.ChildNodes) {
            if ($child.NodeType -ne [System.Xml.XmlNodeType]::Element) { continue }
            if (-not $fields.ContainsKey($child.LocalName)) { $bad += ($defNode.LocalName + '.' + $child.LocalName) }
        }
    }
    if ($bad) { Note ($bad -join ', ') }
    $bad.Count -eq 0
}

Test-That "every element the patch writes is a field on ThingDef or BuildingProperties" {
    $td = Get-FieldNames $TypeIndex['ThingDef']
    $bp = Get-FieldNames $TypeIndex['BuildingProperties']
    $bad = @()
    foreach ($v in $patchXml.SelectNodes('//value')) {
        foreach ($child in $v.ChildNodes) {
            if ($child.NodeType -ne [System.Xml.XmlNodeType]::Element) { continue }
            $name = $child.LocalName
            # A <value> under .../statBases holds stat names, not fields; and one under
            # .../building holds BuildingProperties fields with no wrapper.
            $xp = $v.ParentNode.SelectSingleNode('xpath').InnerText
            if ($xp -match '/statBases$')  { continue }
            if ($xp -match '/building$')   { if (-not $bp.ContainsKey($name)) { $bad += "BuildingProperties.$name" }; continue }
            if ($name -eq 'building') {
                foreach ($g in $child.ChildNodes) {
                    if ($g.NodeType -eq [System.Xml.XmlNodeType]::Element -and -not $bp.ContainsKey($g.LocalName)) { $bad += ("BuildingProperties." + $g.LocalName) }
                }
                continue
            }
            if (-not $td.ContainsKey($name)) { $bad += "ThingDef.$name" }
        }
    }
    if ($bad) { Note ($bad -join ', ') }
    $bad.Count -eq 0
}

Test-That "every Class= in the patch is a real patch operation" {
    $bad = @()
    foreach ($n in $patchXml.SelectNodes('//*[@Class]')) {
        $c = $n.GetAttribute('Class')
        $t = $TypeIndex[$c]
        if (-not $t -or -not $TypeIndex['PatchOperation'].IsAssignableFrom($t)) { $bad += $c }
    }
    if ($bad) { Note ($bad -join ', ') }
    $bad.Count -eq 0
}

Test-That "every stat the patch writes is a real StatDef" {
    $stats = @()
    foreach ($v in $patchXml.SelectNodes('//value')) {
        $xp = $v.ParentNode.SelectSingleNode('xpath').InnerText
        if ($xp -notmatch '/statBases$') { continue }
        foreach ($c in $v.ChildNodes) { if ($c.NodeType -eq [System.Xml.XmlNodeType]::Element) { $stats += $c.LocalName } }
    }
    $stats = @($stats | Sort-Object -Unique)
    # Every Defs folder, not a guessed subfolder: JoyGainFactor lives in Defs\Stats, and a
    # hardcoded Defs\StatDefs path reported the mod's own stat as invented.
    $known = @()
    foreach ($d in Get-ChildItem 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data' -Directory) {
        $p = Join-Path $d.FullName 'Defs'
        if (-not (Test-Path $p)) { continue }
        foreach ($f in Get-ChildItem $p -Recurse -Filter *.xml) {
            if ((Read-Text $f.FullName) -notmatch '<StatDef') { continue }
            $x = New-Object System.Xml.XmlDocument
            try { $x.Load($f.FullName) } catch { continue }
            foreach ($n in $x.SelectNodes('//StatDef/defName')) { $known += $n.InnerText }
        }
    }
    Note ("$($known.Count) stats known to the game")
    Note ($stats -join ', ')
    ($stats.Count -ge 1) -and (@($stats | Where-Object { $known -notcontains $_ }).Count -eq 0)
}

# The mod's own defs and Anomaly's are the only ones it may point at; a typo here is a red line
# in game, but only for the players who have got that far.
Test-That "every def the mod references exists" {
    $ours = @($defsXml.SelectNodes('/Defs/*/defName') | ForEach-Object { $_.InnerText })
    $refs = @()
    foreach ($p in 'JobDef/joyKind','JoyGiverDef/joyKind','JoyGiverDef/jobDef') {
        $refs += $defsXml.SelectSingleNode("/Defs/$p").InnerText
    }
    $missing = @($refs | Where-Object { $ours -notcontains $_ })
    $holders = @($defsXml.SelectNodes('/Defs/JoyGiverDef/thingDefs/li') | ForEach-Object { $_.InnerText })
    $anomalyDefs = @()
    $x = New-Object System.Xml.XmlDocument
    $x.Load('C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data\Anomaly\Defs\ThingDefs_Buildings\Buildings_Misc.xml')
    foreach ($n in $x.SelectNodes('//ThingDef/defName')) { $anomalyDefs += $n.InnerText }
    $missing += @($holders | Where-Object { $anomalyDefs -notcontains $_ })
    if ($missing) { Note ($missing -join ', ') }
    $missing.Count -eq 0
}

# MayRequire is what makes the mod inert rather than broken with Anomaly off, and it has to be on
# every def, not most of them. The patch gets the same guarantee from PatchOperationConditional.
Test-That "all three defs carry MayRequire, and the patch is conditional" {
    $defs = @($defsXml.SelectNodes('/Defs/*'))
    $guarded = @($defs | Where-Object { $_.GetAttribute('MayRequire') -ceq 'Ludeon.RimWorld.Anomaly' })
    $conds = @($patchXml.SelectNodes('/Patch/Operation[@Class="PatchOperationConditional"]'))
    Note ("{0} of {1} defs guarded; {2} of {3} operations conditional" -f $guarded.Count, $defs.Count, $conds.Count, $patchXml.SelectNodes('/Patch/Operation').Count)
    ($guarded.Count -eq $defs.Count) -and ($conds.Count -eq $patchXml.SelectNodes('/Patch/Operation').Count)
}

# ---------------------------------------------------------------------------------------------
Write-Host " Translation" -ForegroundColor Cyan

# A DefInjected handle is <defName>.<field>, and the folder is the def TYPE. Case matters on both:
# Windows resolves DefInjected/jobdef either way, Linux does not, and the translation silently
# disappears for the players who are not on Windows.
$frRoot = Join-Path $Mod 'Languages\French\DefInjected'

Test-That "each DefInjected folder is named exactly like its def type" {
    $bad = @()
    foreach ($d in Get-ChildItem $frRoot -Directory) {
        $t = $TypeIndex[$d.Name]
        if (-not $t -or -not ($t.Name -ceq $d.Name)) { $bad += $d.Name }
    }
    if ($bad) { Note ($bad -join ', ') }
    (@(Get-ChildItem $frRoot -Directory).Count -ge 1) -and ($bad.Count -eq 0)
}

Test-That "every French key names a real def and a real field" {
    $bad = @()
    $count = 0
    foreach ($d in Get-ChildItem $frRoot -Directory) {
        $t = $TypeIndex[$d.Name]
        $fields = Get-FieldNames $t
        foreach ($f in Get-ChildItem $d.FullName -Filter *.xml) {
            $x = New-Object System.Xml.XmlDocument; $x.Load($f.FullName)
            foreach ($k in $x.SelectNodes('/LanguageData/*')) {
                $count++
                $parts = $k.LocalName.Split('.')
                $defName = $parts[0]; $field = $parts[-1]
                $node = $defsXml.SelectSingleNode("/Defs/$($d.Name)[defName='$defName']")
                if (-not $node)                  { $bad += ($k.LocalName + ' (no such def)') ; continue }
                if (-not $fields.ContainsKey($field)) { $bad += ($k.LocalName + ' (no such field)') ; continue }
                if (-not $node.SelectSingleNode($field)) { $bad += ($k.LocalName + ' (def does not set it)') }
            }
        }
    }
    Note ("$count keys")
    ($count -ge 2) -and ($bad.Count -eq 0)
}

# Every string the game will show has to be translated, or the French player gets the English one
# with no warning. The fields are found by attribute rather than listed, so a string RimWorld
# starts translating one day is covered without touching this suite.
Test-That "every translatable string the defs set has a French key" {
    $mustTranslate = $TypeIndex['MustTranslateAttribute']
    $keys = @()
    foreach ($d in Get-ChildItem $frRoot -Directory -Recurse) {
        foreach ($f in Get-ChildItem $d.FullName -Filter *.xml) {
            $x = New-Object System.Xml.XmlDocument; $x.Load($f.FullName)
            foreach ($k in $x.SelectNodes('/LanguageData/*')) { $keys += $k.LocalName }
        }
    }
    $missing = @()
    foreach ($defNode in $defsXml.SelectNodes('/Defs/*')) {
        $t = $TypeIndex[$defNode.LocalName]
        $defName = $defNode.SelectSingleNode('defName').InnerText
        $cur = $t
        while ($cur -and $cur.FullName -ne 'System.Object') {
            foreach ($fld in $cur.GetFields($BF)) {
                if (-not $fld.IsDefined($mustTranslate, $true)) { continue }
                if (-not $defNode.SelectSingleNode($fld.Name)) { continue }
                $handle = "$defName.$($fld.Name)"
                if ($keys -notcontains $handle) { $missing += $handle }
            }
            $cur = $cur.BaseType
        }
    }
    if ($missing) { Note ($missing -join ', ') }
    $missing.Count -eq 0
}

# ---------------------------------------------------------------------------------------------
Write-Host " Packaging" -ForegroundColor Cyan

Test-That "the shipped assembly is not older than its sources" {
    $dll = Get-Item (Join-Path $Mod 'Assemblies\EntityGazing.dll')
    $newest = (Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Include *.cs,*.csproj,*.props | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    Note ("dll {0:yyyy-MM-dd HH:mm}, newest source {1:yyyy-MM-dd HH:mm} ({2})" -f $dll.LastWriteTime, $newest.LastWriteTime, $newest.Name)
    $dll.LastWriteTime -ge $newest.LastWriteTime
}

Test-That "the About says what the repository says" {
    $m = $about.ModMetaData
    Note ("{0} / {1} / {2}" -f $m.name, $m.packageId, $m.url)
    ($m.name -ceq 'Entity Gazing') -and
    ($m.packageId -ceq 'nelim.entitygazing') -and
    ($m.url -ceq 'https://github.com/vbardales/Rimworld-Entity-Gazing') -and
    ($m.supportedVersions.li -contains '1.6') -and
    ($about.SelectSingleNode('//modDependencies/li/packageId').InnerText -ceq 'Ludeon.RimWorld.Anomaly')
}

# An original creation takes no suffix: neither the Nelim's of a private extraction nor the Renew
# of a port. The displayed name is where that convention is visible.
Test-That "the displayed name carries no version and no suffix" {
    $n = $about.ModMetaData.name
    ($n -notmatch '1\.6') -and ($n -notmatch 'Renew') -and ($n -notmatch "Nelim") -and ($n -notmatch 'Continued')
}

Test-That "nothing that should not ship is inside Mod/" {
    $junk = @(Get-ChildItem $Mod -Recurse -File | Where-Object {
        $_.Extension -in '.ps1','.pdb','.md','.lnk' -or $_.FullName -match '\\(obj|bin)\\'
    })
    if ($junk) { Note (($junk | ForEach-Object { $_.Name }) -join ', ') }
    $junk.Count -eq 0
}

Add-Type -AssemblyName System.Drawing
Test-That "the showcase images are the right size and weight" {
    $ok = $true
    foreach ($c in @(
        @{ Path='Mod\About\Preview.png'; W=896; H=504; Max=900KB },
        @{ Path='Mod\About\ModIcon.png'; W=128; H=128; Max=40KB })) {
        $f = Get-Item (Join-Path $ModRoot $c.Path)
        $i = [System.Drawing.Image]::FromFile($f.FullName)
        Note ("{0}: {1}x{2}, {3} KB" -f $c.Path, $i.Width, $i.Height, [math]::Round($f.Length/1KB))
        if ($i.Width -ne $c.W -or $i.Height -ne $c.H -or $f.Length -gt $c.Max) { $ok = $false }
        $i.Dispose()
    }
    $ok
}

# The full-resolution originals live under Art/. The Workshop uploader takes Mod/ as it stands,
# so a 1.6 MB source left in About/ would be shipped to every subscriber.
Test-That "the full-resolution sources are under Art/, not in About/" {
    (Test-Path (Join-Path $ModRoot 'Art\Preview-source.png')) -and
    (Test-Path (Join-Path $ModRoot 'Art\ModIcon-source.png')) -and
    (@(Get-ChildItem (Join-Path $Mod 'About') -Filter *.png).Count -eq 2)
}

# ---------------------------------------------------------------------------------------------
Write-Host " Documentation against the defs" -ForegroundColor Cyan

Test-That "LICENSE is MIT and the README points at it" {
    $lic = Read-Text (Join-Path $ModRoot 'LICENSE')
    ($lic -match 'MIT License') -and ($lic -match 'nelim') -and ($readme -match '\[LICENSE\]\(LICENSE\)')
}

# Everything in a public repository is written in English, code comments included. Accents are a
# poor test - a French sentence can have none - so this looks for the words French cannot avoid.
Test-That "the documents and the code comments are in English" {
    $words = '\b(le|la|les|une|des|est|sont|pour|dans|avec|qui|que|pas|sans|donc|cette|nous|vous)\b'
    $bad = @()
    foreach ($f in @('README.md','CHANGELOG.md','TESTING.md') | ForEach-Object { Join-Path $ModRoot $_ }) {
        if ((Read-Text $f) -match $words) { $bad += (Split-Path $f -Leaf) }
    }
    foreach ($f in @(Get-ChildItem (Join-Path $ModRoot 'Source') -Recurse -Include *.cs,*.csproj) + $xmlFiles) {
        if ($f.FullName -match 'Languages') { continue }
        if ((Read-Text $f.FullName) -match $words) { $bad += $f.Name }
    }
    if ($bad) { Note (($bad | Sort-Object -Unique) -join ', ') }
    $bad.Count -eq 0
}

# A document that quotes a number is a document that goes stale. These are read back out of the
# XML, so changing a value in the defs and not in the prose turns this red.
Test-That "the numbers the documents quote are the numbers the defs carry" {
    $range   = $patchXml.SelectSingleNode('(//watchBuildingStandDistanceRange)[1]').InnerText
    $factors = @($patchXml.SelectNodes('//JoyGainFactor') | ForEach-Object { $_.InnerText })
    $dur     = $defsXml.SelectSingleNode('/Defs/JobDef/joyDuration').InnerText
    $parts   = $defsXml.SelectSingleNode('/Defs/JobDef/joyMaxParticipants').InnerText
    $lo, $hi = $range.Split('~')
    $prose = $readme + $changes + $testing
    $checks = @{
        'watch range low'   = ($prose -match "\b$lo to $hi\b")
        'JoyGainFactor set' = (($factors -contains '1') -and ($factors -contains '0.8') -and ($prose -match '0\.8') -and ($readme -match '0\.8'))
        'joyDuration'       = ($testing -match "\b$dur\b")
        'participants'      = ($testing -match "\*\*$parts\*\*")
    }
    $bad = @($checks.Keys | Where-Object { -not $checks[$_] })
    if ($bad) { Note ("not found in the prose: " + ($bad -join ', ')) }
    $bad.Count -eq 0
}

# The README tells the reader how many scenarios there are. Count them instead of trusting it.
Test-That "the README's scenario count matches TESTING.md" {
    $scenarios = ([regex]::Matches($testing, '(?m)^## \d+\.')).Count
    $words = @{ 12='twelve'; 13='thirteen'; 14='fourteen'; 15='fifteen'; 16='sixteen' }
    $word = $words[$scenarios]
    Note ("$scenarios scenarios; the README says '$word'")
    $word -and ($readme -match "\b$word scenarios\b")
}

# The README quotes how many tests there are in each suite. Counted here rather than trusted, so
# that adding a test and forgetting the sentence is a red line instead of a document going quietly
# out of date.
# Only the two numbers that can be counted from the files themselves. The functional suite's total
# cannot: two of its call sites sit inside loops and stand for fourteen tests between them, so
# counting call sites there would put a wrong number in the README with a green test beside it -
# worse than no test at all.
Test-That "the README's test counts match the files" {
    $form = ([regex]::Matches((Read-Text $PSCommandPath), '(?m)^Test-That ')).Count
    $muts = ([regex]::Matches((Read-Text (Join-Path $PSScriptRoot 'Run-Mutations.ps1')), "(?m)^\s*@\{ n=")).Count
    Note ("$form form tests, $muts mutations")
    ($readme -match "\b$form form tests\b") -and ($readme -match "\b$muts mutations\b")
}

Test-That "the documents name the patch file that actually exists" {
    $named = [regex]::Matches($readme + $changes + $testing, '[A-Za-z]+\.xml') | ForEach-Object { $_.Value } | Sort-Object -Unique
    $onDisk = @($xmlFiles | ForEach-Object { $_.Name })
    $ghost = @($named | Where-Object { $onDisk -notcontains $_ })
    if ($ghost) { Note ("named but absent: " + ($ghost -join ', ')) }
    $ghost.Count -eq 0
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
# A green suite proves nothing on its own: a test can be green because the mod is right, or green
# because it never looks at anything. Run-Mutations.ps1 beside this file breaks the mod on purpose,
# one fault at a time, on a copy.
#
# All twenty-three tests here have been watched turning red. Twenty-two were reddened by a mutation
# aimed at them; the harness guard, test 1, was reddened as collateral when a translation file was
# deleted, which is the guard doing exactly its job.
#
# Two of them were rewritten by the campaign rather than confirmed by it:
#
#   - the stat test looked for StatDefs in Data\<folder>\Defs\StatDefs, a path that does not exist.
#     JoyGainFactor lives in Defs\Stats, so the test reported the mod's own stat as invented. It
#     now walks every Defs folder.
#   - the early exit after the well-formedness test keyed on the running failure total, so a
#     failing harness guard swallowed the whole suite. It keys on that one test now.
