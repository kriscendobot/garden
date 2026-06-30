Done. Pushed to `main2` as `edd1656a6`.

## Completion report

**Job:** Move "place the precise dependabotany maturity recheck" off the maintainer/agent and into a deterministic schedule write in the botanist's embargo step.

**What I found:**
- `scripts/jobs/set-schedule-once.sh` already exists and self-deletes the schedule file in the same CAS commit when it fires — exactly the one-shot primitive the job needs. `skills/schedule/SKILL.md` already documents both `cadence:` and `once:` schedule kinds.
- The gap was entirely in `roles/botanist/AGENT.md`, whose EMBARGO disposition wrote only the cron-aligned daily heartbeat and carried a now-stale note asserting "a true single future dispatch is not expressible with the primitive" / "do not invent a per-PR schedule."

**What changed (`roles/botanist/AGENT.md`):**
1. Rewrote the **EMBARGO/DEFER → schedule the re-evaluation** bullet into a two-leg design:
   - **Primary:** a deterministic precise one-shot per PR via `set-schedule-once.sh dependabotany-recheck-<project>-pr<N>` at the computed maturity floor. The floor = upstream publish instant + 7 days; the recheck instant = **ceil-to-hour + 15m epsilon** (`recheck=$(( ((floor+3599)/3600)*3600 + 900 ))`), guaranteeing the fire time lands strictly past the floor regardless of clock skew or cron alignment. Includes a copy-pasteable `date`-based snippet. The one-shot self-deletes after firing.
   - **Backstop:** the existing daily heartbeat is retained only as a safety net for a lost one-shot.
   - Replaced the stale "not expressible" rationale with a "Why both legs" note that cites the #197 22:43Z-floor / ~8h-early-heartbeat / hand-created-23:00Z case and explicitly says not to reintroduce the old note.
2. Updated the matching **anti-pattern** and **Definition of done** lines to require the precise one-shot + the daily backstop (not the daily schedule alone).

**Verification:** Validated the ceil-to-hour+15m arithmetic against the #197 example (22:43:11Z floor → 23:15:00Z recheck, strictly past the floor) and the on-the-hour boundary case (22:00:00Z → 22:15:00Z). Grepped roles/skills/scripts/designs for other `dependabotany-recheck` / "daily recheck" references — none outside the botanist role, so no further docs drift.

**Follow-ups:** None required. The naming convention (`dependabotany-recheck-<project>-pr<N>`) matches the maintainer's prior hand-created one-shot, and the deployed garden root will pick this up on its next deliberate deploy of `origin/main2`.
