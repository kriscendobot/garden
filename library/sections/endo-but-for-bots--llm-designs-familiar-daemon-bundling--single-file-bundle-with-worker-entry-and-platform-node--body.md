---
title: Body
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

### §The four-requirement framing

The §lines 19-23:

> The daemon must be packaged such that:
> 1. It can run with a standalone Node.js binary (not the monorepo).
> 2. All `@endo/*` dependencies are bundled or co-located.
> 3. Worker processes can be spawned from the bundle.
> 4. Platform-specific native modules (if any) are handled.

The §four requirements are *the invariants the bundle must satisfy*; each subsequent design subsection addresses one or more of them:

- **Requirement 1** (standalone Node.js) → §Node.js executable + §launch command pattern.
- **Requirement 2** (all `@endo/*` bundled) → §two-option bundle strategy.
- **Requirement 3** (worker processes spawnable) → §worker process bundling.
- **Requirement 4** (platform-specific native modules) → §three challenges/mitigations (WASM co-location).

The §discipline: *enumerate the invariants the artifact must satisfy*; the rest of the design *operationalizes them*. Reusable for any *artifact-shape-with-explicit-invariants* design.

### §The two-option bundle strategy

The §Option A (lines 32-57):

```bash
esbuild packages/daemon/src/daemon-node.js \
  --bundle --platform=node --target=node20 \
  --outfile=dist/endo-daemon.cjs
```

The §single-file bundle approach: one `.cjs` file contains the daemon plus all `@endo/*` dependencies via static-import-tree analysis. The §benefit: *simplest packaging strategy*; the bundle is one file.

The §Option B (lines 58-61):

> Copy the daemon package and its `node_modules` into a self-contained directory. This avoids bundler complexity but produces a larger artifact.

The §packaged-directory approach: replicate the monorepo layout under `dist/`. The §benefit: no bundler complexity (no static-import analysis needed; dynamic imports work via path-based resolution).

The §two-option-with-preferred-choice discipline: the design *names both options*, identifies the *trade-off* (simplicity vs bundle size), and *picks one* (Option A, preferred). The §discipline is reusable: when a design has multiple valid implementations, name them all, identify the discriminating axis, and pick one with rationale.

### §The three-challenges-with-three-mitigations

The §challenges (lines 43-50):

> - The daemon uses dynamic `import()` for workers (`packages/daemon/src/worker.js`), weblets, and guest code. These cannot be statically bundled because they load user-provided code at runtime.
> - The `ses` package modifies JavaScript globals at import time (`lockdown()`). Bundlers must preserve this side effect.
> - The WASM module for OCapN-Noise (`packages/ocapn-noise/gen/ocapn-noise.wasm`) needs to be co-located.

The §three issues with Option A:

1. **Dynamic `import()`** — workers, weblets, and guest code are loaded *at runtime* from user-provided paths. Static bundling can't resolve them.
2. **`ses` lockdown side effect** — importing `ses` triggers `lockdown()` which modifies JavaScript globals. Bundlers that *cache imports* might skip the side effect on re-import; the side effect must run exactly once at startup.
3. **WASM co-location** — `ocapn-noise.wasm` is a binary artifact that needs to sit next to the bundle so the runtime can load it.

The §mitigations (lines 52-56):

> - Worker entry points and the SES shim can be bundled as separate artifacts alongside the main daemon bundle.
> - The main bundle includes everything except dynamically loaded user code.
> - WASM files are copied alongside the bundle.

The §three mitigations:

1. **Separate artifact bundling** — worker.js bundles into `endo-worker.cjs`; SES shim bundles into `ses-shim.cjs`. The dynamic loader paths point to these separate artifacts.
2. **Statically-bundle-everything-else** — the main bundle covers the @endo/* tree of static imports; dynamic-user-code is left to runtime resolution.
3. **Co-located WASM** — copy `ocapn-noise.wasm` to `dist/` next to the bundle.

The §discipline: *for each named challenge, name a specific mitigation*. The 1-to-1 correspondence makes the design auditable — a reviewer can verify each challenge is addressed.

### §The worker-resolve-relative-to-bundle-location discipline

The §lines 70-76:

> The worker entry point must also be bundled (or at minimum, resolvable from the daemon bundle's location). The daemon should resolve the worker entry point relative to its own location:
>
> ```js
> const workerPath = new URL('./endo-worker.cjs', import.meta.url).pathname;
> ```

The §`new URL('./endo-worker.cjs', import.meta.url).pathname` idiom:

- **`import.meta.url`** — the URL of the *current module* (the daemon bundle). For a CJS file, this is the `file://` URL of `endo-daemon.cjs`.
- **`new URL('./endo-worker.cjs', baseUrl)`** — resolve the relative path against the base URL. Produces the URL of `endo-worker.cjs` *in the same directory as the daemon bundle*.
- **`.pathname`** — extract the filesystem path from the URL.

The §discipline: *the daemon doesn't search PATH or use cwd-relative paths*; the worker entry sits next to the daemon bundle and is resolved by relative-URL math. The §invariant: *whoever ships the bundle controls where the worker is*. Moving the bundle moves the worker; no separate configuration required.

The §reusable: *for any pair of artifacts that must travel together*, use `new URL('./<sibling>', import.meta.url).pathname` to resolve the sibling. The §pattern works in both ESM and CJS-bundled-via-import.meta-shim.

### §The Node.js executable + launch command

The §Node.js executable matrix (lines 80-83):

- **macOS**: `node` for arm64 and/or x86_64.
- **Linux**: `node` for x86_64, arm64.
- **Windows**: `node.exe` for x86_64.

The §five platform/arch combinations. Each shipped binary is from *official Node.js releases* (per the §Security note: *bundled Node.js binary must be from a trusted source*).

The §launch command (lines 85-90):

```bash
<familiar-resources>/node <familiar-resources>/endo-daemon.cjs \
  <sock-path> <state-path> <ephemeral-state-path> <cache-path>
```

The §self-contained-from-resources pattern: both `node` and `endo-daemon.cjs` are *in the Familiar's resources directory*. The launch command doesn't reference system Node.js or any external path. Four CLI arguments are passed: socket path (where the Unix domain socket lives), state path (persistent state directory), ephemeral state path (temporary state directory), cache path.

The §discipline: *the Familiar's resources directory is the complete runtime*. No reliance on system PATH, no reliance on user-installed Node.js, no reliance on cwd-relative paths.

### §The five-file build artifacts

The §lines 94-101:

```
dist/
  endo-daemon.cjs       # Main daemon bundle
  endo-worker.cjs       # Worker entry point bundle
  ses-shim.cjs          # SES lockdown (if separate)
  ocapn-noise.wasm      # Noise Protocol WASM (if applicable)
  node-<platform>-<arch> # Platform-specific Node.js binary
```

The §five artifacts:

- **`endo-daemon.cjs`** — main daemon bundle (Option A output).
- **`endo-worker.cjs`** — worker entry point bundle (mitigates dynamic-import challenge).
- **`ses-shim.cjs`** — SES lockdown bundle (separated to preserve the side effect; *if separate* qualifier acknowledges it might be inlined depending on bundler).
- **`ocapn-noise.wasm`** — Noise Protocol WASM (co-located per WASM mitigation; *if applicable* qualifier acknowledges it might be omitted for daemons that don't use OCapN-Noise).
- **`node-<platform>-<arch>`** — platform-specific Node.js binary.

The §discipline: *one directory holds everything*. The Familiar's resources directory matches this layout; the daemon-launch command finds everything by relative-URL math.

### §The compatibility-invariant + interchangeable-with-development-daemon

The §Compatibility (lines 148-153):

> The bundled daemon must produce the same Unix socket protocol, CapTP messages, and persistence format as the unbundled daemon. It's the same code, just packaged differently.
> The bundled daemon should use the same state directory (`~/.local/state/endo/`) so it's interchangeable with the development daemon.

The §two-invariant:

- **Same wire protocol** — Unix socket, CapTP messages, persistence format. The §rationale: a Familiar user might also use the CLI; both must speak the same protocol.
- **Same state directory** — `~/.local/state/endo/`. The §rationale: a developer might start the daemon via CLI for one session and the Familiar for the next; both should pick up the same state.

The §discipline: *the bundle is a packaging artifact, not a new product*. The same code, the same state, the same protocol — only the packaging differs.

The §discipline directly supports cycle 109's *play well with existing daemons* five-scenario table — the Familiar can spawn the bundled daemon, then a future CLI command can connect to it, then a future Familiar session can reconnect to it. All sessions see the same state; the daemon is the persistent shared substrate.

### §The Dependency: None

The §line 124:

> None (can proceed independently of other Familiar work items).

The §isolation-from-other-design-work discipline: this design *can ship independently*. It doesn't depend on `familiar-gateway-migration` (cycle 111) or `familiar-unified-weblet-server`. The §rationale: bundling is a packaging concern; it doesn't change the daemon's surface area. Any version of the daemon can be bundled.

The §observation: *cycle 109's Familiar Electron Shell depends on this design*, but this design depends on *nothing* in the Familiar family. The §dependency direction is one-way; the design is *foundational*.

### §The build-script discipline

The §lines 105-114:

> Add a build script to `packages/daemon` (or a new `packages/familiar-build` package) that produces the bundle:
>
> ```json
> {
>   "scripts": {
>     "bundle": "node scripts/bundle-daemon.js"
>   }
> }
> ```

The §placement choice: *`packages/daemon`* or *new `packages/familiar-build`*. The §design doesn't decide; it names both. The §discipline: *acknowledge the placement question without forcing premature commitment*.

The §`yarn bundle` (or `npm run bundle`) command runs `scripts/bundle-daemon.js` which:

1. Runs esbuild on `packages/daemon/src/daemon-node.js`.
2. Runs esbuild on `packages/daemon/src/worker.js`.
3. Optionally bundles the SES shim.
4. Copies the WASM module.
5. Outputs to `dist/`.

The §Familiar's build pipeline then copies `dist/` into the Electron app's resources directory. The §`packages/familiar-build` placement (if chosen) would isolate the bundle-build from the daemon source; the §`packages/daemon` placement (if chosen) co-locates them.

### §The Security/Scaling considerations

The §Security (lines 128-132):

> - The bundled daemon runs with the same authority as the unbundled daemon. No change in security posture.
> - The bundled Node.js binary must be from a trusted source (official Node.js releases). Consider verifying checksums during the build.
> - The bundle should not include development-only code or test fixtures.

The §three security disciplines:

- **No change in security posture** — bundling doesn't introduce new authority; the bundle is the *same code* with the *same permissions*.
- **Trusted Node.js source** — official releases, with checksum verification. Avoids supply-chain attacks on the Node.js binary.
- **No dev/test code in bundle** — the bundle is the *production-only* surface; dev-only code might have weaker security defaults that shouldn't ship.

The §Scaling (lines 136-138):

> - Bundle size matters for Electron distribution. Target < 50MB for the daemon + Node.js combined (Node.js alone is ~40MB).
> - Tree-shaking can reduce bundle size by eliminating unused code paths.

The §50MB target is *daemon + Node.js combined* — Node.js alone is ~40MB, so the daemon bundle target is ~10MB. The §tree-shaking optimization is named explicitly.
