The job's requested behavior is already fully implemented on `main2` and I've verified it passes its tests. Here is my report.

---

## Completion report: `improve-scheduler-escalate-missing-preflight`

**Outcome: no code change needed — the requested behavior already landed on `main2` and I verified it end-to-end.**

### What I found
The job asked to keep the scheduler's fail-open for a missing/non-executable `preflight:` gate but add a deterministic, deduplicated escalation to the maintainer inbox so a genuinely-absent gate surfaces exactly once instead of re-WARNing forever. That work was already committed to `main2` **~20 minutes before I claimed this job** (claim 13:22:29Z), by two commits:

- `6f0e35c05` "scheduler: escalate a persistently not-found preflight gate"
- `3e51f3f35` "scheduler: dedup missing-preflight WARN and diagnose it as deploy-lag" (current HEAD)

`scripts/jobs/scheduler.sh` now implements exactly what the spec requested, and more:
- **Fail-open preserved** — a not-found gate is still treated as work-present; a schedule is never starved.
- **WARN-once marker keyed on schedule name** — `note_missing_preflight` / `preflight_missing_marker` under `$GARDEN_STATE` (per-host, never committed) suppresses the per-tick WARN after the first, re-arming when the gate reappears (`clear_missing_preflight`).
- **Maintainer-inbox escalation, deduplicated** — a `preflight_missing_streak` counter in the schedule frontmatter escalates via `message-user.sh` (the maintainer inbox, same surface the reaper uses) exactly once when the streak hits `PREFLIGHT_MISSING_THRESHOLD` (default 3); an erroring-but-present gate is distinguished and does not count.
- **Bonus deploy-lag diagnosis** — when the missing gate exists on `origin/main2` but not in the deployed root, it's diagnosed as deploy-lag and surfaced once to the deploy state dir + message bus, pointing at the pending deploy.

### Verification
- `scripts/jobs/test/scheduler-preflight-deploy-lag-test.sh` → **14/14 PASS** (WARN-once marker, deploy-lag note, maintainer message, and re-arm-on-clear).
- **SUBTEST 8b** (escalate-after-N) from `run-test.sh` → **9/9 PASS**. The full `run-test.sh` harness aborts at SUBTEST 6 on a documented live-fleet flake (a maintainer message without `reply_to` leaking into `head -1`, unrelated to the scheduler and triggered by running inside a live gardener fleet), so I lifted SUBTEST 8b into a standalone hermetic harness to confirm the escalation path directly: both gates fail open, streak increments only for the not-found gate, escalation fires exactly once at threshold and never re-fires past it.

Working tree is clean (`HEAD=3e51f3f35`); I made no edits, and none are warranted. Throwaway test fixtures cleaned up. Nothing to commit/push.

### Follow-ups
- None required. The stale job is effectively resolved by the already-landed commits; this claim just confirmed and independently re-verified the behavior.
- (Environmental note, not part of this job) `run-test.sh` is fragile when run by a live gardener under fleet load — SUBTEST 6's `maintainer-reply`/`head -1` step can pick up a message lacking `reply_to` and abort the whole `set -e` harness. Worth hardening separately if the fleet frequently runs the full suite in-band, but out of scope here.
