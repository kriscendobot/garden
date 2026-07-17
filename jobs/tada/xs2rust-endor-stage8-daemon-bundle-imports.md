Working tree clean (bundle output correctly gitignored), no orphaned daemons, both commits on `origin/xs2rust-endor`. The job is complete.

---

## Completion report — Stage-8 child 1/6: daemon-bundle Node-only import fix (README item 1)

**Program:** XS→Rust (Endor), PR endojs/endo-but-for-bots #600, branch `xs2rust-endor`. PR kept DRAFT (untouched).

### What was wrong
The daemon bundler `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` (→ `daemon_bootstrap.js`) failed because the shared daemon core eagerly imported Node-only packages that pull `node:` builtins. The reality was broader than README item 1 described — three packages, not one:
- `@endo/git` — `makeNativeGitBackend` (manager.js), `gitClone` (host.js): `child_process`/`node:fs`/… (9 failures)
- `@endo/host-spawner` — `makeHostSpawner` (manager.js): `child_process`/`node:fs/promises` (3 failures)
- `@endo/exo-git` — transitively via `@endo/platform/fs/extended`'s node-fs backend (`node:fs`) + blobref (`node:crypto`) (4 failures). The README attributed this to `@endo/platform/fs/lite`, but `fs/lite` is clean; the real puller is `exo-git/git.js`'s barrel import of `@endo/platform/fs/extended`.

### What I did
Mirrored the existing `better-sqlite3-xs.js` injection seam — kept all edits inside `packages/daemon` + the bundler (no shared-package edits):
- **New `git-powers-node.js`** — Node-only module eagerly importing `@endo/git` + `@endo/exo-git` + `@endo/host-spawner`, exporting `makeNodeGitPowers()` + `makeHostSpawner`.
- **New `git-powers-unavailable.js`** — SES-safe throwing stubs (`GitPowers` shape + spawner) for the XS path and as manager.js's defensive default.
- **`manager.js` / `host.js` / `interfaces.js`** — removed the direct `@endo/git` / `@endo/exo-git` / `@endo/host-spawner` value imports; git makers + spawner now arrive via `powers.git` / `powers.makeHostSpawner`, threaded into `makeDaemonCore` and `makeHostMaker`. Removed the unused git-interface re-export from interfaces.js.
- **Node entries** (`manager-node.js`, `manager-go.js`, `bus-manager-node.js`) — inject the real `makeNodeGitPowers()` + `makeHostSpawner`; **`bus-manager-rust-xs.js`** injects the unavailable stubs.
- **`types.d.ts`** — added `git?`/`makeHostSpawner?` to `DaemonicPowers`; `host.js` JSDoc gained `gitPowers`.
- **Bundler** — added `@endo/git`, `@endo/exo-git`, `@endo/host-spawner` to `EXCLUDED_PACKAGES`.
- **`rust/endo/README.md`** — marked item 1 resolved (serial orchestration, no concurrent README editors).

### Verification
- `yarn install` clean; **bundler runs to completion**, emits `daemon_bootstrap.js` (1.79 MB, gitignored — NOT committed).
- `yarn lint:types` (tsc) **passes**; eslint **0 errors**.
- **146 exo-layer tests pass** (`git.test.js`, `shell.test.js`, `git-remote.test.js`) under a neutral git config.
- **Direct Node daemon boot succeeds** with the new wiring: `manager-node.js` formulates the full graph including the `host` formula (which consumes the injected `gitPowers`) and binds the socket — proving no Node regression.
- Two git tests and the endo.test.js integration tests fail **only environmentally**, proven not mine: git rerere is enabled globally in the container (both failing merge/identity tests pass with `GIT_CONFIG_GLOBAL=/dev/null`), and endo.test.js fails `EADDRINUSE` **identically on the stashed original tree** — its detached-daemon harness cannot run in this sandbox regardless of my change.

### Commits (pushed, verified by exit code + matching remote HEAD)
- `1a756d2930` daemon: make git backend + host spawner injectable so the XS bundle builds
- `783d434fa1` docs(endo-rust): mark daemon-bundle Node-import blocker resolved

### Follow-ups
- README **item 2** (worker/SES boot generators absent — `bundle-bus-worker-xs.mjs` + `bus-worker-xs.js` not in tree) remains the outstanding daemon-bundle blocker for a live `endor` boot; that's a separate stage-8 concern.
- endo.test.js's detached-daemon integration suite can't be exercised in this sandbox (EADDRINUSE, pre-existing) — worth running in CI where the daemon harness works.
