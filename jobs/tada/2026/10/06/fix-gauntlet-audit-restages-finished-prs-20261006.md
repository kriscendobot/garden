## Fix gauntlet audit re-staging finished PRs: completion report

The coverage audit will no longer stage a second gauntlet on a PR whose earlier gauntlet already finished. The fix and its regression test are on `main2` as commit `d8dfa37f373`.

**Root cause.** The audit only counted a PR as covered if it had a record in `jobs/gauntlet/` or a file at the flat path `jobs/tada/<slug>-pr<N>-gauntlet.md`.
- When a gauntlet finishes, `finish_gauntlet` deletes its record and writes a report under the date-sharded `jobs/tada/YYYY/MM/DD/`. So a finished run was invisible to the audit, and the flat-path check can never match a sharded file.
- Gauntlets started by a build job are named after that job (for example `build-familiar-localhttp-protocol-gauntlet`), not after the PR.
- Most older terminal reports don't name their PR at all: 234 of 273 lack a `pr_number:` line, including the `review-budget-reached` report for #1426.

**What changed**
- **`scripts/jobs/common.sh`:** new `gauntlet_history_for_pr <dir> <repo> <n>`. It looks a PR up by identity, not by basename, across:
  - live or terminal records in `jobs/gauntlet/`;
  - archived records in `jobs/gauntlet-archived/`;
  - terminal reports anywhere under `jobs/tada/` (any report with a `gauntlet-status:` line).

  A report matches on its `repo:`+`pr_number:` lines, its `pr:` URL line, or the PR-keyed basename. For older reports with no identity, it matches when one of that run's own stage reports (clean, viability, panel, fix or undraft) contains the exact PR URL; `pull/63` does not match `pull/630`. `coalesced` runs are ignored because they never spent a stage.
- **`design-pr-gauntlet-coverage-audit.sh`:** any gauntlet history now counts as coverage, so the audit neither stages nor alerts. The flat-path check now uses `tada_exists`, which finds sharded reports. A fresh run on a finished PR is left to an explicit maintainer `run the gauntlet #N`.
- **`gauntlet.sh`:** `review-budget-reached` and `not-viable` terminal reports now record `repo:` and `pr_number:`, so new reports name their PR.
- **Regression test:** `design-pr-gauntlet-coverage-audit-test.sh` gained case (l), covering five post-arm PRs:
  - #59 has only an archived record;
  - #60 has only an older tada report with no identity (the #1426 shape);
  - #61 has a halted report;
  - #62 has a date-sharded report under the PR-keyed name;
  - #63 is a control with only decoys and must still be staged.

**Tests:** the audit test passes, and `gauntlet-test.sh` passes 71/71. Against the live journal, the new lookup finds the first gauntlet for #1426 (`build-familiar-localhttp-protocol-gauntlet`) and for #1425 (`…ses-xs-compartment-import-time-intrinsics-gauntlet`). A PR with no history returns nothing. Each lookup takes about 2 seconds, which is acceptable for an hourly leader-only audit.

**The five records with `created_by: design-pr-gauntlet-coverage-audit`:** #665, #935, #666, #1156 and kriscendobot/agoric-sdk#10. All five are archived and date from the 2026-08-30 to 09-04 mass-staging. Only #935 had an earlier gauntlet, `minion-town-guest-reminders-capability-experiment-gauntlet` (archived). The fix now also recognizes the PR #1428 run from the same tick as #1425/#1426 (the audit's first gauntlet on that PR) as coverage.

**Follow-ups (not done)**
- The older-report fallback trusts URLs written in agent-authored stage reports. A stray mention of a PR's exact URL could wrongly count as coverage. That errs toward not spending, and the problem fades as new reports carry `repo:`/`pr_number:`.
- `post-gauntlet.sh` itself still only refuses a second *concurrent* gauntlet. If the maintainer wants the same "no re-run after a finished gauntlet unless the head is new" rule for every producer, it should be added there.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `5c8c53ef`; this job presented `d4beb292d3f0588947782607ba12ab98d6b4dea0`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-gauntlet-audit-restages-finished-prs-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2598890 cached reads)
- Output: 20414 tokens
- Cost: $1.769906
- Wall-clock: 394s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
