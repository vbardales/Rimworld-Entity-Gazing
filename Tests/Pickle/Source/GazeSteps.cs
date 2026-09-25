using System;
using System.Linq;
using RimWorld;
using RimWorks.Pickle;
using Verse;
using Verse.AI;

namespace EntityGazing.PickleSteps
{
    /// <summary>
    /// The mod's actual behaviour, asked of a running game.
    ///
    /// The giver is called directly rather than waited for. A scenario that sets a need low and
    /// hopes the colonist chooses this activity within N ticks is at the mercy of the schedule, the
    /// pathing and every other joy source on the map: it fails for reasons that are not the mod's,
    /// and its green says almost nothing. Asking the giver on a real map, with a real holder and a
    /// real pawn, exercises exactly the code this mod owns and the vanilla code it hands work to,
    /// and it does so deterministically.
    /// </summary>
    [PickleSteps]
    public class GazeSteps
    {
        /// <summary>
        /// The holder is given to the player before it is spawned, and that is not cosmetic.
        /// ListerBuildings.Add sorts a building into allBuildingsColonist or allBuildingsNonColonist
        /// on its faction at SpawnSetup, once. JoyUtility.JoyKindsOnMapTempList walks only the
        /// colonist list, so a factionless holder is invisible to the recreation-types readout even
        /// though the giver, which scans by def, still finds it. That split cost three scenarios on
        /// the second run: "offered as entity gazing" red while "sends a colonist to it" was green.
        /// Setting the faction after the spawn would not do - the lister is not re-sorted.
        /// </summary>
        [Given("Entity Gazing spawns a {string}")]
        public void SpawnHolder(PickleContext ctx, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            var thing = ThingMaker.MakeThing(def, GenStuff.DefaultStuffFor(def));
            thing.SetFactionDirect(Faction.OfPlayer);
            var building = GenSpawn.Spawn(thing, Driver.FreeCell(ctx), Driver.Map(ctx)) as Building;
            ctx.Require(building != null, $"'{defName}' did not spawn as a Building");
            ctx.Require(Driver.Map(ctx).listerBuildings.allBuildingsColonist.Contains(building),
                $"'{defName}' spawned but did not enter the colonist building list");
            ctx.Set(new Driver.SpawnedHolder { Thing = building });
        }

        /// <summary>
        /// The entity is generated and put straight into the holder, never spawned on the map
        /// first. Spawning it and then transferring raised "Can't transfer items to or from Maps
        /// directly": a map is not a container you can move a thing out of by that call.
        /// </summary>
        [Given("Entity Gazing tethers a downed {string} to it")]
        public void Tether(PickleContext ctx, string kindName)
        {
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindName}'");
            var entity = PawnGenerator.GeneratePawn(new PawnGenerationRequest(kind, null,
                forceGenerateNewPawn: true));
            // forceDowned is the 1.6 field; forceIncap is gone. A tethered entity has to be down.
            entity.health.forceDowned = true;

            var holder = Driver.Holder(ctx);
            var accepted = holder.Container.TryAdd(entity, canMergeWithExistingStacks: false);
            ctx.Require(accepted, $"the holder refused to accept '{kindName}'");
            ctx.Assert(holder.HeldPawn != null, "the holder accepted the entity but holds nothing");
        }

        [Given("Entity Gazing spawns the colonist {string} with no recreation")]
        public void SpawnColonist(PickleContext ctx, string name)
        {
            var pawn = PawnGenerator.GeneratePawn(new PawnGenerationRequest(
                PawnKindDefOf.Colonist, Faction.OfPlayer, forceGenerateNewPawn: true));
            pawn.Name = new NameSingle(name);
            GenSpawn.Spawn(pawn, Driver.FreeCell(ctx), Driver.Map(ctx));
            pawn.needs.AddOrRemoveNeedsAsAppropriate();
            ctx.Require(pawn.needs?.joy != null, $"'{name}' has no recreation need");
            pawn.needs.joy.CurLevel = 0f;
        }

        [When("Entity Gazing asks the giver for a job for {string}")]
        public void AskGiver(PickleContext ctx, string name)
        {
            var job = Driver.Giver(ctx).TryGiveJob(Driver.PawnNamed(ctx, name));
            ctx.Set(new Driver.OfferedJob { Job = job });
        }

        [Then("Entity Gazing the giver offers a gazing job")]
        public void OffersJob(PickleContext ctx)
        {
            var job = ctx.Get<Driver.OfferedJob>()?.Job;
            ctx.Assert(job != null, "the giver offered no job at all");
            ctx.Assert(job.def?.defName == "EG_WatchEntity",
                $"the giver offered '{job.def?.defName ?? "null"}' instead of EG_WatchEntity");
            ctx.Assert(job.targetA.Thing == Driver.HolderThing(ctx),
                $"the job targets '{job.targetA.Thing?.def?.defName ?? "nothing"}' rather than the spawned holder");
        }

        [Then("Entity Gazing the giver offers nothing")]
        public void OffersNothing(PickleContext ctx)
        {
            var job = ctx.Get<Driver.OfferedJob>()?.Job;
            ctx.Assert(job == null,
                $"the giver offered '{job?.def?.defName}' where it should have offered nothing");
        }

        [When("Entity Gazing {string} starts the offered job")]
        public void StartJob(PickleContext ctx, string name)
        {
            var job = ctx.Get<Driver.OfferedJob>()?.Job;
            ctx.Require(job != null, "there is no offered job to start");
            Driver.PawnNamed(ctx, name).jobs.StartJob(job, JobCondition.InterruptForced);
        }

        [Then("Entity Gazing {string} is watching the holder")]
        public void IsWatching(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var current = pawn.CurJob;
            ctx.Assert(current != null && current.def.defName == "EG_WatchEntity",
                $"'{name}' is doing '{current?.def?.defName ?? "nothing"}' rather than EG_WatchEntity");
        }

        [Then("Entity Gazing {string} stands {int} to {int} cells from the holder")]
        public void StandsWithin(PickleContext ctx, string name, int low, int high)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            var distance = pawn.Position.DistanceTo(Driver.HolderThing(ctx).Position);
            ctx.Assert(distance >= low && distance <= high,
                $"'{name}' stands {distance:0.##} cells away, outside {low} to {high}");
        }

        [Then("Entity Gazing {string} has gained entity gazing recreation")]
        public void GainedJoy(PickleContext ctx, string name)
        {
            var pawn = Driver.PawnNamed(ctx, name);
            ctx.Assert(pawn.needs.joy.CurLevel > 0f,
                $"'{name}' still has recreation at {pawn.needs.joy.CurLevel:0.###}");
            var last = pawn.needs.joy.tolerances;
            ctx.Assert(last != null, "the recreation need carries no tolerance record");
        }

        [When("Entity Gazing the tethered entity dies")]
        public void KillHeld(PickleContext ctx)
        {
            var held = Driver.Holder(ctx).HeldPawn;
            ctx.Require(held != null, "the holder holds nothing to kill");
            held.Kill(null);
        }

        [Then("Entity Gazing {string} carries the hediff {string}")]
        public void HasHediff(PickleContext ctx, string name, string hediffDefName)
        {
            var def = DefDatabase<HediffDef>.GetNamedSilentFail(hediffDefName);
            ctx.Require(def != null, $"no HediffDef named '{hediffDefName}'");
            var pawn = Driver.PawnNamed(ctx, name);
            ctx.Assert(pawn.health.hediffSet.HasHediff(def),
                $"'{name}' carries no '{hediffDefName}' at {pawn.Position.DistanceTo(Driver.HolderThing(ctx).Position):0.##} cells");
        }

        [Then("Entity Gazing this map offers the entity gazing recreation type")]
        public void MapOffersKind(PickleContext ctx)
        {
            var kinds = JoyUtility.JoyKindsOnMapTempList(Driver.Map(ctx));
            ctx.Assert(kinds.Contains(Driver.GazingKind(ctx)),
                "entity gazing is not among the recreation types this map offers: "
                + string.Join(", ", kinds.Select(k => k.defName).ToArray()));
        }

        /// <summary>
        /// Proves the patched range reaches the vanilla utility that places watchers, on a real map
        /// with a real rotation. The out-of-game suite proves the number is written into the def;
        /// only this proves the game computes cells from it.
        ///
        /// The range is measured along the facing axis, not as a straight line. WatchBuildingUtility
        /// builds a rect per cardinal direction: the distance range runs along that direction and
        /// watchBuildingStandRectWidth spreads sideways, so the far corner of a 2~6 range in a rect
        /// 5 wide sits at sqrt(6^2 + 2^2) = 6.32 cells. The second run failed this assertion three
        /// times on exactly that corner while measuring a euclidean distance - the mod was right and
        /// the yardstick was wrong. Both holders are rotatable=false, so all four rects exist and
        /// the axial component of an offset is whichever of its two parts is larger.
        /// </summary>
        [Then("Entity Gazing the watch cells lie {int} to {int} cells along the facing axis")]
        public void WatchCellsWithin(PickleContext ctx, int low, int high)
        {
            var holder = Driver.HolderThing(ctx);
            var cells = WatchBuildingUtility
                .CalculateWatchCells(holder.def, holder.Position, holder.Rotation, Driver.Map(ctx))
                .ToList();
            ctx.Assert(cells.Count > 0, "the game computed no watch cell at all for this holder");

            var halfWidth = holder.def.building.watchBuildingStandRectWidth / 2;
            var worst = IntVec3.Invalid;
            var nearest = int.MaxValue;
            var furthest = int.MinValue;
            foreach (var cell in cells)
            {
                var offset = cell - holder.Position;
                var axial = Math.Max(Math.Abs(offset.x), Math.Abs(offset.z));
                var lateral = Math.Min(Math.Abs(offset.x), Math.Abs(offset.z));
                if (axial < nearest) nearest = axial;
                if (axial > furthest) furthest = axial;
                if (lateral > halfWidth && !worst.IsValid) worst = cell;
            }

            ctx.Assert(!worst.IsValid,
                $"a watch cell at {worst} sits more than {halfWidth} cells to the side of a holder "
                + $"whose rect is {holder.def.building.watchBuildingStandRectWidth} wide");
            ctx.Assert(nearest >= low && furthest <= high,
                $"watch cells span {nearest} to {furthest} cells along the facing axis, "
                + $"outside {low} to {high}");
        }

        /// <summary>
        /// A holder left standing outlives the scenario and changes what the next one measures.
        ///
        /// The try/catch is not decoration. ctx.Get throws when the scenario never stored a holder,
        /// and a teardown hook that throws fails the scenario it was cleaning up after. The first
        /// run of this suite lost ten scenarios to exactly that - every one of them a scenario that
        /// spawns nothing, all reported as "Exception has been thrown by the target of an
        /// invocation", with nothing in the message to say which step or hook was at fault.
        /// </summary>
        [AfterScenario]
        public void Cleanup(PickleContext ctx)
        {
            Driver.SpawnedHolder stored;
            try { stored = ctx.Get<Driver.SpawnedHolder>(); }
            catch { return; }
            var holder = stored?.Thing;
            if (holder != null && holder.Spawned) holder.Destroy(DestroyMode.Vanish);
        }
    }
}
