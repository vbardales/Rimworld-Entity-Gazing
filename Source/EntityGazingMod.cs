using System;
using RimWorld;
using UnityEngine;
using Verse;

namespace EntityGazing
{
    public sealed class EntityGazingSettings : ModSettings
    {
        public int minimumDistance = 2;
        public int maximumDistance = 6;

        public void Normalize()
        {
            minimumDistance = Math.Max(1, Math.Min(20, minimumDistance));
            maximumDistance = Math.Max(minimumDistance, Math.Min(20, maximumDistance));
        }

        public void ResetDefaults()
        {
            minimumDistance = 2;
            maximumDistance = 6;
        }

        public void ApplyTo(ThingDef holder)
        {
            Normalize();
            if (holder?.building != null)
                holder.building.watchBuildingStandDistanceRange = new IntRange(minimumDistance, maximumDistance);
        }

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref minimumDistance, "minimumDistance", 2);
            Scribe_Values.Look(ref maximumDistance, "maximumDistance", 6);
            Normalize();
        }
    }

    public sealed class EntityGazingMod : Mod
    {
        public static EntityGazingMod Instance { get; private set; }
        public EntityGazingSettings Settings { get; }

        public EntityGazingMod(ModContentPack content) : base(content)
        {
            Instance = this;
            Settings = GetSettings<EntityGazingSettings>();
            LongEventHandler.ExecuteWhenFinished(ApplySettings);
        }

        public override string SettingsCategory() => "EG_SettingsTitle".Translate();

        public void ApplySettings()
        {
            Settings.ApplyTo(DefDatabase<ThingDef>.GetNamedSilentFail("HoldingPlatform"));
            Settings.ApplyTo(DefDatabase<ThingDef>.GetNamedSilentFail("HoldingSpot"));
        }

        public override void WriteSettings()
        {
            ApplySettings();
            base.WriteSettings();
        }

        public override void DoSettingsWindowContents(Rect inRect)
        {
            var listing = new Listing_Standard();
            listing.Begin(inRect);
            listing.Label("EG_SettingsHelp".Translate());
            listing.Gap();
            listing.Label("EG_MinimumDistance".Translate(Settings.minimumDistance));
            int minimum = (int)Math.Round(listing.Slider(Settings.minimumDistance, 1, 20));
            listing.Label("EG_MaximumDistance".Translate(Settings.maximumDistance));
            int maximum = (int)Math.Round(listing.Slider(Settings.maximumDistance, minimum, 20));
            if (minimum != Settings.minimumDistance || maximum != Settings.maximumDistance)
            {
                Settings.minimumDistance = minimum;
                Settings.maximumDistance = maximum;
                ApplySettings();
            }
            listing.Gap();
            if (listing.ButtonText("EG_ResetDefaults".Translate()))
            {
                Settings.ResetDefaults();
                ApplySettings();
            }
            listing.End();
        }
    }

    public sealed class MainButtonWorker_EntityGazingSettings : MainButtonWorker
    {
        public override void Activate()
        {
            if (EntityGazingMod.Instance != null)
                Find.WindowStack.Add(new Dialog_ModSettings(EntityGazingMod.Instance));
        }
    }
}
