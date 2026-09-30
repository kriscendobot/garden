`ci-wait-merge.sh` now recognises GitHub Actions account-billing refusals and returns exit 5. It alerts the maintainer itself, and the gauntlet parks on it resumably, so no agent has to decide what to do. Pushed to `main2` as `878c5d5299f`.

**What changed**
- **Recognising the refusal (`ci-wait-merge.sh`).** When CI is red with nothing still running, a new `actions_billing_blocked` check reads the annotations on every failed Actions job, using the job id from the check's `detailsUrl`.
  - It only counts as billing-blocked if **every** failed check carries GitHub's message: "recent account payments have failed" or "spending limit needs to be increased".
  - Any other outcome stays ordinary red (exit 3): an unreadable annotation, a failed check that isn't an Actions job, or a mix of billing and real failures.
  - When it matches, it alerts the maintainer under one key per owning account (`actions-billing-blocked-<owner>`), so every red PR on that account adds to the same inbox entry. The alert says how to recover: fix billing, rerun the failed jobs, resume the gauntlet.
  - It prints a `CI BILLING-BLOCKED` status line and exits 5. The header comment documents the new code.
- **Parking the gauntlet (`gauntlet.sh`).**
  - The clean and fix stage instructions now map exit 5 to a new result marker, `ci-billing-blocked`. They tell the agent not to rerun, push, message anyone, or report `orchestration-failed`.
  - The driver handles that marker with a new `park_ci_billing` function. It stops the gauntlet with a distinct status (`gauntlet-status: parked-ci-billing`, `orchestration-status: halted-ci-billing`). Nothing downstream will read that as success.
  - The parked report keeps what's needed to restart and names the exact `--resume-from-stage` command.
  - The PR gets a matching final status comment, and the maintainer gets a notice under the key `<g>-parked-ci-billing`.
  - `--resume-from-stage` now accepts a parked gauntlet as well as a halted one.
- **Docs:** the conductor brief lists exit 5 (stall `ci billing-blocked`, don't send a shepherd). The shepherd's 2026-09-30 field note now says the script handles this case.

**Tests**
- `ci-wait-merge-test.sh`: new tests T29–T32 all pass:
  - all failures are billing refusals → exit 5, with and without `--no-merge`
  - one billing refusal plus one real failure → 3
  - annotation read fails → 3
  - a failed non-Actions status → 3
- `gauntlet-resume-test.sh`: 11/11. New cases check that a `fix=ci-billing-blocked` result parks the gauntlet without retrying or re-posting the stage, notifies the maintainer, and can be resumed at fix round 3.
- `gauntlet-panel-quota`, `gauntlet-pin-gate`, `auto-gauntlet-handoff` and `reaper-gauntlet-handoff` pass.
- Two failures happen the same way on an unmodified copy of `origin/main2`, so this change didn't cause them:
  - `ci-wait-merge-test` T8 (the stale-`GARDEN_GH` fallback)
  - `gauntlet-test` "tick 1: todo=[]"

**Follow-ups**
- The two failing tests above need someone to look at them.
- The minion.town#144 gauntlet halted before this change, so it can't be resumed. `--resume-from-stage` only accepts a halted gauntlet report, and the #144 gauntlet's report has no such status. Once billing is fixed, #144 needs a fresh `run the gauntlet`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-actions-billing-ci-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3753970 cached reads)
- Output: 25669 tokens
- Cost: $2.304678
- Wall-clock: 337s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
