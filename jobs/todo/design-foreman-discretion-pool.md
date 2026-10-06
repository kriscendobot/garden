---
role: designer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a foreman-discretion pool, third-way split of the weekly budget

Repo: the garden itself (`kriscendobot/garden`, `main2`). Output: `designs/<slug>.md`
(designer's choice of slug; something like `foreman-discretion-budget-pool`).

## Maintainer directive (kriskowal, 2026-10-06, liaison session), restated precisely

Today's weekly apportionment (`designs/accountant-arc-apportionment.md`,
`config/apportionment`) splits the week's token budget into an
accountant-prioritized, per-arc slate and a maintainer-discretion remainder, and
`designs/standing-token-backoff-ramp.md` separately ramps the foreman's overall
admission fraction from an initial reserve toward full release as the week's
reset approaches. The maintainer wants a **third pool**, for work at the
foreman's own discretion, so the foreman keeps spending tokens even when none of
the accountant's prioritized arcs have ready work — rather than leaving tokens
unspent because the arc slate is temporarily dry.

The three pools, each a fraction of the week's **available tokens**, interpolate
**linearly** across the quota week (week start → scheduled quota reset):

| Pool | Week start | At reset |
| --- | --- | --- |
| Maintainer discretion | 50% | 5% |
| Foreman discretion (**new**) | 0% | 95% |
| Accountant-prioritized (per-arc slate, today's "rainbow of pie slices") | 50% | 0% |

Both endpoints sum to 100% (50+0+50 at start; 5+95+0 at reset) by construction —
preserve that invariant in whatever closed form is chosen.

This is a **reversal**, not just an addition, for the accountant-prioritized
share: today it is the share that *grows* toward reset (up to 90%, which the
maintainer now believes should be 95% — see below); under this directive it
*shrinks* to 0%, and the foreman-discretion pool takes over the growing share
that approaches 95% by reset. Maintainer discretion keeps approximately its
current shape (50% start, shrinking toward single digits by reset) with the
floor tightened from 10% to 5%.

## What already exists — reconcile, don't duplicate

Two related mechanisms are already live and MUST be reconciled explicitly in the
design (state which one this directive supersedes, which one composes with it,
and why):

1. **`designs/accountant-arc-apportionment.md`** — the accountant's weekly slate
   (`config/apportionment`) already carries a `planning_ceiling` (currently
   `0.9` on the live journal; the maintainer's notes on the current
   apportionment read "Spend each subscription to 90%, never 100%") and an
   `unallocated` pseudo-arc that foreman-drawn work with no arc is charged
   against. Is the new "foreman discretion" pool simply a time-varying,
   per-pool-fraction generalization of `unallocated` + `planning_ceiling`, or a
   genuinely separate concept layered on top? The "90% → 95%" figure in the
   maintainer's framing may be this `planning_ceiling`, not a new number — check
   before introducing a second ceiling that means almost the same thing.
2. **`designs/standing-token-backoff-ramp.md`** — a *different* existing ramp,
   on the **admission** layer (not the arc-apportionment layer): the foreman's
   overall fraction of a subscription's raw quota it may spend, computed when
   read (not ticked) as `r0 + (1 - r0) * elapsed/duration` over the pool's
   reset window, with `r0` from `config/token-backoff-initial` (currently `1.00`
   on the live journal — effectively no ramp in force right now; check whether
   that reflects an intervention override or a prior decision to abandon the
   ramp, and say which). Decide whether the new three-pool split lives
   *inside* this admission fraction (i.e., the three pools partition the
   already-admitted tokens) or is a *parallel* mechanism that composes with it
   (i.e., admission gates the outer envelope, and the three pools divide
   whatever that envelope allows this instant). Getting this composition wrong
   double-ramps or under-ramps the fleet.

Read both designs in full, and the live `config/apportionment` and
`config/token-backoff-initial` / `config/token-backoff-fraction` journal state,
before drafting. Favor the existing precedent of **computing the live fraction
when read, not ticking a writer** (the backoff-ramp design's stated reason:
avoids drift, needs no timer, snaps back correctly) unless there's a concrete
reason the three-pool split needs ticked/journal-visible state that computing
on read cannot give it.

## What the design must settle

1. **The closed-form split.** State the three fractions as explicit functions
   of elapsed/duration over the week (or reuse the existing
   `subscription_pacing_window` machinery the backoff-ramp design already
   built), satisfying the table above exactly at both endpoints.
2. **How foreman-discretion work is admitted, stamped, and accounted.** When
   the deferred selector or the foreman's idle-generation path finds no
   headroom in any ranked arc, does it now draw against the foreman-discretion
   pool instead of refusing (today: "With no headroom anywhere (including
   `unallocated`) the service does not invoke the agent at all")? What arc tag
   does that spend carry — a repurposed `unallocated`, or a new pseudo-arc —
   so the weekly statement can report it distinctly from genuine
   accountant-unallocated reserve?
3. **How maintainer-discretion tokens are actually reserved for maintainer
   use**, not merely "not yet spent." Today, maintainer-directed jobs are
   simply outside the pie (ungated by arc admission, governed only by the
   admission/metering layer). Does the maintainer-discretion *pool* need to
   become an actual reservation that foreman-drawn work (both arc-prioritized
   and foreman-discretion) cannot dip into, or does it remain implicit
   headroom the maintainer may use but the foreman never competes for? If the
   former, say what enforces it at claim time.
4. **Composition with `planning_ceiling` and the admission-layer backoff
   ramp.** Per the reconciliation above — pick one, retire or fold in the
   other, and say so plainly rather than leaving two overlapping percentages
   live.
5. **Where the fractions are computed and read**, and which existing scripts
   change: `set-apportionment.sh`, `accountant-statement.sh`, the deferred
   selector's per-arc headroom check, the foreman's digest. Prefer extending
   existing machinery over inventing parallel state.
6. **Illustration guidance for any diagram in the design** (mermaid per
   [designer AGENT.md](../roles/designer/AGENT.md)): the maintainer pictures
   this as light grey for maintainer discretion, dark grey for foreman
   discretion, and a rainbow of per-arc pie slices for the accountant-
   prioritized pool. Use that palette if a diagram (e.g. a `pie` chart at reset
   time, or a stacked composition across the week) earns its place; it is a
   steer on presentation, not a requirement to force a diagram that doesn't
   otherwise belong.

Follow `roles/designer/AGENT.md` for the open-questions carve-out (land bare on
`main2` if there are none; open a review PR if genuine maintainer decisions
remain — likely candidate: whether maintainer-discretion should become an
enforced reservation per item 3 above). Keep open questions to genuine
maintainer decisions; resolve everything else in the document so a later build
job can proceed without further clarification.
