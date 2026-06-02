---
ts: 2026-06-02T23:16:14Z
kind: result
role: builder
host: endolinbot
repo: kriskowal/garden
project: garden
to: liaison
dispatch_root: /home/kris/dispatches/builder--0ed69c
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/02/230207Z-dispatch-liaison-0ed69c.md
  - https://github.com/kriskowal/garden/pull/3
  - https://github.com/kriskowal/garden/pull/3#issuecomment-4607743752
---

# result: builder, garden #3 Phase 1 scripts/ layout pivot

Phase 1 of the driver design's `scripts/` layout pivot landed on
`design/driver`. Net diff against `b6a1318a`: 29 files changed,
1370 insertions, 241 deletions.

New head SHA: `1c7e27a218ab6f76b5a473099a221326a07772a2`.

## Commits

| SHA        | Subject                                                                                | Files |
| ---------- | -------------------------------------------------------------------------------------- | ----- |
| `564372ae` | `feat(scripts): top-level scripts/ layout, driver, daemons, systemd units (#3)`        | 15    |
| `52389684` | `feat(skills): driver state machine, prompt-on-failure capture, activity-feed watcher (#3)` | 5 |
| `e320bc6a` | `chore(driver): retire roles/driver/ in favor of scripts/driver/ (#3)`                 | 1     |
| `da83dac2` | `test(driver): update path references for scripts/driver/ (#3)`                        | 6     |
| `1c7e27a2` | `docs(claude): mention top-level scripts/ in Layout (#3)`                              | 2     |

## Verification

- `tests/driver/run.sh` exit code: `0`. All four suites pass:
  `test_skeleton.sh` (20 PASS), `test_design_only_happy_path.sh`
  (17 PASS), `test_loop_capture_and_self_improve.sh` (18 PASS),
  `test_trap_fires_on_error.sh` (4 PASS).
- `shellcheck -S warning` clean on the seven new bash scripts:
  `scripts/driver/driver.sh`, `scripts/daemons/{start,stop,status,logs}.sh`,
  `scripts/daemons/config.sh.example`,
  `scripts/watcher/endo-but-for-bots/watcher.sh`. The two
  `SC2034` warnings on `config.sh.example` for variables consumed
  by sourcing get explicit `# shellcheck disable=SC2034` directives.
- `bash -n` clean across `find scripts skills -mindepth 2 -maxdepth 4 -name '*.sh'`.

## Top-level PR comment

`https://github.com/kriskowal/garden/pull/3#issuecomment-4607743752`.
Summarizes the five commits, what landed, what's deferred to Phase
2-5, and the two judgment calls.

## Judgment calls

1. **`skills/driver-state-machine/` renamed to
   `skills/driver-pr-creation-state-machine/` rather than created
   side-by-side and deleted.** The body was already canonical and
   referenced from two siblings (`skills/cleaner/SKILL.md`,
   `skills/driver-design-only-pr-workflow/SKILL.md`). The rename
   preserved the content and the git history; cross-references
   were updated in the same commit as the rename.
2. **`skills/cleaner/` left in place.** The dispatch noted moving
   `skills/cleaner/cleaner.sh` was optional in Phase 1; the
   design's `§ Retired / superseded` flags it as eventually
   superseded but the migration plan leaves it in place through
   Phase 2-5 so existing references continue to resolve. Left as
   a known follow-up.
3. **`scripts/watcher/endo-but-for-bots/watcher.sh` shipped as a
   stub.** The script documents the contract in extensive code
   comments and exits cleanly with a "Phase 1 stub" message. The
   directory shape and the systemd-template wiring can be
   exercised end to end without committing to the substantive
   feed integration, which the design defers to Phase 2-5. The
   other three feed slugs named in the design
   (`endo-but-for-bots-poll`, `review-queue`, `assigned-issues`)
   are not even stubbed; the parent `scripts/watcher/README.md`
   names them and marks them deferred.
4. **`scripts/daemons/config.sh` ignored, `.example` checked in.**
   The host-local config is gitignored so each host can choose
   its own lane and feed set; the template is committed. The
   `.gitignore` entry was added as part of the docs commit.

## Deferred to Phase 2-5

Explicitly out of scope for this Phase 1 PR, per the design's
migration plan and the dispatch brief:

- The other three feed watchers
  (`endo-but-for-bots-poll`, `review-queue`, `assigned-issues`).
- The six non-`pr-creation` workflow state-machine skills:
  `observed-error`, `issue-response`, `build-request`,
  `design-request`, `retcon-rebase`, `ci-recovery`.
- `skills/gardener-inbox-error-reporting/SKILL.md` (the skill
  file; the executable `report-error.sh` already exists in
  `skills/gardener-inbox-error-reporting/` from a prior PR).
- `skills/driver-pre-ci-validation/SKILL.md` (the six-step
  format / typecheck / lint / test / docs gauntlet).
- Enabling any `systemd` user unit. The unit files land at
  `scripts/systemd/garden-driver@.service` and
  `scripts/systemd/garden-watcher@.service` but no
  `systemctl --user enable` runs in this PR.
- Retiring any existing scan-based system: the steward's
  PR-creation-flow scan, the contractor's slot machinery, and
  the standing-monitor daemons are all preserved per the
  migration plan.
- `roles/steward/`, `roles/general-contractor/`, `roles/monitor/`,
  and the per-project monitor skills (untouched in this PR).
- Moving `skills/cleaner/cleaner.sh`: left as a known follow-up
  per dispatch brief.

PR remains DRAFT. Garden's own PRs do not run the cleaner / panel
/ fixer / un-draft chain (CLAUDE.md § Conventions); the design-PR
exception is the rule.

Self-improvement: nothing this time.
