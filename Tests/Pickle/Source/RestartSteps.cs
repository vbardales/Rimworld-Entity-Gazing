using System;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace EntityGazing.PickleSteps
{
    /// <summary>
    /// The two halves of the restart test, and the one guard that makes it a restart test.
    ///
    /// A settings value that is global rather than per save cannot be proved to survive the game
    /// being closed by a scenario that never closes it: the value is still sitting in the same
    /// EntityGazingSettings instance, and a reader in that process reads memory while appearing to
    /// read the disk. So the reader refuses to pass when the writer ran here, and says so. That is
    /// RimmsqolSteps' design, borrowed because it is the only one that cannot be fooled by the
    /// cheap version of this test.
    ///
    /// The launcher supplies the other half: -Filter 11-restart-write -Then 12-restart-read takes
    /// the machine lock once, stages once, and launches the game twice. Two queue tickets would not
    /// do - any run that stages this mod in between rewrites the settings file the first launch
    /// left for the second.
    /// </summary>
    [PickleSteps]
    public class RestartSteps
    {
        /// <summary>
        /// Set by the writer, read by the reader, never serialized. Its whole job is to be false in
        /// the second process: a static lives as long as the assembly, so the only way the reader
        /// sees it false is a genuinely new game.
        /// </summary>
        private static bool wroteInThisProcess;

        /// <summary>
        /// Stands the teardown down for this scenario. InterfaceSteps.Restore puts the distances
        /// back after every scenario, which is right for all the others and fatal here: the writer
        /// exists precisely to leave values behind. The reader turns it back on.
        /// </summary>
        internal static bool KeepSettings { get; private set; }

        [When("Entity Gazing keeps its distances for the next launch")]
        public void Keep(PickleContext ctx)
        {
            var mod = Driver.Mod(ctx);
            mod.WriteSettings();
            wroteInThisProcess = true;
            KeepSettings = true;
        }

        [Given("Entity Gazing the distances kept by the previous launch are in place")]
        public void KeptByPreviousLaunch(PickleContext ctx)
        {
            ctx.Assert(!wroteInThisProcess,
                "the writer ran in THIS process, so nothing here was read back from disk: this is a "
                + "restart test that never restarted. Play the pair with -Filter 11-restart-write "
                + "-Then 12-restart-read, which launches the game twice under one lock.");
            KeepSettings = false;
        }

        /// <summary>
        /// The file the game actually holds, not the instance in memory. A reader that only asked
        /// the settings object would pass on a default it never loaded.
        ///
        /// The name is built the way LoadedModManager builds it - the mod's folder name and the
        /// MOD class's type name, not the settings class's. Reading Verse.Mod.GetSettings rather
        /// than guessing is what avoids looking for Mod_..._EntityGazingSettings.xml, which never
        /// exists and would fail as "no settings file" whatever the mod had written.
        /// </summary>
        [Then("Entity Gazing its settings file records {int} and {int}")]
        public void FileRecords(PickleContext ctx, int minimum, int maximum)
        {
            var mod = Driver.Mod(ctx);
            var path = System.IO.Path.Combine(GenFilePaths.ConfigFolderPath,
                GenText.SanitizeFilename($"Mod_{mod.Content.FolderName}_{mod.GetType().Name}.xml"));
            ctx.Require(System.IO.File.Exists(path), $"no settings file at '{path}'");

            var text = System.IO.File.ReadAllText(path);
            ctx.Assert(text.Contains($"<minimumDistance>{minimum}</minimumDistance>")
                    && text.Contains($"<maximumDistance>{maximum}</maximumDistance>"),
                $"the settings file does not record {minimum} and {maximum}. It holds: {text}");
        }
    }
}
