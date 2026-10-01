---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-01T08:46:07Z cleared=none -->

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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T08:59:18Z
