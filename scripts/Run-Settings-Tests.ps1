param([string]$Managed = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$resolver = [ResolveEventHandler]{ param($sender,$event)
    $name = $event.Name.Split(',')[0] + '.dll'
    foreach ($dir in @($Managed, (Join-Path $root 'Mod\Assemblies'))) {
        $path = Join-Path $dir $name
        if (Test-Path $path) { return [Reflection.Assembly]::LoadFrom($path) }
    }
    return $null
}
[AppDomain]::CurrentDomain.add_AssemblyResolve($resolver)
[void][Reflection.Assembly]::LoadFrom((Join-Path $Managed 'Assembly-CSharp.dll'))
[void][Reflection.Assembly]::LoadFrom((Join-Path $root 'Mod\Assemblies\EntityGazing.dll'))
$script:passed = 0
function Check([string]$name, [scriptblock]$test) {
    if (-not (& $test)) { throw "FAIL: $name" }
    $script:passed++
    Write-Output "PASS: $name"
}
$s = New-Object EntityGazing.EntityGazingSettings
Check 'clean defaults are 2 to 6' { $s.minimumDistance -eq 2 -and $s.maximumDistance -eq 6 }
foreach ($case in @(@(-99,99,1,20),@(20,1,20,20),@(7,12,7,12),@(99,-99,20,20),@(1,1,1,1))) {
    $s.minimumDistance=$case[0]; $s.maximumDistance=$case[1]; $s.Normalize()
    Check "normalize $($case[0]),$($case[1])" { $s.minimumDistance -eq $case[2] -and $s.maximumDistance -eq $case[3] }
}
$a = [Runtime.Serialization.FormatterServices]::GetUninitializedObject([Verse.ThingDef])
$ap = New-Object RimWorld.BuildingProperties
[Verse.ThingDef].GetField("building").SetValue($a,$ap)
$b = [Runtime.Serialization.FormatterServices]::GetUninitializedObject([Verse.ThingDef])
$bp = New-Object RimWorld.BuildingProperties
[Verse.ThingDef].GetField("building").SetValue($b,$bp)
$s.minimumDistance=7; $s.maximumDistance=12
$s.ApplyTo($a); $s.ApplyTo($b)
Check 'both holder defs receive the changed range' {
    $ap.watchBuildingStandDistanceRange.min -eq 7 -and $ap.watchBuildingStandDistanceRange.max -eq 12 -and
    $bp.watchBuildingStandDistanceRange.min -eq 7 -and $bp.watchBuildingStandDistanceRange.max -eq 12
}
$s.ApplyTo($null)
$s.ApplyTo(([Runtime.Serialization.FormatterServices]::GetUninitializedObject([Verse.ThingDef])))
Check 'missing DLC targets are safe' { $true }
$s.ResetDefaults(); $s.ApplyTo($a); $s.ApplyTo($b)
Check 'reset restores actual holder values' { $ap.watchBuildingStandDistanceRange.min -eq 2 -and $bp.watchBuildingStandDistanceRange.max -eq 6 }
$scratch=Join-Path $root '.build\settings-tests'
[void][IO.Directory]::CreateDirectory($scratch)
$save=Join-Path $scratch 'roundtrip.xml'
$s.minimumDistance=8; $s.maximumDistance=14
[Verse.Scribe]::saver.InitSaving($save,'settings')
$s.ExposeData()
[Verse.Scribe]::saver.FinalizeSaving()
$loaded=New-Object EntityGazing.EntityGazingSettings
[Verse.Scribe]::loader.InitLoading($save)
$loaded.ExposeData()
# Primitive settings have no cross references or post-load callbacks. Full finalization invokes Unity; test LoadingVars here.
[Verse.Scribe]::loader.ForceStop()
Check 'native Scribe save and LoadingVars preserve both settings' { $loaded.minimumDistance -eq 8 -and $loaded.maximumDistance -eq 14 }
[IO.File]::WriteAllText($save, '<settings />')
[Verse.Scribe]::loader.InitLoading($save)
$loaded.ExposeData()
# Primitive settings have no cross references or post-load callbacks. Full finalization invokes Unity; test LoadingVars here.
[Verse.Scribe]::loader.ForceStop()
Check 'missing saved fields use defaults' { $loaded.minimumDistance -eq 2 -and $loaded.maximumDistance -eq 6 }
[IO.File]::WriteAllText($save, '<settings><minimumDistance>99</minimumDistance><maximumDistance>-8</maximumDistance></settings>')
[Verse.Scribe]::loader.InitLoading($save)
$loaded.ExposeData()
[Verse.Scribe]::loader.ForceStop()
Check 'out-of-range saved values are normalized on loading' { $loaded.minimumDistance -eq 20 -and $loaded.maximumDistance -eq 20 }
$button=[xml](Get-Content (Join-Path $root 'Mod\Defs\SettingsButton.xml') -Raw)
Check 'shortcut is hidden by its native def, without a visibility override' {
    $button.Defs.MainButtonDef.buttonVisible -ceq 'false' -and
    -not [EntityGazing.MainButtonWorker_EntityGazingSettings].GetMethod('get_Visible',[Reflection.BindingFlags]'DeclaredOnly,Public,Instance')
}
$code=Get-Content (Join-Path $root 'Source\EntityGazingMod.cs') -Raw
$en=[xml](Get-Content (Join-Path $root 'Mod\Languages\English\Keyed\Settings.xml') -Raw)
$fr=[xml](Get-Content (Join-Path $root 'Mod\Languages\French\Keyed\Settings.xml') -Raw)
$keys=@([regex]::Matches($code,'"(EG_[A-Za-z]+)"\.Translate\(') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
foreach($key in $keys) {
    Check "EN/FR coverage and parameters: $key" {
        $e=@($en.SelectNodes("/LanguageData/$key")); $f=@($fr.SelectNodes("/LanguageData/$key"))
        $e.Count -eq 1 -and $f.Count -eq 1 -and $e[0].InnerText.Trim() -and $f[0].InnerText.Trim() -and
        (([regex]::Matches($e[0].InnerText,'\{\d+\}') | ForEach-Object Value) -join ',') -ceq
        (([regex]::Matches($f[0].InnerText,'\{\d+\}') | ForEach-Object Value) -join ',')
    }
}
Write-Output "$script:passed settings checks passed"
[AppDomain]::CurrentDomain.remove_AssemblyResolve($resolver)
