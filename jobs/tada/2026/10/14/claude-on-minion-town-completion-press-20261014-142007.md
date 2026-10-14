Completion press for kriscendobot/garden#89: the arc is nominal on the correct window, 2026-10-14 08:05:13Z → 14:20:07Z.

**What the report shows**
- **Roster (625 jobs):** 617 done, 6 parked in plan, 2 in progress, none queued, in orchestration, in a gauntlet or missing.
- **Activity:** 7 claims and 7 completions in the window.
- **Exceptions:** no new dooms, no stalled claims, no previously listed job missing without a completion report, and no completion flagged as a failed orchestration.
- **Carried dooms:** two jobs are still doomed as `requeue-exhausted` on endolin-garden-ece02cb4: `claude-on-minion-town-press-20261010-133536` and `kriscendobot-minion.town-pr181-gauntlet-fix-5`. The maintainer was already told about these, so they are context, not a new alert.
- **Journal entry:** posted as `entries/2026/10/14/200709Z-progress-gardener-6a18c8.md`.
- **Maintainer message:** none sent, because no alert condition was met.

**A bug in the report script, now fixed**
- **What went wrong:** the first run timed out at git's 120-second limit on this host. The second run finished, but it used the wrong window (2026-10-08 → 10-11) and produced three false alerts. The cause was in `schedule_window` in `scripts/jobs/completion-window-report.py`: it skipped any failed `git show` of the schedule file, including a timeout (exit 124). A timed-out read of a recent dispatch time was dropped, so the window slid back to older times without any error.
- **Fix:** I discarded that run. Commit `a546a53a13f` on main2 now skips only the case where the file is absent at that commit (exit 128) and fails loudly on anything else. The existing `completion-window-report-test.sh` passes.
- **Result:** after that, a rerun with `GARDEN_REPO_GIT_TIMEOUT=540` used the correct window and produced the figures above.

**Follow-up:** each run of this report takes about 6–8 minutes on oros-studio and goes past the default 120-second git limit. Future presses on this host should set `GARDEN_REPO_GIT_TIMEOUT` higher, or the report should get a larger default bound for its own git calls.

No board, worker or unit state was changed.

arc nominal: 625 roster jobs, 7 completed in-window, 8 outstanding, 0 new dooms
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-completion-press-20261014-142007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1061154 cached reads)
- Output: 7919 tokens
- Cost: $0.7946428000000001
- Wall-clock: 1130s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
