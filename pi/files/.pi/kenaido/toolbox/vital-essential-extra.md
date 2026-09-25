# Vital, essential, extra

## What it is

Three layers that stack, each resting on the one below:

| Layer | What it means | The test |
|-------|---------------|----------|
| **Vital** | Without it, nothing holds. If it is missing or wrong, everything above it is pointless | If this fails, does the rest stop mattering? |
| **Essential** | Built on the vital, and makes it manageable without strain: it protects the vital, or removes the stress of operating it | Does this protect or ease something vital, rather than add new capability? |
| **Extra** | Built on the essential: the next thing worth trying, which adds capability, detail, or insight | If it disappeared, would anything vital or essential get worse? If yes, it is misclassified |

The framing comes from aviation practice, as described to this project — the origin is recorded as given and not independently verified (`ANLY-2`). What matters here is the structure, and the structure is what makes it more than a priority list.

**Why the stacking matters more than the ranking.** Ordinary priority schemes rank items against each other: must, should, could. This one says something stronger — **essential presupposes that the vital works, and extra presupposes the essential is in place.** So an extra built before its essential is not merely early, it is resting on nothing. That is the failure the tool exists to catch, and no ranking scheme catches it.

## When to use it

- Deciding what a first version must contain, and what can wait.
- Checking a plan for inversion: effort going into extras while something vital is still unproven.
- Setting the quality bar per item, because the three layers deserve different bars (see below).
- Cutting scope under pressure, in an order that leaves the thing standing.
- Reviewing a backlog whose items all look equally urgent.

## When not to use it

- **To rank items inside one layer.** It says nothing about which of two vital things comes first: that is ordering by value, cost, risk, and dependency, and it belongs to the Product Owner (`TEAM-1`).
- **As a label on work already done.** Its value is in choosing, not in describing.
- **When everything really is vital.** Then the subject is too big: split it first ([divide and conquer](divide-and-conquer.md)) and classify the parts.
- **To justify gold-plating.** "Extra" is permission to test something, not permission to build everything.

## How to run it

1. **Name the whole and its purpose.** A layer is only vital *for* something; change the purpose and the classification changes.
2. **Find the vital by removal, not by importance.** Ask what would make the thing not hold at all — not what is most valued, which is a different question and usually a longer list. If two people disagree, they usually disagree about the purpose, not the item.
3. **Then the essential:** what keeps the vital reliable, recoverable, observable, or humane to operate. Most quality work lives here — and so does most of the work that gets skipped under pressure, which is why naming it as a layer helps.
4. **Then the extra:** each one stated as a hypothesis with the outcome it should cause, a measure, and a condition for dropping it (`VALUE-4`, `IMPR-6`). An extra with no measure is not an extra, it is an opinion.
5. **Check the stack for inversion.** Where is the effort going? An extra being built while a vital item is unproven is the single most useful finding this tool produces.
6. **Check that each layer rests on a real one below,** not a planned one. A backup that has never been restored, or a check that exists on an unmerged branch, does not yet satisfy anything.
7. **Set the bar per layer:**

   | Layer | The bar |
   |-------|---------|
   | Vital | Cannot be switched off, cannot be traded away, and is verified automatically wherever possible (`CODE-10`, `TEST-1`) |
   | Essential | Meets the Definition of Done, and is reviewed by someone other than its author (`ANLY-8`) |
   | Extra | Smallest version that tests the hypothesis, with a measure and a stop condition; kept only if the measure moves (`VALUE-4`, `IMPR-6`) |

## Worked example, from this project

| Layer | Example here | Why |
|-------|--------------|-----|
| **Vital** | A human stays accountable for every decision (`PRIN-1`); work never reaches `main` unreviewed (`GIT-5`, `GIT-6`); tests, security, and secret scans cannot be switched off (`TEST-1`, `CODE-10`); nothing is lost when a usage limit stops an agent (`CONT-7` to `CONT-10`) | Without any of these the product is not usable by a serious team, whatever else it does |
| **Essential** | The evidence pack, the interaction records, the decision log, a stop control, a captured audit trail, the flow metrics | They keep the vital things trustworthy and calm to operate rather than heroic |
| **Extra** | The team hub, connectors to outside tools, autonomy levels 3 and 4, extra thinking tools in this folder | Each is worth testing, each has a measure, and none of the layers below depends on any of them |

That table also shows the tool's own warning working: three of the four extras are recorded as design work rather than build work, precisely because vital and essential items are not finished yet.

## What it produces

Each item labeled vital, essential, or extra, with the reason in the item's own terms; a list of any inversion found (effort above an unfinished layer); and, for every extra, its measure and its stop condition.

## Common mistakes

- **Everything is vital.** Then the word means nothing, and the real vital items lose their protection. If the list is long, the subject is too big.
- **Classifying by who asked** rather than by what the thing rests on.
- **Confusing urgent with vital.** An urgent extra is still an extra.
- **Treating a vital item as done for good.** Vital things decay: an untested backup, an unenforced check, a hook nobody installed. Vital status is a claim that has to stay true.
- **Skipping the essential layer under pressure,** which is exactly when it matters: the vital keeps working and every operator pays for it daily.
- **Adding a fourth layer.** If something fits nowhere, it is usually two things; split it rather than inventing a level.

## Rules applied

`ANLY-2`, `ANLY-8`, `ANLY-10`, `CODE-9`, `CODE-10`, `TEST-1`, `VALUE-4`, `VALUE-5`, `IMPR-6`, `PRIN-1`, `TEAM-1`.
