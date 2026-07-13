---
role: builder
---

Build the unconfined `@endo/reminder` message-scheduler plugin in `endojs/endo-but-for-bots` (base `llm`) per the now-mergeable design PR #682 — carry over the Phase 1/2/3 interval-scheduler substance (start-to-start ticks, resolve/reschedule with backoff, tick-timeout auto-resolve, host limits, pause/resume/revoke, startup recovery with missed-tick coalescing) as an unconfined plugin with a vfs-backed durable-persistence seam instead of node-fs coupling, advancing M3's scheduled-execution exit-criterion leg now that the superseded daemon-formula PRs #609/#617/#619 are closed.
