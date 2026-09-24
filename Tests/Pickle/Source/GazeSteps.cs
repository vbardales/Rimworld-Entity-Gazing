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
        [Given("Entity Gazing spawns a {string}")]
        public void SpawnHolder(PickleContext ctx, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Require(def != null, $"no ThingDef named '{defName}'");
            var thing = ThingMaker.MakeThing(def, GenStuff.DefaultStuffFor(def));
            var building = GenSpawn.Spawn(thing, Driver.FreeCell(ctx), Driver.Map(ctx)) as Building;
            ctx.Require(building != null, $"'{defName}' did not spawn as a Building");
            ctx.Set(new Driver.SpawnedHolder { Thing = building });
        }

        [Given("Entity Gazing tethers a downed {string} to it")]
        public void Tether(PickleContext ctx, string kindName)
        {
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(kindName);
            ctx.Require(kind != null, $"no PawnKindDef named '{kindName}'");
            var entity = PawnGenerator.GeneratePawn(new PawnGenerationRequest(kind, null,
                forceGenerateNewPawn: true));
            GenSpawn.Spawn(entity, Driver.FreeCell(ctx), Driver.Map(ctx));
            // forceDowned is the 1.6 field; forceIncap is gone. A tethered entity has to be down.
            entity.health.forceDowned = true;

            var holder = Driver.Holder(ctx);
            var accepted = holder.Container.TryAddOrTransfer(entity, canMergeWithExistingStacks: false);
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
        /// </summary>
        [Then("Entity Gazing the watch cells lie {int} to {int} cells from the holder")]
        public void WatchCellsWithin(PickleContext ctx, int low, int high)
        {
            var holder = Driver.HolderThing(ctx);
            var cells = WatchBuildingUtility
                .CalculateWatchCells(holder.def, holder.Position, holder.Rotation, Driver.Map(ctx))
                .ToList();
            ctx.Assert(cells.Count > 0, "the game computed no watch cell at all for this holder");
            var nearest = cells.Min(c => c.DistanceTo(holder.Position));
            var furthest = cells.Max(c => c.DistanceTo(holder.Position));
            ctx.Assert(nearest >= low && furthest <= high,
                $"watch cells span {nearest:0.##} to {furthest:0.##} cells, outside {low} to {high}");
        }

        [AfterScenario]
        public void Cleanup(PickleContext ctx)
        {
            // A holder left tethered outlives the scenario and changes what the next one measures.
            var holder = ctx.Get<Driver.SpawnedHolder>()?.Thing;
            if (holder != null && holder.Spawned) holder.Destroy(DestroyMode.Vanish);
        }
    }
}
