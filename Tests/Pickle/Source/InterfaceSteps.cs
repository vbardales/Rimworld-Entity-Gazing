using System;
using System.Linq;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace EntityGazing.PickleSteps
{
    /// <summary>
    /// The settings window, the optional shortcut and the keyed texts, in the language this pass
    /// runs. The out-of-game suite proves the settings class normalizes, resets and survives
    /// Scribe; none of that opens a window, and none of it says the text fits or that both routes
    /// reach the same instance.
    /// </summary>
    [PickleSteps]
    public class InterfaceSteps
    {
        private const string ShortcutDefName = "EG_Settings";
        private const string KeyPrefix = "EG_";

        private static MainButtonDef Shortcut(PickleContext ctx)
        {
            var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(ShortcutDefName);
            ctx.Require(def != null, $"no MainButtonDef named '{ShortcutDefName}'");
            return def;
        }

        private static Dialog_ModSettings OpenDialog(PickleContext ctx)
        {
            var dialog = Find.WindowStack.Windows.OfType<Dialog_ModSettings>().FirstOrDefault();
            ctx.Require(dialog != null, "no Dialog_ModSettings is open");
            return dialog;
        }

        // --- settings -------------------------------------------------------------------------

        [Then("Entity Gazing setting {string} reads {int}")]
        public void SettingReads(PickleContext ctx, string field, int expected)
        {
            var settings = Driver.Settings(ctx);
            int actual;
            switch (field)
            {
                case "minimumDistance": actual = settings.minimumDistance; break;
                case "maximumDistance": actual = settings.maximumDistance; break;
                default:
                    ctx.Require(false, $"this suite knows no setting named '{field}'");
                    return;
            }
            ctx.Assert(actual == expected, $"'{field}' reads {actual}, expected {expected}");
        }

        [When("Entity Gazing sets the distances to {int} and {int}")]
        public void SetDistances(PickleContext ctx, int minimum, int maximum)
        {
            var settings = Driver.Settings(ctx);
            settings.minimumDistance = minimum;
            settings.maximumDistance = maximum;
            Driver.Mod(ctx).ApplySettings();
        }

        [When("Entity Gazing opens its settings window")]
        public void OpenSettings(PickleContext ctx)
        {
            Find.WindowStack.Add(new Dialog_ModSettings(Driver.Mod(ctx)));
        }

        [Then("Entity Gazing sees its own settings window open")]
        public void SeesOwnDialog(PickleContext ctx)
        {
            var dialog = OpenDialog(ctx);
            var field = typeof(Dialog_ModSettings).GetFields(Driver.InstanceAny)
                .FirstOrDefault(f => typeof(Verse.Mod).IsAssignableFrom(f.FieldType));
            ctx.Require(field != null, "Dialog_ModSettings has no Mod-typed field in this game build");
            var mod = field.GetValue(dialog) as Verse.Mod;
            ctx.Assert(mod is EntityGazingMod,
                $"the open settings window belongs to '{mod?.GetType().Name ?? "nothing"}'");
        }

        /// <summary>
        /// The two routes have to reach the same instance, not merely two windows that look alike.
        /// A shortcut that opened a second Mod object would show stale values and save over them.
        /// </summary>
        [Then("Entity Gazing the open window edits the same settings instance")]
        public void SameInstance(PickleContext ctx)
        {
            var dialog = OpenDialog(ctx);
            var field = typeof(Dialog_ModSettings).GetFields(Driver.InstanceAny)
                .FirstOrDefault(f => typeof(Verse.Mod).IsAssignableFrom(f.FieldType));
            var mod = field.GetValue(dialog) as EntityGazingMod;
            ctx.Assert(mod != null, "the open settings window does not belong to Entity Gazing");
            ctx.Assert(ReferenceEquals(mod.Settings, Driver.Settings(ctx)),
                "the window edits a different settings object than the one the mod applies");
        }

        [Then("Entity Gazing the holders carry a watch range of {int} to {int}")]
        public void HoldersCarryRange(PickleContext ctx, int low, int high)
        {
            foreach (var defName in new[] { "HoldingPlatform", "HoldingSpot" })
            {
                var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
                ctx.Require(def?.building != null, $"'{defName}' has no building block");
                var range = def.building.watchBuildingStandDistanceRange;
                ctx.Assert(range.min == low && range.max == high,
                    $"'{defName}' carries {range.min}~{range.max}, expected {low}~{high}");
            }
        }

        // --- the optional shortcut ------------------------------------------------------------

        [Then("Entity Gazing the shortcut is hidden on a clean configuration")]
        public void ShortcutHidden(PickleContext ctx)
        {
            var def = Shortcut(ctx);
            ctx.Assert(!def.buttonVisible && !def.Worker.Visible,
                $"the shortcut is visible with buttonVisible={def.buttonVisible} and Worker.Visible={def.Worker.Visible}");
        }

        [When("Entity Gazing reveals its shortcut as a customization mod would")]
        public void Reveal(PickleContext ctx) => Shortcut(ctx).buttonVisible = true;

        [When("Entity Gazing hides its shortcut again")]
        public void Hide(PickleContext ctx) => Shortcut(ctx).buttonVisible = false;

        [Then("Entity Gazing the shortcut is drawn and enabled")]
        public void ShortcutDrawn(PickleContext ctx)
        {
            var worker = Shortcut(ctx).Worker;
            ctx.Assert(worker.Visible, "the revealed shortcut is still not drawn");
            ctx.Assert(!worker.Disabled, "the revealed shortcut is greyed out");
        }

        [When("Entity Gazing activates its shortcut")]
        public void Activate(PickleContext ctx) => Shortcut(ctx).Worker.Activate();

        // --- translation ----------------------------------------------------------------------

        /// <summary>
        /// Against the language the pass was started in, never a language switched mid-run: that
        /// reloads every def under the runner.
        /// </summary>
        [Then("Entity Gazing every keyed text exists in the language this pass runs")]
        public void EveryKey(PickleContext ctx)
        {
            var active = LanguageDatabase.activeLanguage;
            ctx.Require(active != null, "no active language is loaded");
            var keys = LanguageDatabase.defaultLanguage.keyedReplacements.Keys
                .Where(k => k.StartsWith(KeyPrefix)).ToList();
            ctx.Assert(keys.Count >= 5,
                $"only {keys.Count} English keys start with '{KeyPrefix}', expected at least 5");
            var missing = keys.Where(k => !active.HaveTextForKey(k)).ToList();
            ctx.Assert(missing.Count == 0,
                $"{active.folderName} has no text for: {string.Join(", ", missing.ToArray())}");
        }

        [Then("Entity Gazing the recreation type is named in the language this pass runs")]
        public void KindLabelled(PickleContext ctx)
        {
            var kind = Driver.GazingKind(ctx);
            ctx.Assert(!kind.label.NullOrEmpty(), "the recreation type carries no label");
            var job = DefDatabase<JobDef>.GetNamedSilentFail("EG_WatchEntity");
            ctx.Require(job != null, "no JobDef named 'EG_WatchEntity'");
            ctx.Assert(!job.reportString.NullOrEmpty(), "the job carries no report string");
        }

        // --- teardown -------------------------------------------------------------------------

        /// <summary>
        /// Wrapped for the same reason as the holder cleanup in GazeSteps, and this one matters
        /// more: it runs after every scenario in the suite, not only those that spawned something.
        /// Anything escaping it would redden a scenario whose own steps all passed, and Pickle
        /// would name neither the hook nor the line.
        /// </summary>
        [AfterScenario]
        public void Restore(PickleContext ctx)
        {
            try
            {
                var def = DefDatabase<MainButtonDef>.GetNamedSilentFail(ShortcutDefName);
                if (def != null) def.buttonVisible = false;

                // Distances are global and outlive the scenario: a pass that left 9~12 behind would
                // change what every later scenario measures, and the failure would look like the mod's.
                var mod = LoadedModManager.GetMod<EntityGazingMod>();
                if (mod?.Settings != null)
                {
                    mod.Settings.ResetDefaults();
                    mod.ApplySettings();
                }
            }
            catch (Exception e)
            {
                Log.Warning($"[Entity Gazing] the scenario's interface state could not be restored: {e.Message}");
            }
        }
    }
}
