# PR #58 — diagnose the test-vs-local race; make the error bubble watch for the stack trace (maintainer design)
Repo: endojs/endo-but-for-bots (bot). PR #58 — *error tracing across CapTP workers* —
https://github.com/endojs/endo-but-for-bots/pull/58 — reviewDecision CHANGES_REQUESTED.
**Status:** the garden claimed "now renders all three in Chrome" (01:26). kriskowal still does **not**
see the **disclosure triangle or worker chip locally** (comment 4850565566, 2026-07-01T05:31Z). So it
passed in the garden's test env but **fails in real local usage** — a timing/race difference.
**Maintainer's hypothesis + design (follow it):**
> This might be due to a race, a difference in timing under test versus local usage. Please check the
> hypothesis by direct inspection of the system. If a race is possible, we should have the error bubble
> **watch for the identified error to discover a stack trace, and cancel that watch when the error bubble
> is dismissed (by the next command submitted).**
**Task:**
1. **Check the race hypothesis by direct inspection** of the system: determine why the disclosure
   triangle + worker chip render in the test harness but not in local usage — i.e. the ordering between
   when the error bubble renders and when the stack trace / worker info actually arrives (they likely
   arrive *after* the initial synchronous error render locally).
2. **Implement the maintainer's design:** the error bubble **watches** for the identified error to
   discover its stack trace (reactively, so it attaches the disclosure triangle + worker chip whenever
   the trace arrives, not only if present at first render), and **cancels that watch when the bubble is
   dismissed** — i.e. when the next command is submitted. No leaked watchers.
3. **Verify under REAL LOCAL-USAGE conditions, not the test harness** — this is the crux: the prior
   "verified" passed in test but failed locally because of the race. Reproduce the race, confirm the fix
   makes the triangle + chip appear reliably in actual Chrome local usage (with real timing), and
   confirm the watch is cancelled on the next command. Capture concrete evidence.
4. Reply on #58 with: the race diagnosis, the watch/cancel implementation, and the **real local-usage**
   verification evidence. Verification-integrity: passing in test ≠ verified; cite the real-usage run.
Bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 7
  claimed_at: 2026-07-01T05:33:11Z
