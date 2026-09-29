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
