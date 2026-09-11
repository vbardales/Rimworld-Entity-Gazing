using RimWorld;
using Verse;

namespace EntityGazing
{
    /// <summary>
    /// Le fournisseur « regarder un batiment » du jeu de base, plus une seule condition : la
    /// plateforme doit reellement retenir quelque chose.
    ///
    /// C'EST TOUT CE QUE CE MOD CONTIENT COMME CODE, et cette classe existe uniquement pour cette
    /// condition. Sans elle, il suffirait de declarer `HoldingPlatform` dans les `thingDefs` d'un
    /// `JoyGiverDef` vanilla - mais les colons iraient alors contempler des plateformes VIDES,
    /// c'est-a-dire un portique d'acier avec des chaines qui pendent. Le reste du trajet, de
    /// l'orientation et du gain de joie est integralement du jeu de base
    /// (`JoyGiver_WatchBuilding` et `JobDriver_WatchBuilding`), comme pour un televiseur.
    ///
    /// `CompEntityHolderPlatform` appartient au DLC Anomaly mais vit dans `Assembly-CSharp` comme
    /// tout le code des extensions : la classe existe meme sans le DLC, seules ses defs manquent.
    /// Aucune reflexion n'est donc necessaire, et l'assemblage se charge dans tous les cas.
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

            // Un cadavre sangle sur une plateforme n'est plus un spectacle, c'est un probleme
            // d'hygiene.
            return held != null && !held.Dead;
        }
    }
}
