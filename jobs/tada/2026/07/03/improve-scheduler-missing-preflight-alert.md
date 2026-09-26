Inbox empty. Work complete and pushed.

## Completion report

**Job:** Stop the scheduler from silently re-WARNing every cycle about a named-but-missing preflight gate; escalate once instead.

**What I found:** Both the referenced preflight script (`scripts/jobs/gardening/xs2rust-endor-press-preflight.sh`) and a prior round of scheduler hardening already exist on `main2` (landed 2026-07-03 morning). The `preflight:` path in the schedule is correct and the script is present. So the live per-cycle WARN the job cited is **deploy-lag** — the deployed host predates those commits. The remaining gap versus the job's ask was in the *escalation design*: the code escalated via `message-user.sh` only after a 3-tick `preflight_missing_streak`, not a first-time `alert_maintainer` deduped on the schedule name.

**What I changed** (`scripts/jobs/scheduler.sh`):
- Folded a single **first-tick** escalation into `note_missing_preflight`, routed through **`alert_maintainer`** keyed `scheduler-preflight-missing-<schedule>` — the journal-worktree-keeper paging-key discipline the job asked for. Dedup is doubly guaranteed: by the existing per-`(schedule, resolved-path)` marker (already keeps the WARN to once per breakage) and by `alert_maintainer`'s own per-key throttle.
- Fail-open "work-present" default is unchanged; a merely-erroring (present) gate still never escalates; the deploy-lag diagnosis (script on `origin/main2` but absent locally) is folded into the same one escalation, keeping its distinct deploy-surface note.
- Removed the now-vestigial streak/threshold machinery (`preflight_missing_streak` frontmatter, `GARDEN_PREFLIGHT_MISSING_THRESHOLD`, `escalate_missing_preflight`); `write_schedule` drops the streak arg and any stale streak line is shed on the next re-stamp — no migration needed.

**Tests/docs:**
- Rewrote `run-test.sh` SUBTEST 8b to assert first-tick, deduped escalation (fixed its `GARDEN_ROOT` to the repo root so `alert_maintainer` can deliver).
- Updated `skills/schedule/SKILL.md` to describe the new behavior.
- `scheduler-preflight-deploy-lag-test.sh`: **14/14 pass**. Isolated SUBTEST-8b driver: **5/5 pass**. `bash -n`/shellcheck clean. (The full `run-test.sh` aborts at SUBTEST 6 on a pre-existing, change-independent flake — I confirmed the stock tree aborts identically — which blocks reaching 8b end-to-end in this standalone environment; validated 8b's logic in isolation instead.)

Pushed to `main2` as `1e5ccb552` (rebased over a concurrent commit).

**Follow-up:** The real-world live WARN is deploy-lag — deploying the affected host (`scripts/jobs/deploy-garden.sh`) brings the already-landed preflight script into its root and clears the condition. My change ensures that if a preflight is ever genuinely never-landed or mistyped, it now pages the maintainer once instead of dispatching indefinitely.
