## Completion report

**Job:** `improve-wire-scholar-preflight-into-live-schedule`

**What was wrong:** The live `schedules/scholar-library-cycle.md` on `origin/journal2` carried no `preflight:` frontmatter line, so the deterministic gate (`scholar-preflight.sh`) was dark. The scheduler dispatched an LLM scholar agent every hour regardless of whether claimable work existed, burning dispatches and writing low-value `result` entries.

**What I did:**
- Confirmed the live schedule's frontmatter was only `cadence` / `last_dispatched` / `job_basename_prefix` — no `preflight:` line.
- Re-raced the schedule onto `origin/journal2` with the gate set:
  `GARDEN_SCHEDULE_PREFLIGHT=scholar-preflight.sh scripts/jobs/set-schedule.sh scholar-library-cycle hourly scholar-library-cycle <body-file>`
- **Body-preservation precaution:** `set-schedule.sh` rewrites the body from its body-file/stdin argument; with no tty it would have read empty stdin and clobbered the rich schedule body. I first extracted the existing body to a file and passed it as the 4th argument, so the body survived byte-for-byte.

**What changed (journal state only, on `origin/journal2`):**
- `schedules/scholar-library-cycle.md` now carries `preflight: scholar-preflight.sh`.
- `last_dispatched: 2026-06-29T14:20:49Z` preserved; body verified byte-identical to before.
- No `main2` change was required — `scheduler.sh` (preflight handling) and `scholar-preflight.sh` already existed; the only gap was the missing frontmatter line.

**Verification:**
- Re-fetched `origin/journal2` and confirmed the `preflight:` line is present and the body diff is empty ("BODY IDENTICAL").
- Ran `scholar-preflight.sh scholar-library-cycle.md` live → exit 2 ("no work… empty inbox, no scholar-* job, no fresh role/scholar broadcast"), confirming the gate executes and would now advance the clock without dispatching under the current idle condition.

**Effect:** The idle/active decision is moved off the dispatched agent into plain code. Back-to-back idle scholar dispatches and their `result`-entry journal noise are eliminated, while real work still gets instant pickup (preflight exit 0 the moment an inbox ask, a `scholar-*` board job, or a fresh `role/scholar` broadcast appears).

**Follow-ups:** None required. The scheduler preserves the `preflight:` line across future `last_dispatched` stamps, and `set-schedule.sh` preserves it across future cadence changes, so the wiring is durable.
