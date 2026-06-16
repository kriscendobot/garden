---
title: Abstract
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

The §opening Problem block (lines 10-23) frames the gap: *The Endo daemon currently runs from source via Node.js, with dependencies resolved through the monorepo workspace (`packages/daemon` imports from `@endo/captp`, `@endo/exo`, `@endo/marshal`, `ses`, etc.). This is fine for development, but the Familiar Electron application needs to ship the daemon as a self-contained artifact that can be spawned with a bundled Node.js executable on the user's platform*. The §four requirements: (1) run with standalone Node.js binary, not the monorepo; (2) all `@endo/*` dependencies bundled or co-located; (3) worker processes spawnable from the bundle; (4) platform-specific native modules handled. The §Design (lines 25-124) decomposes into seven subsections. The §two-option bundle strategy: Option A *Single-file bundle (preferred)* uses `@endo/bundle-source` or esbuild to produce a single `.cjs` file (`esbuild packages/daemon/src/daemon-node.js --bundle --platform=node --target=node20 --outfile=dist/endo-daemon.cjs`); Option B *Packaged directory* copies the daemon package and its `node_modules` into a self-contained directory (avoids bundler complexity, larger artifact). The §three challenges for Option A: dynamic `import()` for workers/weblets/guest code (can't be statically bundled because they load user-provided code at runtime); `ses` package modifies JavaScript globals at import time via `lockdown()` (bundlers must preserve this side effect); the OCapN-Noise WASM module needs co-location. The §three mitigations: worker entry points and SES shim can be bundled as separate artifacts alongside the main daemon bundle; the main bundle includes everything except dynamically loaded user code; WASM files are copied alongside the bundle. The §worker process bundling: daemon spawns workers via `daemon-node-powers.js` using `child_process.fork()` or `popen.spawn()`; each worker runs `worker.js` as its entry. The §discipline: *The daemon should resolve the worker entry point relative to its own location* via `new URL('./endo-worker.cjs', import.meta.url).pathname`. The §Node.js executable: platform-specific binary — macOS (`node` arm64 + x86_64); Linux (`node` x86_64 + arm64); Windows (`node.exe` x86_64). The §launch command pattern: `<familiar-resources>/node <familiar-resources>/endo-daemon.cjs <sock-path> <state-path> <ephemeral-state-path> <cache-path>`. The §five-file build artifacts (`dist/endo-daemon.cjs` + `dist/endo-worker.cjs` + `dist/ses-shim.cjs` + `dist/ocapn-noise.wasm` + `dist/node-<platform>-<arch>`). The §build script: `packages/daemon/scripts/bundle-daemon.js` (or new `packages/familiar-build` package). The §Affected packages: `packages/daemon` (add bundle configuration, resolve paths relative to bundle); new build tooling. The §Dependency: *None (can proceed independently of other Familiar work items)*. The §Security Considerations: *no change in security posture* (bundled daemon runs with same authority as unbundled); *bundled Node.js binary must be from a trusted source (official Node.js releases). Consider verifying checksums during the build*; *the bundle should not include development-only code or test fixtures*. The §Scaling: bundle-size matters for Electron distribution; target *< 50MB for the daemon + Node.js combined (Node.js alone is ~40MB)*; tree-shaking can reduce bundle size. The §Test Plan: smoke test (run bundled daemon with bundled Node.js, connect via CLI, verify basic operations); worker test (workers spawn from bundle); cross-platform CI test (macOS + Linux). The §Compatibility: *the bundled daemon must produce the same Unix socket protocol, CapTP messages, and persistence format as the unbundled daemon. It's the same code, just packaged differently*; *the bundled daemon should use the same state directory (`~/.local/state/endo/`) so it's interchangeable with the development daemon*. The §Upgrade: *the bundled daemon may be a newer version than the user's state directory expects. The daemon's existing upgrade/migration logic applies*; *the bundled Node.js version should be pinned per Familiar release*.
