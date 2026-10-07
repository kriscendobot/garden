# Completion report: improve-design-build-dispatch

Designer completions now hand off their build in a script, so a design whose build is already owned or can be posted no longer gets blocked and re-run by the reaper. Pushed to `main2` as `b736c020d8c`. The new regression test passes, as do the existing `followup-posted-gate-test.sh` and `follow-up-seen-cursor-test.sh`. The change is not deployed yet.

## What went wrong
`design-minion-town-oauth-bonds` opened draft design PR kriscendobot/minion.town#168, and its gauntlet was staged. Its `## Follow-ups` section then said "The build is one builder job". That build already existed: it was `build-minion-town-oauth-bonds`, the parked next child of `orch-minion-town-oauth-bonds`. But the report gave the gate nothing it could check, so `assert-followup-posted.sh` blocked the completion at 22:13:39Z and a finished design went back to the reaper.

## What changed
- **New `scripts/jobs/design-build-handoff.sh`.** `gardener.sh` runs it just before the follow-up gate. It always exits 0.
  - **When it acts:** the job's role is designer, its follow-ups mention a build, and the report's first PR citation is the design PR. It recognises the design PR from the PR-keyed gauntlet: either a live record with `build_job: <base>`, or that gauntlet's completed tada report.
  - **What it does, in order:**
    1. Reuses the orchestration's next child if it is on the board.
    2. Otherwise reuses an existing `build-<slug>` job.
    3. Otherwise posts `build-<slug>`. If the design gauntlet already passed, it goes to `todo/`. If the gauntlet is still running, it is parked as `gate: blocked` with `blocked_on: <gauntlet-base>`. That parked plan is the typed recheck: `unblock.sh` promotes it when the gauntlet finishes, or holds it and notifies once if the gauntlet fails.
  - **When it stops:** a gauntlet that finished without passing gets no build.
  - **Marker:** after a fresh board read shows the successor, it appends `<!-- garden-design-build-handoff: successor=… state=… pr=… -->` to the report.
- **Marker choice:** this is a separate marker, not `<<<GARDEN-JOB-HANDED-OFF:…>>>`. The design itself is finished, so `complete-job.sh` must not stamp it `deliverable-complete: false`. If the report already ends in a handoff, failure or auth-unavailable signal, the script does nothing.
- **`common.sh`:** two new helpers, `report_design_build_handoff_successor` and `design_build_handoff_verified`.
- **The gate and the sweep both accept a verified marker.** In the gate (`assert-followup-posted.sh`) it is a new fifth disposition. The async sweep (`follow-up.sh`) skips such reports. A marker naming a job that isn't on the board still blocks.
- **`roles/designer/AGENT.md`:** new norm telling designers to name the build plainly and not post a duplicate.
- **New test `scripts/jobs/test/design-build-handoff-test.sh`.** It replays the oauth-bonds incident: the raw report is blocked, and passes once the handoff runs. It also covers:
  - a second run adds no second marker;
  - the parked `blocked_on` plan, and the direct post to `todo/`;
  - a halted gauntlet gets no build;
  - an existing build job is reused;
  - the no-op cases: wrong role, no build in the follow-ups, a gauntlet staged by another job, a report ending in a handoff;
  - a marker naming a missing job is still blocked.

## Follow-ups
- `design-minion-town-oauth-bonds` is still in `doin`. A requeue will only pass on its own once this change is deployed to that host. Its build is still owned by `orch-minion-town-oauth-bonds`.
- This is separate from the existing `DESIGN-BUILD-RECHECK` path in `handlers/follow-up-claude.sh`. That path waits for a cross-referenced build PR to appear and never posts the builder job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-design-build-dispatch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4835553 cached reads)
- Output: 32631 tokens
- Cost: $2.7881865999999995
- Wall-clock: 635s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
