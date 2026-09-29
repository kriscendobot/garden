---
gate: awaiting-maintainer
maintainer_question: 'Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1383
priority: normal
posted_by: producer
posted_at: 2026-09-29T22:47:41Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Endo CLI: ENDO_NO_AUTOSTART + lifecycle exit-code contract (phase 2)

Repo: endojs/endo-but-for-bots, base `llm` (DRAFT PR). Design: https://github.com/endojs/endo-but-for-bots/pull/1383 (designs/daemon-lifecycle-idempotency.md). Motivation: kriscendobot/minion.town#130 and #137 deploy workarounds.

Implement §§ 3 and 6: add `ENDO_NO_AUTOSTART=1` and a global `--no-start` option honored by `provideEndoClient` (packages/cli/src/client.js), exiting 3 "not running" instead of calling `start()`. Make packages/cli/bin/endo.cjs propagate `main()`'s return value as the exit code. `endo status` derives running from a socket probe and exits 3 when down. Implement the documented codes for `start` and `stop` (0 = desired state reached, including already-running and already-stopped; 75 = not ready in time). Resolve the design's open questions 1 and 3 per the maintainer's answer on the design PR first.

<!-- garden-annotation: key=mt117-cite by=deadmail-20260929T225705Z-deb454 at=2026-09-29T23:08:57Z -->

Also cite kriscendobot/minion.town#117 (kriskowal review note asking for idempotent daemon start/stop), alongside kriscendobot/minion.town#130 and kriscendobot/minion.town#137, in the PR body and commit message. The exit-code contract must make `endo start` exit 0 as a no-op when a healthy daemon already owns the socket, and `endo stop` exit 0 as a no-op when nothing runs, so a supervisor can rely on them. (Carried from dead-lettered message, job deadmail-20260929T225705Z-deb454.)
