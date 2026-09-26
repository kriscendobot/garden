All work is complete and verified. Here is my completion report.

---

# Consolidated review retrospective — 85 events, one cross-cutting pass

## What I did

Fetched all 85 review/comment bodies (and, for the 46 review-surface events, their inline review comments — where the real substance lived) via the pinned `gh` wrapper. Read the existing corpus (24 misses, 134 dismissals, 13 clusters). Clustered the 85 by failure mode, cross-referenced the corpus, landed the clean seat-tier fixes on `main2`, dispatched one builder job for the process cluster, recorded all 85 per-event outcomes, and escalated two recurrences to you.

**Store after this pass:** 49 misses (+25), 194 dismissed (+60), 23 clusters. All 85 bases present, 0 missing.

## The clustering (the question 85 isolated retros couldn't answer)

**The dominant finding is about the population, not any one seat.** 60 of 85 events (~71%) are not review-misses at all — they are **operational pipeline directives** ("conduct", "rebase", "shepherd", "retcon", "weave", "build", "close", "post a follow-up job") and **design-direction steers** on design docs. A review-miss loop asked to judge these one at a time can only dismiss them, which is exactly the corpus's ~85% dismissal rate. The cause is structural: the comment-watcher's `retro_eligible` gate (`scripts/jobs/comment-watcher.sh:1602`) mints a retro for **every** `review` submission regardless of whether its body is "Retcon and conduct" or "Please run a gauntlet." That is the leak feeding the dismissal flood.

The 25 genuine misses cluster as:

| Cluster | Misses / PRs | Category | Above threshold? |
|---|---|---|---|
| **prefer-endo-primitives** (NEW) | 6 / 5 (#671,755,824,836,877,882) | style-convention | ✅ |
| **capability-hardening-attenuation** (NEW) | 5 / 2 (#874,881) | security-hardening | ✅ |
| **merge-base-pinning** (NEW) | 4 / 3 (#719,831,836) | process | ✅ |
| avoid-name-abbreviations (EXISTING) | +2 (#684,806) → 6 total | naming | already dispatched |
| inline-import-jsdoc (EXISTING, closed) | +1 (#792) → reopened | style-convention | recurrence |
| 8 isolated one-offs (below) | 1 each | mixed | ❌ |

## Concrete changes — landed and dispatched

**Landed on `main2` (37b04ec909)** — sharpening existing seats + builder directives (prevention + seat-tier sensing):

1. **prefer-endo-primitives** → `roles/builder/AGENT.md` gains a "reach for an existing `@endo/*` utility before hand-rolling" directive (bytes/hex/base64/ascii/sha256/errors); `roles/jurors/purist/AGENT.md` gains a "reuse over re-implementation of `@endo/*` primitives" inquiry axis. Marked `improvement-dispatched`.
2. **capability-hardening-attenuation** → `roles/builder/AGENT.md` gains a "harden an exported exo/client capability structurally" directive; `roles/jurors/locksmith/AGENT.md` gains "runtime-flag attenuation and unhardened exported capabilities are the second recurring locksmith finding." Marked `improvement-dispatched`.

**Dispatched** (process fix, larger than a seat edit — spans builder/weaver/frozen-base-branch):

3. **merge-base-pinning** → posted `review-improve-merge-base-pinning` (deferred builder, identity `review-cluster:merge-base-pinning`) with the two-part contract: reinforce `frozen-base-branch` as a hard precondition and add a deterministic branch-hygiene check. Marked `improvement-dispatched`.

## Not worth acting on (honest list)

- **8 isolated one-off misses** — each real but singular, no shared detectable signal, below threshold: `avoid-this-in-exo-methods` (#713, a documented "we don't use `this`" rule — cheap builder-directive candidate if it recurs), `async-notification-dispatch` (#723), `cjs-lexer-edge-cases` (#856), `fetch-response-ok-ordering` (#874), `filler-phrase-concision` (#825), `cross-platform-test-coverage` (#836), `design-flag-backwards-compat` (agoric-sdk #10). Recorded for calibration; no change warranted yet.
- **The "avoid re-implementing JS in Rust" pattern** (#875/#876/#877) — recurring architectural preference but no standing rule; dismissed as new-direction, flagged as a future builder-directive candidate, not a review check.

## Escalated to you (message delivered to maintainer inbox)

- **inline-import-jsdoc recurrence** — the 07-16 gate/fix, yet #792 (07-22) drew "Should have been caught in review." Writer flagged `recurrence=1` and reopened. I did **not** auto-start a second round — flagged the deploy-lag caveat (07-22 may predate the fleet deploy) for your call.
- **avoid-name-abbreviations gate under-coverage** — the deterministic spell-out-identifiers gate landed 07-11, yet #806 (07-22) and #684 (07-29, `Addr`) still hit abbreviations. The cluster was never marked `closed` so no auto-recurrence fired; likely the probe skips test files / its dictionary misses `Addr`.

## Follow-ups (recommendations, not done)

- **Highest leverage: narrow `retro_eligible`** in `scripts/jobs/comment-watcher.sh` so a `review`/`attention` whose sole actionable content is a pipeline-op verb (conduct/rebase/shepherd/retcon/weave/merge/close), or an empty-body approval with zero inline comments, mints **no** retro. This cuts the ~85% dismissal flood at the source. Left as a recommendation because it touches the watcher's tested hot path and reverses your deliberate err-toward-minting choice — warrants a dedicated tested builder job.
- **Gauntlet-coverage gap:** several reviewed PRs (#881, #806, #684, #836) show no build/gauntlet/panel job at all — "the panel missed it" is often "the panel never ran." Generalizes the existing `garden-design-pr-gauntlet-bypass` (process) cluster beyond design PRs.
- Deterministic probes for prefer-endo-primitives; widen the spell-out-identifiers probe.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-retrospective-consolidated-20260804.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 117 tokens (10689544 cached reads)
- Output: 101187 tokens
- Cost: $10.097807999999999
- Wall-clock: 1805s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
