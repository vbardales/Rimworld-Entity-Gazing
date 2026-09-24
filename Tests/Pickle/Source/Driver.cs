using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using RimWorld;
using RimWorks.Pickle;
using Verse;

namespace EntityGazing.PickleSteps
{
    /// <summary>
    /// Shared lookups for this suite. Everything here reaches for state the running game owns: a
    /// map, a spawned holder, the mod instance. None of it can be reached from an out-of-game test,
    /// which is the whole reason these scenarios exist rather than living in _tools/.
    /// </summary>
    public static class Driver
    {
        internal const BindingFlags InstanceAny =
            BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;

        /// <summary>
        /// Scenario-local state. Pickle keys it by type, not by string, so each piece needs a type
        /// of its own. Reacquired after a load: references taken before one are stale.
        /// </summary>
        internal sealed class SpawnedHolder { public Building Thing; }

        /// <summary>Wraps the job so that "the giver offered nothing" is still a stored answer.</summary>
        internal sealed class OfferedJob { public Verse.AI.Job Job; }

        public static Map Map(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null,
                "no current map: load a fixture before this step");
            return Find.CurrentMap;
        }

        public static EntityGazingMod Mod(PickleContext ctx)
        {
            var mod = LoadedModManager.GetMod<EntityGazingMod>();
            ctx.Require(mod != null, "EntityGazingMod is not loaded in this process");
            return mod;
        }

        public static EntityGazingSettings Settings(PickleContext ctx)
        {
            var settings = Mod(ctx).Settings;
            ctx.Require(settings != null, "EntityGazingMod.Settings is null");
            return settings;
        }

        public static Building HolderThing(PickleContext ctx)
        {
            var holder = ctx.Get<SpawnedHolder>()?.Thing;
            ctx.Require(holder != null, "no holder has been spawned in this scenario");
            ctx.Require(holder.Spawned, $"the holder '{holder.def.defName}' is no longer spawned");
            return holder;
        }

        /// <summary>
        /// The comp both holders carry. Reached through the comp rather than through
        /// Building_HoldingPlatform so the two defs are handled by one path.
        /// </summary>
        public static CompEntityHolder Holder(PickleContext ctx)
        {
            var comp = HolderThing(ctx).TryGetComp<CompEntityHolderPlatform>();
            ctx.Require(comp != null,
                "the spawned holder carries no CompEntityHolderPlatform: Anomaly may be absent");
            return comp;
        }

        public static Pawn PawnNamed(PickleContext ctx, string name)
        {
            IReadOnlyList<Pawn> pawns = Map(ctx).mapPawns.AllPawnsSpawned;
            var pawn = pawns.FirstOrDefault(p =>
                (p.Name is NameSingle single && single.Name == name) || p.LabelShort == name);
            ctx.Require(pawn != null, $"no spawned pawn named '{name}'");
            return pawn;
        }

        public static JoyGiver Giver(PickleContext ctx)
        {
            var def = DefDatabase<JoyGiverDef>.GetNamedSilentFail("EG_WatchEntity");
            ctx.Require(def != null, "no JoyGiverDef named 'EG_WatchEntity'");
            var worker = def.Worker;
            ctx.Require(worker != null, "EG_WatchEntity has no worker: its giverClass did not resolve");
            return worker;
        }

        public static JoyKindDef GazingKind(PickleContext ctx)
        {
            var kind = DefDatabase<JoyKindDef>.GetNamedSilentFail("EG_EntityGazing");
            ctx.Require(kind != null, "no JoyKindDef named 'EG_EntityGazing'");
            return kind;
        }

        /// <summary>A standable cell with nothing on it, so a spawn never lands on a colonist.</summary>
        public static IntVec3 FreeCell(PickleContext ctx, IntVec3? near = null, int radius = 20)
        {
            var map = Map(ctx);
            IntVec3 cell;
            var found = CellFinder.TryFindRandomCellNear(near ?? map.Center, map, radius,
                c => c.Standable(map) && c.GetEdifice(map) == null && c.GetFirstPawn(map) == null,
                out cell);
            ctx.Require(found, "no free standable cell was found on this map");
            return cell;
        }
    }
}
