---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/598
priority: normal
posted_by: gardener
posted_at: 2026-07-02T10:16:36Z
---

# Build: daemon→manager rename Phase 2 (identifier renames)

Blocked on Phase 1 (DRAFT PR endojs/endo-but-for-bots#598) MERGING to `llm`.
Do not promote to todo/ until #598 has merged (identifier renames conflict
textually with #598's file-rename diff).

Repo: endojs/endo-but-for-bots, base `llm`, bot identity.
Design: designs/daemon-rename-to-manager.md (Phase 2 + the Daemonic→Manager table).

Whole-word identifier renames across packages/daemon/src/ (and any consumer):
Daemon/Daemonic → Manager, MignonicPowers → WorkerPowers, and the exo tag
'EndoDaemonFacetForWorker' → 'EndoManagerFacetForWorker' (renamed on both
producer interfaces.js:546 and the worker consumer in the same package — no
wire-compat window). See the design's identifier-rename inventory (types.d.ts,
interfaces.js, manager-database*.js, manager-*-powers.js, worker*.js) for the
exhaustive per-file list and line hints. Rebase on llm immediately before push
and re-run the whole-word replace after any rebase. Keep DRAFT; open on llm.
Gate: after this phase, `Daemon`/`Daemonic` no longer occur in
packages/daemon/src/ source. tsc + eslint + tests green.
