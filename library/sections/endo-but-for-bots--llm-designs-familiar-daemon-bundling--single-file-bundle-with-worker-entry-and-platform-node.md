---
title: The §problem framing — Endo daemon runs from source via Node.js with monorepo-workspace dependency resolution; the Familiar Electron application needs the daemon as a *self-contained artifact* that can be spawned with a bundled Node.js executable on the user's platform; four bundling requirements (run with standalone Node.js binary not monorepo / all `@endo/*` deps bundled or co-located / worker processes spawnable from bundle / platform-specific native modules handled); the §two-option bundle strategy — Option A (single-file `.cjs` bundle via esbuild, preferred for simplicity) vs Option B (packaged directory copying daemon + node_modules, larger artifact); the §three challenges + mitigations for Option A — dynamic `import()` for workers/weblets/guest code can't be statically bundled (mitigated by separate-artifact bundling of worker entry points and SES shim); `ses` package modifies globals at import time via `lockdown()` so bundler must preserve the side effect; OCapN-Noise WASM module needs co-location (mitigated by copying alongside bundle); the §worker process bundling — `daemon-node-powers.js` uses `child_process.fork()` or `popen.spawn()` to launch `worker.js`; the §worker resolution discipline — *the daemon should resolve the worker entry point relative to its own location* via `new URL('./endo-worker.cjs', import.meta.url).pathname`; the §Node.js executable shipping — platform-specific binary for macOS (arm64+x86_64), Linux (x86_64+arm64), Windows (x86_64); the §launch command pattern — `<familiar-resources>/node <familiar-resources>/endo-daemon.cjs <sock-path> <state-path> <ephemeral-state-path> <cache-path>`; the §five-file build artifacts (endo-daemon.cjs + endo-worker.cjs + ses-shim.cjs + ocapn-noise.wasm + node-<platform>-<arch>); the §build-script discipline; the §security note — *no change in security posture* but *bundled Node.js binary must be from a trusted source* with *checksums during the build*; the §scaling target *< 50MB for the daemon + Node.js combined* (Node.js alone ~40MB); the §compatibility invariant — *bundled daemon must produce the same Unix socket protocol, CapTP messages, and persistence format* and *use the same state directory `~/.local/state/endo/`* so the bundled daemon is *interchangeable* with the development daemon; the §upgrade — *pinned bundled Node.js version per Familiar release*
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--abstract.md)
- [Body](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node--common-confusions.md)
