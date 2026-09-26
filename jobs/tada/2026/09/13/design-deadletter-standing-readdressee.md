Landed commit `4b3ad8adbb` on `main2`.

- Added `designs/dead-letter-standing-readdressee.md` and indexed it in `designs/README.md`.
- Surveyed the live deadmail state, origin report, message bus, completion teardown, promotion service, and prior withdrawn verdict-addressee design.
- Designed completion-safe unread-to-deadmail handoff, context-carrying continuation jobs, and explicit `live`/`staged`/`readdressed` sender receipts.
- Rejected permanent per-job addressees, role fan-out, and maintainer fallback because they create duplicate readers, persistent state, or noise.
- The design has no unresolved maintainer questions, so it landed directly without a review PR.
- Checks: `git diff --check` and `git show --check` succeeded; local HEAD matches `origin/main2`.
- Follow-up: implementation remains a future build.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-deadletter-standing-readdressee.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 610s

<!-- garden-usage-end -->
