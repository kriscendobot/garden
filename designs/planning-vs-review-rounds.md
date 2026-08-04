# Does planning work reduce human review rounds?

| Created | 2026-08-04 |
| Author  | assayer (job `garden-review-rounds-correlation`, step 2 of 4) |
| Status  | Complete — **answer: cannot tell from current data** (insufficient discoverable population) |
| Reads with | [`issue-cost-and-triple-evaluation.md`](issue-cost-and-triple-evaluation.md) (step 1, the cost side), [`omega-task-rank-and-foreman-retirement.md`](omega-task-rank-and-foreman-retirement.md) (the design step 3 corrects) |

## The one-line answer, stated up front

> **We cannot tell from the journal whether rank-1 (planning/design) work reduces
> the human review burden of the rank-0 work it spawns — because the garden does
> not record a machine-discoverable "this PR's work was preceded by a design/plan
> phase" edge that survives to the completed corpus.** The population of merged
> PRs with a discoverable R1 *ancestor* is **zero** via the explicit spawn forest
> and effectively zero via every other route, against a floor of ~15 the analysis
> would need. This is a **null-instrument** result, not a null *effect*: the
> effect may be real or absent; the data cannot see it either way. The honest
> deliverable is therefore the **prospective experiment** (§ 6) that would make it
> measurable, plus a hard warning for step 3 (§ 7): the omega design must not
> assume planning is investment *or* inflation — neither is evidenced.

Prefer this to a fabricated correlation. Step 1 (`garden-budget-triple`) found the
memory axis had zero data and said so; the same discipline applies here.

## 1. The question and why the shape of the answer matters

Step 1 established that **human review dominates machine cost ~50–190× at the
median** (machine $0.16/merged PR median; human ~2 review rounds/PR; 88–91% of
merged bot PRs take ≥1 human review). Review rounds are the scarce currency. So:

> **Does rank-1 (planning/design) work reduce the human review rounds of the
> rank-0 work it spawns?**

- **If yes** — planning is *investment*: surplus machine capacity (nearly free
  tokens) should be spent on R1 work to buy back review rounds (scarce).
- **If no** — planning is *backlog inflation*: it should be suppressed and the
  omega design's priority direction reconsidered.

The maintainer is setting a dispatch policy from this. A confident wrong number is
worse than "cannot tell."

## 2. The confound this analysis was built to respect (and why it never bit)

The comparison is **observational, not experimental**, and selection bias is the
dominant threat: work that got a design phase is plausibly *different* work —
harder/more novel (needed planning → more rounds even if planning helped) or
better-understood/routine (fewer rounds regardless). A naive "PRs with an R1
ancestor" vs "without" measures *which work gets planned*, not *what planning
does*.

The plan was to control for it by matching on repo/area/diff-size or restricting
to a work class where both arms occur. **That plan never got the chance to run:
there is no population to stratify** (§ 4). The confound is noted here because it
governs the *prospective* design in § 6 — a future experiment that ignores it
would reproduce exactly this trap with more data.

## 3. Method and instruments (reused, not rebuilt)

Per the job, three landed instruments were used as-is:

| tool | role in this analysis |
|---|---|
| `scripts/jobs/review-rounds.sh` | the **Y** axis: human review rounds per merged bot PR (bot/panel reviews excluded) |
| `scripts/jobs/cost-by-pr.sh` | the base→PR join (which completed jobs contributed to which PR) |
| `scripts/jobs/cnf-backlog-triple.py` | the **rank rules** — `R2_ROLES={orchestrator}`, `R1_ROLES={designer, assayer, researcher, scholar, librarian, prosecutor, triager, watchman}`, else R0; realized-floor lift for a job that has spawned children |

**Classifier reuse, honestly.** cnf's rank rules read a job's `role:` field and the
spawn forest. Completed jobs (`jobs/tada/`) do **not** carry `role:` (§ 4.1), so
for a completed base I substituted the reputation event's `work_class:` prefix
(e.g. `design:l`, `assayer:m`) — the same producer-assigned role signal cnf reads,
projected through a different field. I did **not** fork or re-invent the rank
rules; I applied cnf's exact `R1_ROLES`/`R2_ROLES`/`R2_SLUG` sets to that prefix.
The substitution is **lossy** and I flag it as such: 70% of reputation events carry
`work_class: other` (no role derivable), so work_class *under*-counts R1 work — but
since the analysis dies on the *edge* population (§ 4.2), not the classifier, this
loss never becomes load-bearing.

## 4. The population funnel — n stated at every stage

Corpus: live journal + GitHub, 2026-08-04, `journal2` HEAD `49cdb5d1ba`. Priced
reputation events: **1915**. Densest review corpus: `endojs/endo-but-for-bots`.

### 4.1 The structural wall: completion discards the job's identity

| fact | count |
|---|---|
| `jobs/tada/` completion records | 4135 |
| …that carry **any** frontmatter (`---`) | **7** |
| …that carry `role:` | **0** |

`tada/*.md` files are **completion reports**, not job specs. The producer-assigned
`role:` and any parent edge live in the *original* posted job, which is
**overwritten** by the report on completion (recoverable only from git history, at
prohibitive cost). So the two inputs the rank/ancestry analysis needs —
per-completed-job role and parent→child edges — do not survive to the corpus the
question is asked over.

### 4.2 The spawn forest barely exists, and touches no merged PR

Every parent→child edge source the job named, counted over the whole board:

| edge source | files | what they actually encode |
|---|---|---|
| `jobs/orch/*.md` `children:` | **2** | 1 garden-internal (`garden-budget-attribution`, 5 children, **no PR**); 1 project (`minion-town-weblet-gateway-increments` → increments 2,3,4) |
| `orchestrated_by:` frontmatter | **1** | `minion-town-weblet-gateway-increment-4` — still parked in `jobs/plan/`, no PR |
| `garden-promoted-from-plan` provenance | 23 | 21 still in `jobs/plan/` (parked, no PR yet); 1 in `tada/`, 1 is this job |
| `blocked_on:` | 8 | **dependency** edges ("wait for PR #X to merge"), **not** design→build ancestry — e.g. `build-endo-inspect` blocked_on `#715` means "build after #715 lands," not "this build was designed first" |

Resolving the only forest edges that reach *any* PR:

- `garden-budget-attribution` → 5 children: all garden-internal `main2` work, **no PR**.
- `minion-town-weblet-gateway-increments` → increments 2, 3: PRs **#23, #24, both OPEN** (not merged; step-1 memory: Inc-2 CI-green but deploy-blocked). Increment 4: no PR.

> **Merged PRs that gain a discoverable R1/R2 *generative* ancestor from the
> explicit spawn forest: `0`.**

### 4.3 The join that *does* work joins the wrong kind of job

`cost-by-pr.sh` joins **553 of 1915** priced bases (28.9%) to **182 PRs (78
merged)** — but the authoritative edges (`jobs/index`, 544 edges) are
**watcher-minted directives that reference an *already-existing* PR** (`…-pr831-…`,
`…-pr658-review-…`, `…-shepherd-…`, `…-conduct`). These are **reactive, post-PR**
jobs (address review, shepherd CI, merge, re-run gauntlet) — structurally
incapable of being a *generative* R1 ancestor of the PR. Confirming this on the
536 distinct joined bases:

| rank class of joined base (via work_class) | n |
|---|---|
| R0 / reactive (`other`, `ops`, `fix`, `build`, `weave`, `shepherd`, `doc`, …) | 284 |
| **R1 (`design`)** | **7** — and all 7 are *design-on-an-existing-PR* (base names carry `prNNN`), i.e. contemporaneous review-side redesign, not a preceding plan |
| no reputation event (directive only) | 245 |

The 48 *generative* R1 jobs that actually ran (`design-endo-ertp-migration`,
`design-endor-packaging`, `minion-town-weblet-gateway-design`, …) are named by
**feature area, not PR number** — because the PR did not exist at design time — so
they **cannot** join through any deterministic edge, and no orch/`orchestrated_by`
edge links them to their downstream builds.

### 4.4 Population with a discoverable R1 ancestor, per stage

```
merged bot PRs (endo-but-for-bots)                     190
  with a joined contributing base                       ~68   (28% join coverage)
    with an R1 CONTRIBUTOR (contemporaneous)              ≤7   (design-on-PR, not an ancestor)
      with an R1 ANCESTOR (generative, preceding)          0   ← the number the question needs
```

`0 < 15`. Per the job's own stop rule ("if the population … is under ~15, say so
and stop"), the observational analysis stops here.

## 5. What *is* computable — reported as descriptive context, NOT the answer

These do not answer the question (none isolate a planning→build ancestry); they are
the honest floor of what the data supports.

**Baseline** (`review-rounds.sh`, endo-but-for-bots, 190 merged bot PRs): mean
**2.41** rounds/PR, median **1**, p90 **5**, max **27**; 91% have ≥1 human review.
(Matches step 1 exactly — the instrument is stable.)

**Design/doc PRs vs code PRs** (title-class, endo-but-for-bots):

| PR class (by title verb) | n | mean rounds | median |
|---|---|---|---|
| `design`/`docs`/`spec` PRs | 66 | 2.55 | 2 |
| `feat`/`fix`/`refactor`/… code PRs | 120 | 2.38 | 1 |

This says *design PRs are themselves reviewed at least as much as code PRs* — it
does **not** say a design phase lowers a build's review. Reading it as the answer
would be the exact selection-bias error of § 2 (a design PR and the feature it
designs are different artifacts). **Descriptive only.**

**minion.town** — the one repo where designs are visible PRs that precede feature
PRs (`#21 design(weblet)` → `#22/#23/#24 feat(gateway)`; `#13 design` →
`#14/#15 feat`): **14 merged bot PRs total, mean 0.86 rounds.** Far below the n≥15
floor and far too review-sparse to carry a comparison.

## 6. The deliverable that replaces the missing answer — a prospective experiment

Because observation cannot answer it, here is what would make it measurable.

**6.1 Record ancestry at job-creation time.** The root cause is § 4.1–4.2: ancestry
is not durably stamped and does not survive completion. Add to every posted job's
frontmatter, written by the producer (liaison/foreman/orchestrator/watcher) and
**carried into `reputation/events/` so it survives the tada overwrite**:

- `planned_arm: planned | unplanned` — did a design/spec/proposal job precede this
  build for the *same feature*? Set by the producer, which knows (it posted both).
- `plan_ancestor: <base>` — the R1 job this descends from (empty if unplanned).
- Stamp the same pair on the reputation event, so the completed corpus is
  self-describing without git archaeology.

This is a **one-field discipline**, the same fix step 1 prescribed for the memory
axis ("record the mode on each engagement"). It does not change dispatch (step-2
scope bars that); it makes step-4's admission gate and any future correlation
*possible*.

**6.2 The clean estimand.** Compare human review rounds of **planned** vs
**unplanned** builds, **stratified** to defeat § 2's confound: match within
`(repo, changed-file-count band, PR title area)`, or restrict to a work class where
both arms occur naturally. Report per-stratum, never a pooled raw mean.

**6.3 How long to accumulate n.** endo-but-for-bots merges ~190 bot PRs over the
journal's ~40-day life ≈ **~5 merged PRs/day**. For a two-arm comparison needing
~15 per arm *within the commonest stratum*, and assuming planned builds are a
minority (~⅓) of posts, expect **~3–6 weeks** of stamped data before a single
stratum clears the floor — longer if planned work concentrates in rare areas.

**6.4 The decision rule (fixed in advance, to avoid post-hoc rationalization).**
Within the best-matched stratum with n≥15/arm:
- If planned builds show **≥0.5 fewer** human rounds/PR (median) with the CI
  excluding 0 → **planning is investment**; route surplus capacity to R1 work.
- If the difference is **within ±0.5 rounds** → **indistinguishable**; do not
  spend planning effort to buy review rounds (spend it only where it de-risks
  *machine* rework, a separate ledger).
- If planned builds show **≥0.5 more** rounds *after* stratification (i.e. not
  explained by harder work) → **planning is not buying review down**; treat R1 as
  backlog per the omega concern.

## 7. Confidence grade per claim

| claim | confidence | act on it? |
|---|---|---|
| Human review rounds/merged PR ≈ mean 2.4, median 1, p90 5 (endo-but-for-bots, n=190) | **high** (direct GitHub count, stable across step 1 & 2) | yes |
| Completed jobs (`tada/`) do not carry `role:`/parent edges (7/4135 have any frontmatter) | **high** (exhaustive file scan) | yes — it is the structural wall |
| Explicit spawn forest = 2 orch + 1 `orchestrated_by` + 8 dependency edges; touches **0 merged PRs** with a generative R1+ ancestor | **high** (exhaustive over the board) | yes |
| `jobs/index` joins are reactive post-PR directives, not generative ancestors | **high** (base-name shape + work_class of 536 joined bases) | yes |
| Population of merged PRs with a discoverable R1 **ancestor** = 0 (<15 floor) | **high** | yes — this is why we stop |
| **Does planning reduce review rounds?** | **no data — cannot tell** | **no** — do not assume either sign |
| Design PRs reviewed ≥ code PRs (2.55 vs 2.38) | **moderate** (n=66/120) but **off-target** | no — not the question |
| minion.town design→feature comparison | **insufficient** (n=14, mean 0.86) | no |
| work_class as a role proxy | **moderate, lossy** (70% `other`) | as an under-count only |

## 8. Plain answer to "should surplus machine capacity go to R1 work?"

**Cannot tell from this data.** The journal cannot distinguish planning-as-investment
from planning-as-inflation, because it never recorded which builds were planned.
Do **not** set a dispatch policy that assumes either. The actionable move is
**§ 6.1** — stamp `planned_arm`/`plan_ancestor` on jobs and reputation events now —
so that in ~3–6 weeks the § 6.4 decision rule can be evaluated on real, stratified
data. Until then, hold the omega design's priority direction as **unproven** (§ 7's
warning to step 3), and keep the step-1 conclusion as the only load-bearing budget
fact: optimize review rounds, treat machine cost as a tiebreaker.

## 9. Open questions left for downstream steps

1. **(step 3)** The omega design ranks R1 above R0 on the theory that planning
   decomposes and de-risks. This analysis provides **no evidence** for that theory
   and none against it — step 3 must not cite a review-round benefit of planning
   as if it were measured.
2. **(step 4)** An admission gate that suppresses or promotes R1 work needs the
   § 6.1 stamp to ever be evaluable; consider making the stamp a *precondition* the
   gate enforces.
3. Would git-history reconstruction of `tada` jobs' original `role:` + a
   text-similarity design→build matcher recover a usable population retroactively?
   Plausibly for a *handful* of well-known feature arcs, but the matching is the
   § 2 guess the job warns against — flagged as possible-but-not-recommended.
4. Does the producer always *know* the planned/unplanned arm at post time? For
   liaison-posted `design X` then `build #N` on the same feature: yes. For
   foreman-backfilled or watcher-minted builds: the ancestor may be genuinely
   absent — which is itself the `unplanned` arm, not missing data.
