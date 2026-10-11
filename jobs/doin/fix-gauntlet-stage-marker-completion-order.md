---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: gauntlet stage prompts tell workers to put the stage-result marker on the LAST line, which collides with the completion signal

**Defect.** `scripts/jobs/gauntlet.sh` renders every stage body (viability ~l.947, clean ~l.989, panel ~l.1027, fix ~l.1062, undraft ~l.1093) with "END your completion report with EXACTLY ONE of these marker lines (last line):". The harness separately requires `<<<GARDEN-JOB-COMPLETE>>>` as the last non-blank line (`report_has_completion_marker`, `scripts/jobs/common.sh`). A worker that obeys the stage prompt literally emits the completion marker and THEN the stage-result marker, so completion is never detected. The job is requeued and session-resumed, repeats the same ending, and is reaper-doomed `requeue-exhausted`. That halts the gauntlet.

**Incident.** `kriscendobot-minion.town-pr174-gauntlet-panel-7` (2026-10-10/11): the panel really ran and posted review 5478567414 on kriscendobot/minion.town#174, then got about 26 resumed sessions, each ending `<<<GARDEN-JOB-COMPLETE>>>` followed by `<!-- gauntlet-stage-result: panel=must-fix -->`. It was doomed three times and the gauntlet halted with `stage_retries` exhausted. That was about $8 of wasted spend.

**Fix (pick the robust one, add a test):**
- Reword all five stage prompts so the marker goes immediately BEFORE the completion signal, not "last line". `gauntlet.sh` already greps the marker anywhere in the report.
- Harden the completion check as well: accept a report whose last non-blank line is a `<!-- gauntlet-stage-result: ... -->` marker and whose line just before it is the completion marker. Normalize it (strip the completion marker, keep the stage marker). This rescues already-posted stage bodies and old workers. Keep the forgery guard: the completion marker must still be adjacent to the end, not quoted mid-report.
- Add a test under the existing gardener/complete-job test suite covering both orderings.

Land on main2 per the usual CAS push.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-11T06:30:43Z
