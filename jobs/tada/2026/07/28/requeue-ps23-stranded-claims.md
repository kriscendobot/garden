# Report — `requeue-ps23-stranded-claims`

## Headline

The ps23 strand had **already cleared** before I claimed this job. But investigating the poison side of the spec (step 3) surfaced a **different, live defect that was poison-parking healthy jobs at that moment**. I fixed it, landed it on `main2`, and recovered its four victims.

## Precondition check

| Check | Result |
| --- | --- |
| Guard on `main2` | **Yes** — `7173c6dd36`, verified an ancestor of `origin/main2` |
| ps23 still winning claims | **No** — zero ps23 claims in `doin/`, zero `work/` records, no journal entry authored by ps23 since `06:49:33Z` (~6h). Its host record reads `gardeners: 1`, set by the leader at 06:49:50Z |
| Guard **deployed** | **No** — see follow-up 1 |

## Definition of done

- **`jobs/doin/` holds no ps23 claims** — verified against a freshly synced producer clone: `count=0` of 37 in-flight. All are held by `endolin-garden2-5bcdff64` / `endolin-garden-ece02cb4`.
- **`improve-gardener-claude-bin-resolution`** — better than free: **complete, in `jobs/tada/`**.
- **Jobs freed: 0 by me.** The 52 claims were requeued by the reaper on its normal TTL once the leader throttled ps23 at 06:49Z. Steps 1–2 were already satisfied; re-running the reaper would have been a no-op, so I did not invent a requeue.
- **Jobs un-poisoned: 4** (named below).
- **Left poisoned deliberately: 5.**

## The defect I found

`gardener.sh`'s elapsed-constancy check **samples its own cycle as the prior cycle**. It reads the elapsed series from its clone *after* pushing this cycle's progress note, and *after* `stamp_reap_now_hint`/`stamp_deadline_overrun_hint` call `sync_clone` — which hard-resets the clone onto an origin tip that now contains that note. It then appends the current elapsed again. The window is `[current, current]`: bit-identical by construction, so constancy is **always** confirmed, for any job, from its first cycle. Every confirming cycle stamps the early-poison counter, and at `GARDEN_REAP_OVERRUN_THRESHOLD=1` the reaper parks the job on its next tick.

Evidence from the journal — nine jobs flagged on one host in eight minutes (12:32–12:40Z), each a perfect pair at a *different* value (12,12s / 61,61s / 166,166s / 447,447s / 1403,1403s …) against true series that were nothing of the kind:

- `form-data-advisory` really ran **513s then 12s**; reported as `(12,12s)`.
- `pr705-fixer` really ran **576s then 61s**; reported as `(61,61s)`.
- `fu-…-pr825-8840fcdb-2` had **exactly one entry ever** (1403s); reported as `(1403,1403s)` "across the last 2 requeue cycles".

Fixed on `main2` as **`4a87fc7729`**: snapshot the prior series *before* writing this cycle's note, at both call sites (the exit-0-unsatisfying wedge check and the rc≠0 transient overrun check).

**Verification (executed, not inspected).** New SUBTEST 9 (cycle floor cleared, zero priors) and SUBTEST 10 (varied priors 470,900 → 3s) assert no escalation, no inbox section, and no early-poison counter. Against the unfixed script: **6 assertions fail, 3/3 in each**. With the fix: **32 passed, 3 failed** — the 3 being SUBTEST 7 (explicit-cap exemption), which fails **identically with and without** my change, i.e. pre-existing. Neighbouring suites all green: `worker-health-gate` 28, `outage-poison-pause` 10, `productive-cycle` 10, `completion-signal` 17, `signal-kill-classifier` 17.

## Un-poisoned (4) — spurious, no real deadline overrun ever occurred

`endojs-endo-but-for-bots-form-data-advisory`, `endojs-endo-but-for-bots-pr705-fixer-changes-requested`, `finbot-progress-20260728-065010`, `fu-endojs-endo-but-for-bots-pr825-8840fcdb-2`.

Each: stripped the spurious `garden-deadline-overrun` counter via `land-journal-edit.sh --base-blob` (marker stripped **while parked**, so no claim could race a still-armed body), then `promote-plan.sh` plan→todo. Verified post-recovery: all four re-claimed by healthy gardeners, `poisoned=no`, `overrun-marker=no`. No live board job carries a stale marker.

## Left poisoned deliberately (5) — genuine, with evidence

`pr867-dependabot`, `pr755-review-a0778b2e`, `ebfb-reconcile-xsnap-pending-jobs-861-864`, `finbot-pr5-panel-20260727`, `endo-sturdyref-agent-surface-build-gauntlet` — these are the only jobs with a real `rc=124, elapsed=2401s ≈ handler-budget` wall-hit entry. They need a larger `handler-timeout` or splitting, not un-poisoning.

**No job was poisoned by the ps23 outage.** Every 07-27/07-28 poison carries `deadline-overrun`, never `requeue-exhausted` (the last of those was 07-26). ps23's fast-fails were `rc=1` and cannot stamp an overrun.

I also checked the residual ps23 reap-counter contamination and **deliberately left it alone**: the jobs at `garden-reaped: 3` (`pr713-gauntlet-backfill`, `pr848-gauntlet-backfill`, `pr868-lint-fix`) are failing on *healthy* hosts too — pr713 is flagged an exit-0 wedge suspect. Decrementing their counters would delay surfacing genuine failures.

## Step 4 — dependabot block

All four PRs are **still open**, so the jobs are not stale: #867 (`@noble/curves` 1.9.0→2.2.0), #870 (`openai` 4.104.0→6.48.0), #556 (`actions/cache` 4.3.0→5.0.5), #868 (`eslint-plugin-unicorn` 56.0.1→72.0.0). As the spec anticipated, a fresh botanist pass is likely cheaper than resuming an hours-old transcript — #868 already carries an `EMBARGO-2026-08-02` verdict, so its job may be redundant.

## Follow-ups

1. **Deploy is the blocker.** This host's deployed root is `7e525d50c6` (07:05Z), **38 commits behind**. Neither my fix nor the ps23 guard `7173c6dd36` is running on the fleet — the poisoning continues until a deploy. Deploy is deliberate and drained, not a gardener's call; **alerted the maintainer** (`inbox/maintainer` `20260728T125846Z-69d42f`).
2. **ps23** silent since 06:49Z at `gardeners: 1`. If it returns before the guard is deployed there, it can re-strand claims.
3. **`GARDEN_REAP_OVERRUN_THRESHOLD=1` has no safety margin.** One bad stamp = one parked job, with no second opinion. Worth considering whether the threshold should be 2 for the *elapsed-constancy* path specifically (the rc=124 wall-hit path is genuinely conclusive at 1).
4. Pre-existing: SUBTEST 7 of `elapsed-constancy-classifier-test.sh` fails on `main2` (explicit-cap exemption not firing — the sub-floor reclassification wins). Untouched by this change; deserves its own job.
