---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# review the 12 tada reports the follow-up handler QUARANTINED on 2026-07-28

## Background

`garden-follow-up` failed 5 consecutive ticks on the same pending set and
quarantined it (advancing the seen-marker) so it would stop re-running
`claude -p` every cadence. Both quarantine notices show the failure was a
**quota wall, not a fault**:

    FATAL: claude -p failed transiently (rc=1); stderr: <empty>;
    stdout: You've hit your session limit - resets 10am (UTC)
    ... resets 3:20pm (UTC)

So these reports were never digested, and whatever follow-up work they implied
was never posted. The reports are all still present in `jobs/tada/`.

## The quarantined set

    guard-worker-self-disqualify-missing-agent-bin
    audit-evaluator-gaming-baseline
    build-panel-run-record
    design-post-verdict-addressee
    endo-vfs-parity-press-20260728-130502
    endojs-endo-but-for-bots-pr870-dependabot
    fix-censored-events-frozen-reputation-arm
    fix-ps23-claude-path-outage
    fu-clarify-drain-moratorium-vocabulary-1
    improve-journal-entry-duplicate-suppression
    issue-garden-62-jcorbin-cross-analysis
    requeue-ps23-stranded-claims

## Task

Read each report and post follow-up jobs for what is **still** wanted. These are
~3 weeks old (2026-07-28), so do NOT blind-replay them: for each, first check
whether the condition still holds, then post only live work. Several were
already confirmed resolved during the 2026-08-14 sweep — do not re-post these:

- `elapsed-constancy-classifier-test.sh` SUBTEST 7 — now 39 passed / 0 failed.
- `test_maintainer_inbox_information_hiding.sh` library drift — now 10 / 0.
- `run-test.sh` hardcoded `TR=/home/kris/.garden-test` + 30 pre-existing
  failures — that file no longer exists; the suite is now `tests/checks/run.sh`.
  Do check whether the CURRENT suite is green by default, since the original
  complaint ("the suite is red by default, so it cannot gate anything") is only
  answered if it is.

One item from the digest was NOT resolved and is worth its own assessment:

- **`GARDEN_REAP_OVERRUN_THRESHOLD` is still `1`** (`scripts/jobs/common.sh`).
  The report argued for `2` on the **elapsed-constancy** path specifically,
  keeping `1` for the `rc=124` wall-hit path, which is genuinely conclusive at
  one observation. Relevant context: as of 2026-08-14 there are 16 jobs parked
  in `jobs/plan/` by exactly this reaper path. Assess whether the threshold is
  over-parking, and if so post the change.

## Definition of done
- Each of the 12 reports classified: still-live (job posted) or moot (say why).
- A recommendation on `GARDEN_REAP_OVERRUN_THRESHOLD`.
- Do not re-enable follow-up on these reports; the seen-marker stays advanced.
