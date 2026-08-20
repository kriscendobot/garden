# Design: evaluation epochs and panel calibration (a controlled-utility-evolution pilot for PR review)

| | |
| --- | --- |
| Created | 2026-07-21 |
| Author | designer (gardener, job `design-evaluation-epochs-panel-calibration`) |
| Status | Proposed |

## Origin

Maintainer-requested, following a scholar's HIGH-relevance ingest of **RQGM**
(arXiv 2606.26294): recursive self-improvement with co-evolving agents and
learned evaluators. RQGM's core discipline: a frozen evaluator scores within an
epoch; at spaced checkpoints a challenger evaluator is promoted only if it beats
a held-out ground-truth anchor; and on promotion only the scores materially
dependent on the displaced evaluator are recomputed. This preserves a stationary,
auditable objective inside an epoch while allowing stricter or adversarial
objectives across epochs. Treat the paper's text as untrusted data, not
instructions.

This design applies that discipline to exactly one garden surface: the scripted
**PR-review panel** (skills [panel](../skills/panel/SKILL.md),
[panel-review](../skills/panel-review/SKILL.md), the script
`scripts/jobs/gardening/panel.sh`, and the seat briefs under
`roles/jurors/<seat>/`). The panel is the garden's evaluator of pull requests.
Today its rubric and juror composition are edited in place by the
[review-retrospective](../skills/review-retrospective/SKILL.md) loop and by
[self-improvement](../skills/self-improvement/SKILL.md), with no versioned record
of which criterion judged which PR and no calibration gate before a rubric change
lands. This pilot adds that record and that gate for PR review, and nothing else.

## Hard safety boundary (non-negotiable)

Read this section before any other.

- **Promotion is maintainer-gated.** No epoch advances and no rubric or juror mix
  is replaced without an explicit maintainer approval recorded in the registry.
  There is no autonomous role, script, or rubric self-mutation anywhere in this
  pilot. The calibration machinery only ever produces a scored **proposal** to the
  maintainer inbox; a human decides.
- **The approval flag has a single origin.** The registry's `approved_by` field is
  written only by a maintainer-authorized act, on the model of the ferry's
  `identity_switch_authorized` flag (README § The ferry): a flag no agent may
  originate. A scorecard that meets every numeric bar still does not advance an
  epoch. The bars gate what may be *proposed*, never what is *applied*.
- **Deterministic checks and independent evidence survive every epoch.** Pre-push
  gates, CI, the coverage pre-pass, and any check that does not read the rubric are
  epoch-independent and are never invalidated by a promotion. Only verdicts
  materially dependent on a superseded rubric are re-run (§ Invalidation rule).
- **Changes route through the existing improvement workflow, never as direct role
  edits.** Epoch deltas and collected failures become
  [designer](../roles/designer/AGENT.md) and builder jobs on the board, following
  the [self-improvement](../skills/self-improvement/SKILL.md) and
  [review-retrospective](../skills/review-retrospective/SKILL.md) routing. The
  calibration step never lands a role or skill change itself.

## Concept map (RQGM to the garden)

| RQGM | This pilot |
| --- | --- |
| evaluator (utility function) | the PR-review **criterion**: seat composition (`GARDEN_CODE_SEATS` / `GARDEN_DESIGN_SEATS`) plus the [panel-review](../skills/panel-review/SKILL.md) disposition rubric and cite-or-propose discipline |
| epoch | a period during which that criterion is frozen; every panel verdict is tagged with the epoch's ID |
| held-out ground-truth anchor | a versioned, maintainer-curated corpus of labeled PR-review cases (§ Anchor corpus) |
| challenger evaluator | a proposed criterion delta (a seat added or removed, a rubric rule changed) scored against the anchor |
| promotion | a maintainer-approved advance to a new epoch that edits the registry and the rubric through a normal improvement job |
| recompute dependent scores | re-run only the open-PR verdicts materially dependent on the changed seats or rules (§ Invalidation rule) |

## Component 1: the versioned evaluation registry

A single journal file records the criterion in force and the history of criteria.

**Path:** `journal/evaluation-epochs/pr-review.md` (on `journal2`).

**Shape:** frontmatter naming the active epoch, then one append-only stanza per
epoch, newest last. The file is the source of truth `panel.sh` reads to learn
which criterion to run and which epoch ID to stamp.

```yaml
---
surface: pr-review
active_epoch: 3
anchor_version: 2026-07-15            # the anchor corpus version the active epoch was calibrated against
---

## Epoch 3
activated_at: 2026-07-15T00:00:00Z
status: active
code_seats: assessor,typist,stylist,...,coverage-auditor      # the frozen GARDEN_CODE_SEATS
design_seats: critic,skeptic,decomplector,ergonomist,copyeditor,pedant,novice
rubric_ref: skills/panel-review/SKILL.md@<commit-sha>          # the disposition rubric version in force
calibration:                          # scored at promotion time against anchor_version 2026-07-15 held-out split
  precision: 0.91
  recall: 0.84
  false_accept: 0.04
  false_reject: 0.07
  cost_seats: 29
  inter_rater_spread: 0.19
  adversarial_resistance: 0.88
replacement_rationale: >
  Added corner-prober firing on async boundaries; held-out recall +0.09
  (Wilson lower bound +0.03 at 90%), no false_reject regression, cost flat.
approved_by: kriskowal
approved_at: 2026-07-14T22:10:00Z
supersedes: 2
```

**Every panel verdict is attributable.** `panel.sh` reads `active_epoch` at the
top of a run and stamps it into three places: the run-dir aggregate
(`GARDEN_PANEL_RUNDIR/round-*.md`), the tada report, and a one-line footer on the
posted GitHub review body (`Reviewed under evaluation epoch 3
(journal/evaluation-epochs/pr-review.md).`). A verdict is therefore always
traceable to the exact criterion that produced it, which is the whole point of
freezing the objective inside an epoch.

**Immutability inside an epoch.** Epoch stanzas are append-only. An active epoch's
`code_seats` / `design_seats` / `rubric_ref` are never edited in place; a change to
the criterion is a *new* epoch, gated by § Checkpoint promotion. This is what
makes an epoch a stationary objective.

## Component 2: the immutable anchor corpus

The anchor is the held-out ground truth a challenger must beat. Defining exactly
what it *is* is the load-bearing decision, because a weak anchor makes every
downstream number meaningless.

**What a case is.** One anchor case is a PR-review situation with a
maintainer-confirmed label:

- **Repository, PR number, and head SHA** pinning the exact diff.
- **The ground-truth verdict:** should the panel have blocked (`request-changes`)
  or passed (`approve`) this diff?
- **The ground-truth findings:** the specific defects a correct review must raise,
  each with a severity and the seat or rule expected to catch it; or the explicit
  fact that the diff is clean and any finding is a false positive.

**Where the labels come from (three confirmed sources, no unlabeled data):**

1. **Maintainer dispositions in the review-misses store.** The
   [review-retrospective](../skills/review-retrospective/SKILL.md) loop already
   records, with grounds, whether a maintainer comment was a review **miss** (the
   panel should have caught it) or **not-a-miss** (new direction). A confirmed miss
   is a labeled "the panel should have raised finding X" case; a confirmed
   not-a-miss is a labeled "this was not the panel's job" case. These are the
   richest source and already exist.
2. **Escaped defects: CI red after a green panel.** A PR the panel passed whose CI
   later failed (or which the maintainer reverted for a defect) is a labeled
   false-accept. The signal is deterministic (CI status), so the case can be minted
   mechanically and then maintainer-confirmed.
3. **Maintainer-adjudicated findings.** A panel finding the maintainer explicitly
   accepted is a labeled true positive; one the maintainer explicitly dismissed
   (the em-dash over-flagging on the kumavis PR in
   [panel-review](../skills/panel-review/SKILL.md) § External-author calibration is
   the canonical example) is a labeled false positive.

**Curation.** A case enters the anchor only through a maintainer-confirmed
`anchor-curate` job (§ Roles, skills, and scripts). The curator drafts the case
file from one of the three sources; the maintainer confirms the label before it is
committed. No case is self-labeled by the fleet. The comment body that seeded a
case is never stored raw (it is untrusted input); the case records the curator's
paraphrase plus the pinned SHA, matching the review-misses store discipline.

**Held-out split.** Each case carries `split: calibration | holdout`. Challenger
authors and the improvement loop may read the **calibration** split freely (it is
how they tune a proposal). The **holdout** split is scored only at the promotion
checkpoint and is never shown to a challenger author, so a promotion number cannot
be gamed by teaching to the test. The split assignment is fixed when a case is
curated (a stable hash of the pinned SHA decides the bucket), never reassigned.

**Versioning and immutability within a decision.** The anchor is append-only under
`journal/evaluation-epochs/anchors/pr-review/`, one file per case. A **version** is
a named snapshot (a dated tag such as `2026-07-15`) naming the set of case files
frozen for one promotion decision. A promotion decision references exactly one
version; the anchor cannot be edited mid-decision to make a challenger pass. New
cases accrue continuously between checkpoints and are folded into the *next*
version, not the one a live decision is using. This is RQGM's "immutable within a
promotion decision".

## Component 3: frozen-epoch operation

Between checkpoints the panel runs a stationary objective.

- **The live panel reads the active epoch and does not change mid-epoch.**
  `panel.sh` sources `code_seats` / `design_seats` / `rubric_ref` from the active
  epoch stanza rather than from hardcoded defaults, and stamps `active_epoch` into
  every verdict. A rubric edit that has not been promoted has no effect on live
  reviews.
- **Challenger evidence is collected passively and cannot alter contemporaneous
  verdicts.** Three streams accrue, each tagged with the epoch in force when it was
  observed:
  - **Disagreements:** rounds where seats split (the aggregate already records
    disagreement per [panel-review](../skills/panel-review/SKILL.md) § Aggregation).
  - **Escaped defects:** CI-red-after-green-panel events and maintainer-confirmed
    review misses (the review-misses store, extended with an `epoch:` field).
  - **Known-good work:** PRs that passed cleanly and stayed good through merge and
    a bounded settling window.
  This is the same evidence the review-retrospective loop already gathers. The
  pilot adds only the epoch tag and the CI-escape stream. **None of it changes the
  verdict already posted;** it is input to the next checkpoint only. That
  separation (score under the frozen criterion, learn for the next one) is the
  discipline RQGM buys us.

## Component 4: checkpoint promotion

A checkpoint is a discrete, scheduled, maintainer-gated calibration step. It never
promotes on its own.

```mermaid
stateDiagram-v2
  [*] --> Frozen
  Frozen --> Frozen: panel runs under active epoch, stamps epoch id
  Frozen --> Collect: disagreements, escaped defects, known-good accrue (tagged by epoch)
  Collect --> Frozen: no checkpoint due
  Collect --> Checkpoint: scheduled checkpoint fires
  Checkpoint --> Proposal: score challengers on holdout anchor, build scorecard
  Proposal --> Frozen: no challenger clears the bars, or maintainer declines
  Proposal --> Promote: maintainer approves (writes approved_by)
  Promote --> Invalidate: re-run open-PR verdicts dependent on changed seats or rules
  Invalidate --> Frozen: new epoch active
```

1. **Propose challengers.** A challenger is a criterion delta: a seat added or
   removed, a disposition-rubric rule changed, a panel-hints probe added. Proposals
   come from the accumulated challenger evidence. The clusters the review-misses
   store already forms (and the `review-improve-*` jobs the prosecutor already
   dispatches) are exactly candidate deltas; the checkpoint packages each as a
   scored challenger rather than letting it edit the rubric directly.
2. **Score each challenger against the holdout anchor** for precision, recall,
   false-accept, false-reject, cost (seat count and `claude -p` spend),
   inter-rater spread, and adversarial resistance (§ Component 5). Scoring replays
   the challenger criterion over the pinned anchor SHAs; the arithmetic is
   deterministic (`score-challenger.sh`, no LLM in the math path), the per-case
   panel replay is the only `claude -p` cost.
3. **Emit a scorecard proposal to the maintainer inbox.** Incumbent versus each
   challenger on every metric, with confidence bounds and the promotion-bar
   verdict. No registry edit happens here.
4. **Promote only on maintainer approval** of a challenger that cleared the bars.

### Promotion threshold math

The anchor is small (dozens of cases), so point estimates are noisy and a
conservative lower bound is mandatory. Because the incumbent and the challenger
score the **same** anchor cases, the data is paired, which sharpens the test.

Promote a challenger only when **all** of the following hold on the holdout split:

- **Recall improvement, conservatively bounded.** The lower bound of the
  challenger-minus-incumbent recall difference is strictly positive at 90%
  confidence. Use a McNemar paired test over the discordant cases (diffs the
  challenger catches that the incumbent misses, versus the reverse); the promotion
  quantity is the *lower* confidence bound of the improvement, never the point
  estimate. This is RQGM's "conservative lower-bound improvement".
- **No false-reject regression.** The challenger's false-reject rate (good PRs
  blocked) does not exceed the incumbent's by more than a small tolerance
  (default `0.02`), Wilson-upper-bounded. Catching more defects by blocking
  everything is not an improvement.
- **No false-accept regression.** The challenger's false-accept rate (bad PRs
  passed) is at or below the incumbent's, upper-bounded.
- **Bounded cost.** Seat count and measured `claude -p` spend do not exceed the
  incumbent by more than a configured fraction (default `+15%`). A strictly better
  but far costlier criterion is a maintainer judgment, surfaced but not
  auto-cleared.
- **No adversarial-resistance regression** (§ Component 5).

A challenger clearing every bar is *eligible* for proposal. Approval remains the
maintainer's (§ Hard safety boundary). The defaults above are configuration in the
scoring script, not constants baked into logic.

### Invalidation rule

On promotion, recompute only what materially depended on the superseded criterion.

- **Compute the criterion delta.** Diff the outgoing and incoming epoch stanzas to
  the set of *changed seats* and *changed rubric rules*.
- **Open PRs:** re-run the panel for an open PR only when its active verdict rests
  on a changed seat or rule (a finding a removed seat raised, or a disposition the
  changed rubric would reclassify). An open PR whose verdict is independent of the
  delta keeps its verdict and is simply re-tagged to the new epoch.
- **Merged PRs are historical and are not re-run.** Re-litigating merged work is out
  of scope (§ What this pilot does NOT do). Their epoch tag already records the
  criterion in force, so the audit trail is intact without a recompute.
- **Deterministic and independent evidence is preserved unconditionally.** CI
  results, pre-push gate outcomes, and the coverage pre-pass do not read the rubric
  and are never invalidated. This bounds the recompute to the small set of live,
  rubric-dependent verdicts, which is the efficiency RQGM's dependency-tracking
  buys.

## Component 5: adversarial replay

A red-team pass produces a bounded, separately-reported resistance metric.

- **The red team is a pair**, on the model of
  [saboteur-adversarial-review](../skills/saboteur-adversarial-review/SKILL.md):
  one builds cases the *outgoing* panel passed but that later failed (drawn from
  the escaped-defect stream), and one builds cases that exploit a known judge bias
  (the "shadow" hallucination and the em-dash over-flagging in
  [panel-review](../skills/panel-review/SKILL.md) § Pitfalls and § External-author
  calibration are the seed biases).
- **Resistance** is the fraction of adversarial cases the challenger handles
  correctly (catches the planted defect, or declines the bait finding).
- **It is a bounded gate, not the primary objective.** A challenger must not
  regress on resistance relative to the incumbent, and the resistance number is
  reported on its own line of the scorecard. It never substitutes for the
  recall and false-reject bars; a challenger cannot buy its way past those by
  scoring well on adversarial cases alone. Reporting it separately keeps the
  red-team from quietly reshaping the primary metric.

## Roles, skills, and scripts this pilot touches or adds

**Touches:**

- **`scripts/jobs/gardening/panel.sh`** ([panel](../skills/panel/SKILL.md)): reads
  the active epoch from the registry for its seat lists and rubric reference
  (replacing the hardcoded `GARDEN_CODE_SEATS` / `GARDEN_DESIGN_SEATS` defaults with
  registry-sourced values, defaults retained as the epoch-1 seed), and stamps the
  epoch ID into the run-dir aggregate, the tada report, and the posted review
  footer. Quiet-on-success is preserved; the stamp is one line.
- **[panel-review](../skills/panel-review/SKILL.md)**: the per-juror block and the
  posted-review body gain the epoch-tag footer; the disposition rubric is
  understood as versioned by epoch (the `rubric_ref` commit).
- **[review-retrospective](../skills/review-retrospective/SKILL.md)** and the
  [prosecutor](../roles/prosecutor/AGENT.md): the review-misses store gains an
  `epoch:` field per record; the store becomes the primary challenger-evidence
  collector, and maintainer-confirmed misses are the primary anchor-case source. No
  change to the prosecutor's threshold logic; the pilot adds the epoch tag and a
  handoff to anchor curation.
- **[self-improvement](../skills/self-improvement/SKILL.md)**: unchanged in
  substance. It remains the routing by which calibration outcomes become designer
  and builder jobs rather than direct edits. The pilot depends on this routing and
  adds nothing to the skill except, if warranted, one note-from-the-field row.
- **[schedule](../skills/schedule/SKILL.md)**: a new slow-cadence schedule
  `evaluation-checkpoint-pr-review` (monthly is a reasonable start) dispatches the
  checkpoint job. The schedule only ever produces a proposal.
- **[job-board](../skills/job-board/SKILL.md)**: two new job kinds, both analysis
  or curation only, never auto-mutating: `evaluation-checkpoint` (score challengers,
  emit the scorecard) and `anchor-curate` (draft an anchor case for maintainer
  confirmation).

**Adds:**

- **`scripts/jobs/evaluation/epoch-registry.sh`**: read the active epoch, print its
  seat lists and rubric reference for `panel.sh`, and stamp a verdict. Deterministic,
  no LLM.
- **`scripts/jobs/evaluation/anchor-add.sh`**: append a maintainer-confirmed anchor
  case, assign its split by stable hash, and CAS-push. Deterministic.
- **`scripts/jobs/evaluation/score-challenger.sh`**: replay a challenger criterion
  over a pinned anchor version and compute every metric plus its confidence bounds.
  The per-case replay spends `claude -p`; the arithmetic and the promotion-bar
  verdict are deterministic.
- **The checkpoint role.** The `evaluation-checkpoint` job is claimed by a gardener
  wearing an existing improvement-facing role. The [prosecutor](../roles/prosecutor/AGENT.md)
  already owns the review-misses store and the review-process improvement loop, so it
  is the natural fit; whether the checkpoint warrants a dedicated `calibrator` role
  is an open question (§ Open questions) rather than a role minted here.

## What this pilot does NOT do

- **It does not auto-promote anything.** No epoch advances, and no seat, rubric, or
  probe changes, without an explicit maintainer approval. There is no autonomous
  self-mutation path anywhere in the design.
- **It does not generalize beyond PR review.** Other garden evaluators (a
  designer's quality bar, the mentor's automation judgments, a scholar's relevance
  scoring) are out of scope. The registry, the anchor, and the scoring harness are
  all keyed to `pr-review` alone.
- **It does not re-litigate merged PRs.** On promotion, merged work is re-tagged for
  audit but never re-reviewed. Only live, rubric-dependent open-PR verdicts recompute.
- **It does not replace deterministic gates or CI.** Those are epoch-independent
  evidence, preserved across every promotion, and are themselves part of the ground
  truth the anchor encodes.
- **It does not learn online or continuously.** Checkpoints are discrete, scheduled,
  and gated. Between them the objective is frozen.
- **It does not remove the human from review.** The maintainer stays in the loop at
  every checkpoint; the pilot makes the criterion auditable and its evolution
  gated, not automatic.
- **It does not build the anchor from unlabeled or self-labeled data.** Only
  maintainer-confirmed labels enter, and the holdout split is never shown to a
  challenger author.
- **It does not let the panel grade its own promotion.** Ground truth is maintainer
  dispositions, CI, and the adversarial red team, never the panel's own verdicts.

## Phased build plan

Each phase is independently valuable and independently reversible, so the
maintainer can green-light incrementally and stop at any boundary. Nothing after
Phase 0 changes a live verdict until Phase 4, and Phase 4 is reached only if the
maintainer approves the whole pilot.

- **Phase 0 (the first buildable increment): registry and epoch tagging.** Create
  `journal/evaluation-epochs/pr-review.md` with epoch 1 seeded from the current
  seat lists and rubric commit. Add `epoch-registry.sh`. Teach `panel.sh` and
  [panel-review](../skills/panel-review/SKILL.md) to read the active epoch and stamp
  it into the run dir, the tada report, and the review footer. Pure observability:
  no behavior change, no promotion machinery, immediate auditability of which
  criterion judged which PR. This increment stands alone and is the recommended
  green-light target.
- **Phase 1: anchor corpus scaffolding.** Add the anchor store path and case schema,
  `anchor-add.sh`, and the `anchor-curate` job that drafts a case from a
  maintainer-confirmed review miss or a CI-escape event for maintainer confirmation.
  Read-only with respect to the live panel. Extend the review-misses store with the
  `epoch:` field. Begin accruing cases.
- **Phase 2: the scoring harness and the checkpoint proposal.** Add
  `score-challenger.sh` and the scheduled `evaluation-checkpoint` job that scores
  candidate deltas over the holdout anchor and posts a scorecard to the maintainer
  inbox. Still no promotion; the output is a proposal a human reads.
- **Phase 3: adversarial replay.** Add the red-team pair job and fold the resistance
  metric into the scorecard as a bounded, separately-reported line.
- **Phase 4: the gated promotion path.** On maintainer approval, a designer or
  builder job (routed through [self-improvement](../skills/self-improvement/SKILL.md),
  never a direct edit) writes the new epoch stanza with `approved_by`, edits the
  rubric and seat lists, and runs the invalidation step to re-tag and selectively
  re-run dependent open-PR verdicts. Reached only after the maintainer green-lights
  the pilot end to end.

## Open questions

- Should the checkpoint be claimed by the [prosecutor](../roles/prosecutor/AGENT.md)
  (which already owns the review-misses store) or by a dedicated `calibrator` role?
  This design routes it to the prosecutor and defers minting a new role to a later
  maintainer decision, per [self-improvement](../skills/self-improvement/SKILL.md)'s
  "do not invent or rename roles mid-engagement".
- What checkpoint cadence is right? The plan seeds monthly, but a cadence tied to
  anchor growth (checkpoint when the holdout split has gained N new cases since the
  last decision) may calibrate better than a wall-clock interval.
- What is the minimum holdout-split size below which the promotion bounds are too
  wide to clear? The math is conservative by construction, but a floor (do not run
  a checkpoint until the holdout split holds at least M cases) should be set once
  the first cases accrue.
- Should the CI-escape stream be minted fully mechanically (a CI-red-after-green
  watcher) in Phase 1, or does every escape case still require maintainer
  confirmation before entering the anchor? This design requires confirmation for
  anchor entry; the watcher that *proposes* the case is a candidate mechanization.
- Does the design panel (7 seats) warrant its own epoch series, or does one
  `pr-review` registry cover both the code and design panels with per-kind seat
  lists in the same epoch stanza? This design uses one stanza carrying both
  `code_seats` and `design_seats`; splitting them is a later refinement if their
  calibration cadences diverge.
