---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restore the 22 swept ironhorse children and relaunch the campaign (DEPLOY IS DONE)

Re-post of `ironhorse-test262-restore-and-relaunch`, which halted TWICE at its
deploy precondition (2026-08-12T16:58Z and 17:05Z) — correctly, both times.

That blocker is now CLEARED. Both live hosts deployed to `b580e3d51a`:
- leader `endolin-garden2-5bcdff64` at 17:07:09Z
- follower `endolin-garden-ece02cb4` at 17:08:43Z

Verified in the deployed leader root: `orchestrate.sh` no longer contains
"requeue count rose from", and `complete-job.sh` carries `--orchestration-failed`.

The precondition below still stands — re-verify it yourself on YOUR host before
restoring anything. Everything else is the original job, unchanged.

---

## PRECONDITION — verify before you restore anything

The campaign was destroyed twice by an `orchestrate.sh` stall bug. BOTH fixes must
be live in the DEPLOYED garden root (read the files; do not infer from `main2`):

1. `9a16e2a6ef` — `scripts/jobs/orchestrate.sh` must NOT contain the string
   `requeue count rose from`; the stall test must be
   `! has_productive_cycle_hint "$jf" && [ "$n" -gt "$limit" ]`.
2. `ede7f1f467` — child-failure detection/stamping (`tada_failed` in
   `scripts/jobs/common.sh` recognising decorated verdict lines, and
   `complete-job.sh --orchestration-failed`).

If either is missing, STOP: message the liaison and end with
`orchestration-failed: true`. Relaunching a 29-child campaign under the old stall
heuristic is how this campaign was swept twice already.

## What happened (so you do not repeat it)

`jobs/tada/ironhorse-test262-implementation-completion-resume.md` records:

> Serial run halted at child 7/29 **ironhorse-js-06-sync-iteration-generators**:
> stalled after 1 requeues on host endolin-garden2-5bcdff64 (requeue count rose
> from 0). 6/29 children completed before the failure.
> Swept 22 not-yet-run downstream child(ren): …

That is the removed heuristic firing on a single benign requeue. The child in
question completed normally 1h28m–3h31m later. The same thing happened on
2026-08-08 at child 6/29 (halt commit `3f7c64152e`).

## Recovery coordinates (verified)

- Sweep/halt commit: `c95607119cb1b8a9a48f732820ba51f96a53b1a7`
  (`journal2`, 2026-08-12T03:34:03Z). Its **parent** still holds every swept body
  at `jobs/plan/<child>.md`: `git show c95607119^:jobs/plan/<child>.md`.
- Earlier incident, if you need it: `3f7c64152e` (2026-08-08T09:34:03Z).

The 22 children, in run order:

    ironhorse-js-07-promises-async-functions
    ironhorse-js-08-async-generators-for-await
    ironhorse-js-09-proxy-mop
    ironhorse-js-10-arrays-species
    ironhorse-js-11-strings
    ironhorse-js-12-regexp
    ironhorse-js-13-numeric-date-json
    ironhorse-js-14-binary-data-atomics
    ironhorse-js-15-collections
    ironhorse-js-16-modules
    ironhorse-js-17-resource-management
    ironhorse-js-18-realms-eval-annexb
    ironhorse-js-19-intl-core
    ironhorse-js-20-intl-formatters
    ironhorse-js-21-intl-datetime-segmenter
    ironhorse-js-22-temporal-core
    ironhorse-js-23-temporal-plain
    ironhorse-js-24-temporal-zoned
    ironhorse-js-25-temporal-integration
    ironhorse-js-26-residual-gap-closure
    ironhorse-js-27-full-suite-report-refresh
    ironhorse-js-28-issue-summary

Stages `js-00` … `js-06` are DONE (in `jobs/tada/`). Do NOT re-post them.

Leave the six `ironhorse-js-0N-…-gauntlet-panel-N` entries currently in `jobs/plan/`
alone — they belong to other orchestrations, not to this child list.

## `--resume-from` does NOT apply here — do not burn time on it

`post-orchestration.sh --resume-from` requires the terminal campaign to carry
`orchestration-status: budget-exhausted|budget-meter-incomplete` AND its remainder
to still be parked in `plan/`. This campaign is `halted` and its remainder was
`git rm`'d. It will `die` on both checks. Restore by re-parking.

## Procedure

New campaign base: `ironhorse-test262-implementation-completion-resume-2`.

1. For each of the 22, recover the body from the sweep commit's parent. STRIP the
   old plan frontmatter block (the `gate:`/`orchestrated_by:`/`posted_*` header the
   producer stamps) and keep the work body; `post-plan.sh` writes a fresh header.
   The recovered bodies name `orchestrated_by:
   ironhorse-test262-implementation-completion-resume` — the OLD campaign. The new
   parking must point at the new base.
2. Re-park each, in run order:
   `post-plan.sh --orchestrated --orchestrated-by ironhorse-test262-implementation-completion-resume-2 <child> <body-file>`
3. Verify each recovered body is byte-identical to the pre-sweep original modulo
   that frontmatter, and say so in your report. A silently truncated stage body
   would send a gardener to do the wrong work with no signal.
4. Record the campaign:
   `post-orchestration.sh --serial --on-child-failure halt --budget-tokens 2080000 ironhorse-test262-implementation-completion-resume-2 <the 22, in order> -- <body-file>`

## The budget

2,080,000 billable tokens (~$68 notional / ~$21 real-dollar-equivalent), reported
as this week's calibrated combined figure across the fleet's two Claude accounts by
the follower liaison (`endolin-garden-ece02cb4`, message
`role/liaison/20260812T164547Z-ef36a7`). VERIFY that figure against the
budget/calibration records before passing it — you are arming real spend, and a
misread multiplier is expensive in the direction nobody notices until the bill.
If it does not check out, park the campaign and report rather than guessing.

## Definition of done

- All 22 children re-parked under the new base, integrity-verified per item 3.
- The campaign recorded serial, halt-on-failure, with the verified budget.
- A report naming the sweep commit used, any child whose recovery was imperfect and
  how you resolved it, and the budget figure with the source you verified it against.
- If the precondition failed, none of the above — just the halt and the message.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T17:09:25Z
