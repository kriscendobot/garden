---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1371
priority: normal
posted_by: builder
posted_at: 2026-10-01T05:25:24Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: bump @endo/claude PINNED_CLI_VERSION to the deployed claude CLI

Repo: endojs/endo-but-for-bots, base `llm` (after #1371 merges).
Requested by kriskowal's approving review on #1371 ("conduct and build"):
https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317 — this builds a named follow-up from
#1371's live-turn evidence comment (https://github.com/endojs/endo-but-for-bots/pull/1371, "Named follow-ups", item 5).

Bump `PINNED_CLI_VERSION` from 2.1.232 to the deployed CLI (2.1.280 at last check) after re-running the negative confinement checks against it (env scrub, no socket fds, refused smuggled ids). Note/handle that 2.1.280 `init` reports `permissionMode: default` and builtin plugins `agents-md`/`telemetry` even under `--bare`.

Open a DRAFT PR via ensure-pr.sh; cross-link #1371.
