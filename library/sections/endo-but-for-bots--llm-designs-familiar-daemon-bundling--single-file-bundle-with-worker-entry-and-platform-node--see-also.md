---
title: See also
source: designs/familiar-daemon-bundling.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-05
source_authors: [Kris Kowal (prompted)]
source_lines: "1-162 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-ninth endo-but-for-bots design ingest. **Status:
  Complete**. The 161-line design documents the *daemon-bundling*
  for the Familiar Electron application — *self-contained artifact
  that can be spawned with a bundled Node.js executable on the
  user's platform*. Cycle 113 ingests this as the **second** of
  cycle 109's three named dependencies (cycle 111 was the first,
  familiar-gateway-migration; cycle 109's third dependency,
  familiar-unified-weblet-server, remains queued).
  
  Three structurally interesting moves: (1) the *two-option-
  exploration-with-preferred-choice* shape — Option A (single-file
  bundle via esbuild) vs Option B (packaged directory); the design
  explicitly names both and picks A with rationale; (2) the
  *three-challenges-with-three-mitigations* discipline — dynamic
  `import()` for runtime-loaded user code + SES `lockdown()` global
  side effects + OCapN-Noise WASM co-location — each challenge
  has a named mitigation; (3) the *worker-resolve-relative-to-
  bundle-location* discipline via `new URL('./endo-worker.cjs',
  import.meta.url).pathname` — the daemon doesn't search PATH or
  use cwd-relative paths; the worker entry point sits next to the
  daemon bundle. The §compatibility-invariant — *the bundled
  daemon must produce the same Unix socket protocol, CapTP
  messages, and persistence format ... It's the same code, just
  packaged differently* — and the §state-directory-shared
  discipline (`~/.local/state/endo/` is the same for both bundled
  and development daemons) means the *bundled daemon is
  interchangeable with the development daemon*, supporting the
  cycle 109 Familiar's *play well with existing daemons* discipline.
  
  Single-section cohesion-honest ingest.
parent: endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node
---

- [[daemon]] (topic) — the endo daemon architecture; this design produces the deployable daemon artifact.
- `endo-but-for-bots--llm-designs-familiar-electron-shell--*` (cycle 109) — names this design as one of three required dependencies. The Familiar Electron Shell *consumes* this bundle.
- `endo-but-for-bots--llm-designs-familiar-gateway-migration--*` (cycle 111) — the *first* of cycle 109's three named dependencies; this is the *second*.
- `endo-but-for-bots--llm-designs-familiar-unified-weblet-server` (queued; In Progress) — the *third* of cycle 109's three named dependencies.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — daemon-side feature that runs in any bundled or unbundled daemon (same code).
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — daemon-side feature.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — daemon-side meta-framework.
