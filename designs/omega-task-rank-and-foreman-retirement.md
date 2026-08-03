# Omega task rank, and retiring the foreman

| Created | 2026-08-03 |
| Author  | designer (job `garden-budget-omega`, Budget 5/5 of `garden-budget-attribution`) |
| Status  | Proposed |

Fifth and last child of the `garden-budget-attribution` chain. Children 1–4 built
the true-cost machinery and its read side; this child answers the maintainer's
policy question that sits on top of it: **what order should the garden work in, and
should the foreman — which sets that order today — be retired?**

> Maintainer ask (verbatim): *"look at what Josh Corbin's Unum is doing to classify
> tasks by their omega notation, that is, the task's rank in a tree of plans, such
> that a job that cannot be completed without a plan inside its time window must
> create a plan and promote itself in that tree. The garden should focus on
> completing the lowest rank tasks, including those that require a human review to
> make progress. The foreman would ideally be retired, as the foreman generates
> work that consumes from the budget without direction."*

**Scope discipline: this is a design document. It changes no dispatch behavior.**
Retiring the foreman unit needs a sysop `unit` op with maintainer attestation
(`authorized_by:` on `maintainers/allowlist`) — an agent may not originate it, and
no such op is issued here.

Read alongside: [`issue-cost-and-triple-evaluation.md`](issue-cost-and-triple-evaluation.md)
(child 4 — the finding that governs this whole design), [`token-cost-ledger.md`](token-cost-ledger.md)
(the per-job ledger), [`orchestration-jobs.md`](orchestration-jobs.md) (the
garden's existing tree-of-jobs substrate), and the job board / plan queue in
`scripts/jobs/{post-plan.sh,foreman.sh,claim-job.sh}` + `common.sh`
(`plan_rank`, `plan_deferred_ranked`).

---

## 0. The finding that governs everything below (from child 4)

Child 4 measured, on the garden's densest real corpus (`endojs/endo-but-for-bots`):

- **Machine cost per merged PR:** mean **$0.59**, median **$0.16**, ~$0.125/job.
- **Human review per merged PR:** **1.75–2.41 rounds** (median 1, p90 ~5), with
  **88–91%** of merged bot PRs taking at least one human review.
- **Human review dominates machine cost by ~50–190× at the median**, robust across
  the entire plausible (minutes/round, $/min) box.

Two consequences bind this design:

1. **A rank that optimises token cost optimises the wrong quantity.** Machine spend
   is noise against maintainer attention. Rank must order work to minimise **human
   review rounds** and **time-to-unblock**; machine cost is a tiebreaker at most.
2. **The maintainer's own clause is the load-bearing one:** *"the lowest rank tasks,
   **including those that require a human review to make progress**."* Child 4's
   evidence says that clause is the important half — work blocked on a human is
   consuming the genuinely scarce input, while work that merely burns tokens is
   nearly free. A correct omega rank must therefore make **human-review-blocked
   work rank at or near the floor** (worked/surfaced first), not treat it as stalled.

The rest of this design is written to serve those two consequences.

---

## 1. The omega scheme — grounded honestly, not invented

### 1.1 The gap, stated plainly

**No omega notation, task-rank scheme, or "tree of plans" ranking exists anywhere
this designer can reach.** Diligence performed:

- Read all 15 `library/sections/unum--*` sections (overview, vigil-charge,
  per-persona-model-tiers, claim-lifecycle, cost-attribution, token-cost-ledger,
  the LORE cluster, operations-standards, …). None defines a rank.
- Grepped the whole `journal2` `library/` for `omega|rank|tree of plan|priorit|
  decompos|self-promot`. The only `omega` matches are econometrics
  (Diebold-Mariano, HAR-RV volatility) — unrelated.
- Fetched the live unum repo overview (`tangled.org/jcorbin.tngl.sh/unum`) and ran
  a web search. Neither surfaces an omega/rank definition. The ingested unum
  material is pinned to early-July-2026 commits and predates whatever the
  maintainer saw.

`jcorbin` is on `journal/maintainers/allowlist`. Per this job's own instruction — *a
plausible-but-wrong rank that reorders the garden's priorities is worse than an
honest gap* — a grounding question was posted to the maintainer inbox
(`message-user.sh`, 2026-08-03) asking jcorbin for unum's actual definition. **This
section's interpretation is explicitly provisional and awaits that answer.** Nothing
in it is implemented.

### 1.2 The reconstruction (provisional — labelled as this designer's, not unum's)

Reading the maintainer's sentence literally against complexity notation:

- **Ω (omega) is the lower bound.** "Focus on completing the lowest rank tasks"
  reads naturally as: work the **leaves** of a plan tree first — the tasks that need
  no further planning and directly deliver, and that everything above them waits on.
  A **leaf = omega-floor = do-first**; an **internal node (a plan) = higher rank =
  cannot be done until its children are.** (This mapping is the single most likely
  place to be wrong — leaf-is-floor vs root-is-floor is exactly what the maintainer
  question asks jcorbin to confirm.)
- **"A task that cannot be completed within its time window must create a plan and
  promote itself in that tree."** A task claimed as a leaf that turns out too big for
  its handler-timeout must **decompose**: mint child sub-tasks, become an internal
  node, and raise its own rank above the children it now waits on. This is a
  *self-promotion up the tree*, driven by the discovery that the work did not fit.

### 1.3 The garden already half-implements this

The reconstructed scheme is not foreign to the garden — it is most of the
[orchestration-jobs](orchestration-jobs.md) machinery, minus an explicit rank number:

| Omega concept | Existing garden mechanism |
| --- | --- |
| Tree of plans | `jobs/orch/<orch-base>.md` (the record) + `orchestrated` children parked in `jobs/plan/` with `orchestrated_by:` back-edges |
| Leaf task (do-first) | a childless job in `jobs/todo/` |
| Internal node waits on children | `orchestrate.sh` serial/parallel promotion; a `blocked_on` edge for a linear pair |
| Task too big → create a plan + promote itself | the standing directive *"for a multi-part job, always make an orchestration job"* — a handler that finds the work too large posts an orchestration + parked children instead of finishing |

**What is genuinely missing** is only two things: (a) an explicit **rank number** on
each job, and (b) a **rank-ordered admission** step that prefers omega-floor work
(leaves, and review-unblocking work) over omega-ceiling work (fresh top-of-tree
plans). Today the garden has *no* rank number and its admission order is the
foreman's `priority` field (urgent/high/normal/low) plus FIFO — a flat four-bucket
priority, not a tree rank. That gap is what a real omega scheme would fill, and it is
why the foreman question and the rank question are the same question (§3).

### 1.4 A concrete rank, IF jcorbin confirms the shape

Offered only to make the proposal reviewable, not to be built before the grounding
answer. Define a job's omega rank as a sort key, **lower = worked first**:

```
omega(job) = ( review_state_class , tree_depth_below , priority_bucket , age_rank )
```

- `review_state_class` (the dominant term, per §0): **0 = unblockable by finishing
  garden work that a human is already reviewing or has requested changes on**; **1 =
  ordinary deliverable work**; **2 = fresh top-of-tree plan that has produced nothing
  a human has seen yet**. This is what makes "lowest rank includes human-review work"
  literally true in the sort.
- `tree_depth_below`: leaves (0 children remaining) sort before internal nodes. A
  node self-promotes by gaining children, which *raises* this term — exactly the
  maintainer's "promote itself in that tree."
- `priority_bucket`: the existing `plan_rank` (urgent<high<normal<low), reused so no
  information is lost.
- `age_rank`: FIFO within ties, the existing fairness tiebreaker.

Machine cost appears **nowhere** in the key — deliberately, per §0. It would enter, if
at all, only as a final tiebreaker below `age_rank`.

---

## 2. The foreman, re-costed and re-scoped

### 2.1 What it actually does (measured)

`scripts/jobs/foreman.sh`, leader-only, drain-gated (`fleet_draining && exit 0`,
`foreman.sh:95`), ticks every ~5 min. On sustained under-subscription (in-flight
`todo`+`doin` below `GARDEN_FOREMAN_ACTIVE_TARGET`, default **5**, past a 240 s settle
window) it does **two structurally different things**, in order:

1. **Deterministic admission (cheap, directed).** Batch-promote the top deferred
   plan jobs by `plan_deferred_ranked` (priority then FIFO) into `todo/`, up to
   `TARGET − in-flight`. No `claude -p`. This is pre-approved, maintainer-queued work
   moved by rank.
2. **Generative pump (expensive, undirected).** *Only if no deferred plan is queued*,
   hand a digest to the foreman role via `claude -p` and post the one new milestone
   step it invents.

### 2.2 The maintainer's complaint isolates to half (2), not half (1)

*"Generates work that consumes from the budget without direction"* describes step
**(2)** precisely: it mints brand-new top-of-tree work no one queued, spending an LLM
turn to do so. Step (1) is the opposite — it is the *only* place in the whole dispatch
path where a rank governs what gets worked (see §2.3). **Retiring "the foreman"
should retire the generative pump and keep, rename, and rank-upgrade the admitter.**

### 2.3 Why an admitter cannot simply be deleted (the crux)

`claim-job.sh` selects from `jobs/todo/` starting at an **id-derived offset** and
racing — i.e. gardeners work todo jobs in **arbitrary order, honoring no priority or
rank at all** (`claim-job.sh:109`). Rank governs dispatch **only** at the plan→todo
promotion, which is exactly the foreman's step (1). Therefore:

- Gardeners only ever claim from `todo/`; a `deferred` plan job never becomes work
  until *something* promotes it.
- If the foreman is deleted outright with no replacement, the **95** deferred plan
  jobs (measured on `journal2`, 2026-08-03; alongside 89 `go-ahead`, 8 `blocked`, 2
  `orchestrated`) never reach `todo/` — the fleet idles on an empty board while a
  large backlog sits unreachable.

So "how does work reach idle workers without a pump?" has a definite answer: **a
deterministic, no-LLM rank-ordered promoter must remain.** It is the foreman's step
(1), which is not the part the maintainer objected to. The honest framing of the ask
is *retire the generative pump; keep and improve the promoter.*

### 2.4 The unmeasurable-cost point (say it plainly)

Child 2 established that standing services — foreman, triager, watchman, bulletin —
run `claude -p` **outside** the gardener claim spine and **never reach
`complete-job.sh`, so they write no cost record at all.** The foreman's generative
pump is therefore the exact intersection the maintainer intuited: **the one dispatch
input that spends without direction is also the one the ledger cannot see.** Retiring
the generative half removes an untracked, undirected spender; whatever residual
proactive spend survives should be moved *onto* the measured spine or gated (§4).

---

## 3. The staged foreman-retirement path

Five stages, each individually reversible, none requiring the undirected generative
pump to survive. Stages 1–2 are the substance; 3–5 are the rank upgrade that depends
on jcorbin's answer (§1) and so are gated behind it.

### Stage 1 — Neuter the generative pump (behavior change; needs maintainer word)

Disable step (2) only. Two options, in increasing finality:

- **Soft:** set the pump's provider order / handler to a no-op so the foreman still
  admits deferred jobs (step 1) but never invents a milestone step. Reversible by
  config; leaves the unit running. Preferred first move — it removes the objected-to
  spend while keeping admission alive, and is trivially revertible.
- **Hard:** stop and disable the `garden-foreman` unit entirely, and stand up the
  standalone promoter of Stage 2 in its place. This is the eventual end state.

Either is a **behavior change an agent may not originate**: the hard form needs a
sysop `unit` op carrying maintainer attestation (`authorized_by:`); the soft form is a
config write the maintainer authorizes. **Recommendation:** do the soft form first,
watch one full quota week, then take the hard form once Stage 2 exists.

### Stage 2 — A standalone deterministic promoter (`garden-promoter`)

Extract the foreman's step (1) into its own leader-only, drain-gated, **no-`claude`**
timer that keeps `todo/` supplied from the plan queue by rank. Initially it reuses
`plan_deferred_ranked` verbatim (so it is behavior-preserving for admission), then
Stage 4 swaps the ordering to `omega()`. This is the "how work reaches idle workers
without a pump" answer made concrete: a promoter, not a pump — it moves pre-approved
work by rank and never mints new work.

The `garden-foreman` unit is then retired (sysop `unit` op, attested) with its useful
half already running under the new name. Its milestone-awareness — the one genuinely
useful thing the generative pump did, noticing a milestone's next step — is **not**
recreated as autonomous minting; a milestone's next step should be an
**orchestration** (a queued child, §1.3) posted deliberately, not invented under
budget. That is the maintainer's own standing directive already.

### Stage 3 — Represent rank on jobs (schema, no behavior)

Add an optional `omega:`/`rank:` frontmatter field (and, for the review-state term, a
derivation from existing signals: a `blocked_on:` PR that is *in review* vs *merged*).
Absent field ⇒ falls through to today's `priority`+FIFO, so it is a no-flag-day
additive change. No promoter reads it yet.

### Stage 4 — Promoter orders by `omega()` (behavior; gated on §1 answer)

Swap the promoter's `plan_deferred_ranked` for the `omega()` sort key of §1.4 **only
after jcorbin confirms the tree orientation.** This is the step that makes
"human-review-blocked work ranks at the floor" real: the promoter surfaces/admits
review-unblocking work ahead of fresh plans.

### Stage 5 — Self-promotion on time-window overrun (behavior; the "create a plan" half)

When a handler discovers its claimed leaf is too big for its window, formalize the
existing "post an orchestration" move as the rank self-promotion: the job mints
children (parked `orchestrated`), the orch record is written, and the parent's rank
rises above its children by construction (an internal node now). The reaper's
deadline-overrun path is the natural trigger to *suggest* this, but the decomposition
itself stays a deliberate handler action, never an autonomous mint.

### What happens to the 95 deferred jobs

They are **not** discarded. Under Stage 2 they remain the promoter's input pool,
admitted by rank exactly as the foreman admits them today — so retirement is
continuous, not a backlog reset. Two cautions:

- **Triage staleness first.** A 95-deep deferred backlog on a fleet throttled to ~2
  gardeners (see the pool-throttle note) is many weeks of work; some entries are
  surely stale. A one-time librarian/liaison triage pass (expire, merge, or
  re-prioritise) should precede Stage 4, so the new rank orders *live* work.
- **`gate: deferred` survives** as the promoter's pool marker — it is the set the
  rank-orderer draws from. `go-ahead` (needs authorization), `blocked` (waits on
  `unblock.sh`), and `orchestrated` (waits on `orchestrate.sh`) are unchanged; only
  the *mover* of `deferred` changes name (foreman → promoter) and, at Stage 4,
  ordering (priority → omega).

---

## 4. Residual proactive spend, and the scarce input

If any proactive/initiative spend survives retirement, gate it the way child 4 and
unum both point:

- **Budget the rate limit, not the dollars.** Child 4: at ~$0.125/job the binding
  constraint on a flat subscription is the **rate limit** (`usage-meter.sh`), not a
  dollar ledger. The two accounts differ — `hasExtraUsageEnabled` is **true** on
  `endolin-garden-ece02cb4`, **false** on `endolin-garden2-5bcdff64` — so only one
  can convert excess into a charge; the other simply stalls. Any capacity policy that
  admits work up to a limit must know which account it is spending, or it will stall
  the fleet on the wrong host.
- **Reward verified stability (unum's vigil-charge).** The garden's proactive gate
  today is only the weekly token *quota* back-off. unum's
  [vigil-charge](../journal/library/sections/unum--vigil-charge-initiative-budget.md)
  offers a complementary *health* gate: accumulate initiative budget only over
  verified-quiet observations, spend it on a proactive turn only when the fleet is
  demonstrably stable. If a future initiative actor replaces any of the foreman's
  minting, this is the gate to put in front of it — but the simpler win is to not mint
  autonomously at all (§3).

---

## 5. Open questions (also in the `tada/` report)

1. **[Blocking on §1, §3–5] The omega definition itself.** No omega/rank scheme
   exists in the reachable library or live unum source. Awaiting jcorbin: the real
   definition, and confirmation of leaf-is-floor vs root-is-floor and of
   "promote itself" ≡ "post an orchestration." Question posted 2026-08-03; an
   unanswered question is an acceptable deliverable and Stages 4–5 stay gated behind
   it.
2. **The review-state term needs a data source.** §0 makes "blocked on human review"
   the dominant rank term, but the garden does not today record, per job, whether its
   PR is *awaiting review* vs *changes-requested* vs *merged* in a form a promoter can
   read. Child 4's `review-rounds.sh` reads this from GitHub after the fact; a *live*
   promoter would need it as cheap journal state. Deriving it is unspecified work.
3. **Is a review-blocked PR even a garden job to rank?** A PR awaiting the maintainer
   is already delivered and sitting in a human's queue, not in `jobs/`. "Focus on
   completing lowest-rank tasks including those needing review" may mean *surface the
   review frontier to the human* (a report/nudge) at least as much as *admit more
   fleet work*. The two readings imply different mechanisms; jcorbin/maintainer should
   say which is meant.
4. **Milestone-awareness after the generative pump dies.** The pump's one useful
   behavior was noticing a milestone's next step. This design routes that to
   deliberate orchestration rather than autonomous minting; confirm that is
   acceptable, or a *deterministic* (no-LLM) next-step deriver is needed.
5. **Backlog triage ownership.** Who runs the one-time 95-deep deferred triage before
   Stage 4 — the librarian, the liaison, or a dedicated job?
6. **Account asymmetry policy.** Should capacity admission prefer the
   `hasExtraUsageEnabled: true` host for overflow, or should both stall symmetrically?
   Out of scope here but adjacent to any promoter that gates on capacity.

---

## 6. Definition of done for this design

- ✅ Ranking scheme covered, **grounded honestly** (real source searched; absent;
  reconstruction explicitly flagged provisional and awaiting jcorbin; question
  posted).
- ✅ How rank interacts with human-review-blocked work: made the dominant rank term
  per child 4's finding (§0, §1.4, open Q2–Q3).
- ✅ Staged foreman retirement (§3): isolates the objected-to generative pump from the
  still-needed rank-ordered promoter; says what replaces it, what happens to the 95
  deferred jobs, that `gate: deferred` survives, and how work reaches idle workers
  without a pump.
- ✅ Notes that stopping the unit needs a sysop `unit` op with maintainer attestation;
  **changes no dispatch behavior.**
