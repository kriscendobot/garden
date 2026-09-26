Done and pushed to `main2` as `333efc84fc`.

## What I did

**The fix (`scripts/jobs/promote-plan.sh`).** Promotion now clears the reaper/gardener cycle-marker family from the body it moves `plan/` → `todo/`, and records the cleared set in the existing provenance comment:

```
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-29T02:01:30Z cleared=deadline-overrun=1 -->
```

- `strip_cycle_markers` filters `REAP_MARKER_RE`, `DEADLINE_OVERRUN_MARKER_RE`, `REAP_NOW_MARKER_RE`, `PRODUCTIVE_MARKER_RE`, `OUTAGE_MARKER_RE` — the regexes from `common.sh`, reused, never re-spelled. (I included the outage hint alongside the four the spec named: it is the same class of per-cycle boolean hint that `clean_body` also strips.)
- `cleared_summary` builds the audit token from the existing read-only helpers (`reap_count`, `deadline_overrun_count`, `has_*_hint`); a marker-free promotion records `cleared=none`.
- `cleared=` is appended **after** `at=`, so `orchestrate.sh`'s `at=\([^ >]*\)` parse is untouched (asserted in the test).

**One-spelling refactor.** `REAP_MARKER_RE` moved from `reaper.sh:133` to `common.sh` beside the rest of the marker family; `reaper.sh` gets it by sourcing and keeps a pointer comment noting it is still the marker's only *writer*.

**Regression guard** — new `scripts/jobs/test/promote-plan-poison-reset-test.sh` (11 assertions): the marker strip and provenance record; work-body and execution-key (`role`/`model`/`handler-timeout`) preservation; the `at=` parse; `cleared=none`; and end-to-end **reaper poisons → promote → the job gets a real requeue**, with a control proving a body that still carries the counter *does* re-poison, so the reaper's protection is demonstrably intact.

**Docs**: `designs/job-board.md`, `skills/job-board/SKILL.md`, and `roles/liaison/AGENT.md` (promoting a poison-parked job needs no manual clear step).

## Verification

- New test: **11 passed, 0 failed**. Stashing only the `promote-plan.sh` change reproduces the bug — 4 assertions fail, including the end-to-end *"promotion is still a no-op the job cannot escape"*.
- `scripts/jobs/test/run-test.sh 6 3`: **367 passed, 0 failed** (its SUBTEST 20 covers promote-plan).
- `scripts/checks/run-all.sh --dry-run`: all 5 gates clean. `bash -n` clean; no new shellcheck findings beyond the file's pre-existing SC2034 class.

## Follow-ups

- The live `endo-sturdyref-agent-surface-build-gauntlet` is still parked in `plan/` behind its `go-ahead` carrying `<!-- garden-deadline-overrun: 1 -->` (I confirmed the marker is there; `garden-reaped` is not — `clean_body` strips it before the park, so the deadline-overrun counter at threshold 1 is the whole re-poison mechanism). Promoting it is a maintainer-authorization act, so I left it; once this lands on the leader via the deliberate deploy, a plain `promote-plan.sh` will now give it a genuine run.
- This fix reaches the deployed root only through `deploy-garden.sh`, not automatically.
- Out of scope as the spec noted: `post-plan.sh` re-parking paths still pass bodies through verbatim.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-promote-plan-poison-reset.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 613 tokens (3723988 cached reads)
- Output: 29870 tokens
- Cost: $3.7189250000000005
- Wall-clock: 1019s

<!-- garden-usage-end -->
