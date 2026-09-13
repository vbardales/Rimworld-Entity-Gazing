using RimWorld;
using Verse;

namespace EntityGazing
{
    /// <summary>
    /// The base game's "watch a building" giver, plus a single condition: the platform must
    /// actually be holding something.
    ///
    /// This gameplay class adds only the occupancy condition; configuration lives in EntityGazingMod.
    /// Without it, naming <c>HoldingPlatform</c> in the <c>thingDefs</c> of a vanilla
    /// <c>JoyGiverDef</c> would be enough - but colonists would then go and contemplate EMPTY
    /// platforms, which is to say a steel frame with chains hanging off it. The walk, the facing
    /// and the joy gain are all the base game's own (<c>JoyGiver_WatchBuilding</c> and
    /// <c>JobDriver_WatchBuilding</c>), exactly as for a television.
    ///
    /// <c>CompEntityHolderPlatform</c> belongs to the Anomaly DLC but lives in
    /// <c>Assembly-CSharp</c> like all expansion code: the class exists even without the DLC, only
    /// its defs are missing. No reflection is needed, and the assembly loads either way.
    /// </summary>
    public class JoyGiver_WatchEntity : JoyGiver_WatchBuilding
    {
        protected override bool CanInteractWith(Pawn pawn, Thing t, bool inBed)
        {
            if (!base.CanInteractWith(pawn, t, inBed))
            {
                return false;
            }

            var held = (t as ThingWithComps)?.GetComp<CompEntityHolderPlatform>()?.HeldPawn;

            // A corpse strapped to a platform is no longer a show, it is a hygiene problem.
            return held != null && !held.Dead;
        }
    }
}
