---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `runs from source via Node.js, with dependencies resolved through the monorepo workspace` → `self-contained artifact` | The *monorepo-to-bundle* migration discipline. |
| `Option A: Single-file bundle (preferred)` + `Option B: Packaged directory` | The *two-option-with-preferred-choice* discipline. |
| Dynamic `import()` + SES `lockdown()` + WASM = three challenges | The *enumerated-challenges-with-named-mitigations* discipline. |
| `new URL('./endo-worker.cjs', import.meta.url).pathname` | The *resolve-sibling-via-import.meta-url* idiom. |
| Five-file `dist/` layout (daemon + worker + ses-shim + wasm + node binary) | The *all-artifacts-in-one-directory* discipline. |
| `<familiar-resources>/node <familiar-resources>/endo-daemon.cjs ...` launch | The *self-contained-from-resources* pattern; no system-PATH dependency. |
| `Target < 50MB for the daemon + Node.js combined` | The *size-budget-explicit* discipline. |
| `It's the same code, just packaged differently` | The *packaging-doesn't-change-product* invariant. |
| `interchangeable with the development daemon` via shared state directory | The *bundled-vs-development-daemon-interchangeable* discipline. |
| `None (can proceed independently of other Familiar work items)` | The *foundational-dependency-with-no-upstream* shape. |
| `bundled Node.js binary must be from a trusted source ... verify checksums` | The *supply-chain-checksum-verification* discipline. |
| `pinned bundled Node.js version per Familiar release` | The *version-pinning-per-release* discipline. |
