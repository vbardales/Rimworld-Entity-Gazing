using System.Linq;
using RimWorld;
using RimWorks.Pickle;
using UnityEngine;
using Verse;

namespace EntityGazing.PickleSteps
{
    /// <summary>
    /// The one half of the patch that only an image can show.
    ///
    /// PlaceWorker_WatchArea overrides DrawGhost and nothing else, so it draws while a holder is
    /// being PLACED, never once it is built and selected. The chain is Designator_Place
    /// .SelectedUpdate -> DrawGhost -> GhostDrawer.DrawGhostThing(UI.MouseCell(), ...,
    /// drawPlaceWorkers: true), which means two things this scenario has to arrange: the build
    /// designator must be the selected one, and the pointer must be over the cell we want.
    ///
    /// The out-of-game suite proves the place worker is on both defs and that the patch put it
    /// there. It cannot prove anything is drawn, which is why this exists and why it ends in a
    /// capture a person reads rather than an assertion.
    /// </summary>
    [PickleSteps]
    public class PlaceWorkerSteps
    {
        [When("Entity Gazing holds the build designator for {string}")]
        public void HoldDesignator(PickleContext ctx, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            ctx.Require(def.BuildableByPlayer, $"'{defName}' is not something the player can build");

            var designator = new Designator_Build(def);
            if (def.MadeFromStuff) designator.SetStuffDef(GenStuff.DefaultStuffFor(def));
            Find.DesignatorManager.Select(designator);

            ctx.Assert(Find.DesignatorManager.SelectedDesignator == designator,
                "the build designator was not taken up by the designator manager");
        }

        /// <summary>
        /// Everything the game needs in order to draw the watch area, asserted before the shutter,
        /// so that a capture showing nothing is told apart from a capture of the wrong cell.
        ///
        /// The mouse cell is the part worth checking rather than assuming. This harness runs under
        /// Xvfb with nothing moving the pointer, and the watch area is drawn wherever UI.MouseCell
        /// says - so if that is not the cell the camera was moved to, the picture is of an empty
        /// corner of the map and the scenario would still be green.
        /// </summary>
        [Then("Entity Gazing the game is about to draw a watch area at the pointer")]
        public void AboutToDraw(PickleContext ctx)
        {
            var designator = Find.DesignatorManager.SelectedDesignator as Designator_Build;
            ctx.Require(designator != null, "no build designator is selected");

            var def = designator.PlacingDef as ThingDef;
            ctx.Require(def != null, "the selected designator is not placing a ThingDef");
            ctx.Assert(def.placeWorkers != null && def.placeWorkers.Contains(typeof(PlaceWorker_WatchArea)),
                $"'{def.defName}' carries no PlaceWorker_WatchArea, so nothing would draw a watch area");

            var map = Driver.Map(ctx);
            var pointer = UI.MouseCell();
            ctx.Assert(pointer.InBounds(map),
                $"the pointer is at {pointer}, outside the map: Designator_Place.SelectedUpdate "
                + "returns before drawing anything, and the capture would show no watch area");

            var centre = Find.CameraDriver.MapPosition;
            ctx.Assert((pointer - centre).LengthHorizontalSquared <= 4,
                $"the pointer is at {pointer} but the camera is on {centre}. The watch area is drawn "
                + "at the pointer, so the capture would frame one cell and draw the area on another.");

            // Rot4.North rather than the designator's own rotation, which is a protected field this
            // suite will not reach for: it touches only public game API, like the mod it tests.
            // Nothing is lost by it here. Both holders are rotatable=false, and
            // CalculateAllowedDirections answers every non-rotatable def with all four directions
            // whatever rotation it is handed.
            ctx.Require(!def.rotatable,
                $"'{def.defName}' is rotatable, so this step's Rot4.North is no longer a safe stand-in "
                + "for the rotation the designator actually holds");

            var cells = WatchBuildingUtility
                .CalculateWatchCells(def, pointer, Rot4.North, map)
                .ToList();
            ctx.Assert(cells.Count > 0,
                $"the game computes no watch cell at {pointer}, so the place worker would draw an "
                + "empty outline there even though it is on the def");
        }

        [AfterScenario]
        public void Deselect(PickleContext ctx)
        {
            try { Find.DesignatorManager?.Deselect(); }
            catch (System.Exception e)
            {
                Log.Warning($"[Entity Gazing] the build designator could not be deselected: {e.Message}");
            }
        }
    }
}
