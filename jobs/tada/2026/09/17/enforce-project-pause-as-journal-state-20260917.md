The deployed root is clean (my accidental edits there were fully reverted, no git ran there), and the commit is live on `origin/main2`. The job is complete.

## Completion report

**What I built:** made a project PAUSE enforceable by machinery, not just deployed prose — closing the gap that let a stale leader run ~60 IronHorse fuzz jobs a week after the 2026-09-09 pause its deployed code predated.

**Journal-backed representation (item 1).** A pause is now a record `pauses/<slug>.md` on `journal2`, naming the project, authorizing maintainer, directive, date, scope, and optional `match:` patterns; its existence means paused. `scripts/jobs/pause-project.sh` (`<slug> on … | off | status | list`) arms/lifts/inspects it, CAS-raced onto the journal like `brake-foreman.sh`. Drift control: the record embeds the directive and points back at COMMON.md, the tool prints a "now update COMMON.md" reminder on every arm/lift, and `roles/COMMON.md` § Project scope now points at the record + tool and states that lifting means clearing both.

**Enforcement at the chokepoints (item 2).** New `common.sh project_pause_hit` predicate is wired into:
- `post-job.sh` / `post-plan.sh` — refuse to post/park paused work (`rc 78`).
- `claim-job.sh` — skip a paused todo job already on the board (defense in depth against a stale producer that already posted).
- `promote-plan.sh` — refuse to promote a paused plan item, **even under `--maintainer`** (promoting a parked paused item is exactly what re-armed the storm; the authorized path is to lift the pause).

**Fail safe toward paused (item 3).** The slug comes from the record's filename, always readable, so a present-but-corrupt record still blocks matching jobs — mirroring `foreman_braked`. Blast radius bounded: no record ⇒ no restriction; an unreadable record blocks only jobs naming its slug.

**Coalesced alerting (item 4).** `common.sh note_project_pause_block` routes through `alert_maintainer` keyed `project-pause-active-<slug>`, so `watchdog-notice.sh` folds all occurrences into one entry per project — never sixty messages for one cause.

**Leader staleness (item 5).** `root-repo-guard`'s stalled-deploy watch gained a leader-only commits-behind fuse (`GARDEN_DEPLOY_STALL_COMMITS_LEADER=25`) plus pause-aware wording. Kept as one signal in the guard (which already owns "the deployed tree is wrong") rather than a new unit.

**Tests:** `scripts/jobs/test/project-pause-enforcement-test.sh` — 21 assertions, all green: post/park/claim/promote refusal, the predicate, the unreadable-record fail-safe with bounded blast radius, an unpaused control, lift re-opening the chokepoints, and per-project alert coalescing. Confirmed the 2 failures in `promote-plan-doom-reset-test` are pre-existing on the pristine base (reaper-related, unrelated to this diff); adjacent tests (foreman-brake, post-loop-deadline, shepherd-budget, ranked-promotion, etc.) pass. Shellcheck clean.

**Honored the pause:** did not lift the IronHorse pause, un-park any of the 67 parked items, or run any IronHorse work — read-only inspection only.

**Follow-up (operator, post-deploy):** arm the live record once this deploys — `scripts/jobs/pause-project.sh ironhorse on --maintainer kumavis --directive "kriscendobot/garden#91, 2026-09-09" --scope "all IronHorse implementation/review/test262/fuzz/optimization/follow-up work"`. I left the live-journal write to the liaison deliberately (arming before the reading code is deployed is a no-op, and it's an operator act). A minor known limitation worth a future janitor: a paused job stuck in `todo/` is inert but lingers (the reaper scans only `doin/`); it only produces the coalesced alert.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/enforce-project-pause-as-journal-state-20260917.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 194 tokens (16363168 cached reads)
- Output: 84623 tokens
- Cost: $12.610150999999997
- Wall-clock: 1127s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
