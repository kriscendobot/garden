<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-08-06T05:45:53Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
fixer job (endojs/endo-but-for-bots), DEFERRED. Surfaced by the
PR #124 refresh (job endojs-endo-but-for-bots-pr124-refresh, 2026-07-30).

The XS daemon and worker bootstrap bundles do not build on the `llm`
base. This is a pre-existing `llm` condition, independent of PR #124:
`llm`'s daemon core (`packages/daemon/src/manager.js`) and the shared
interface module (`packages/daemon/src/interfaces.js`) grew Node-only
dependencies that the XS compartment-mapper bundler cannot resolve, and
`llm` has no Rust/XS CI workflow so it regressed unobserved.

Symptom: `node packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`
and `bundle-bus-worker-xs.mjs` fail with "Cannot find external module
node:path / node:fs / @endo/git / @endo/exo-stream ..." because:
- `manager.js` top-level imports `@endo/git`, `@endo/host-spawner`,
  `@endo/exo-shell`, `@endo/exo-http-client`, `@endo/exo-stream`
  (Node-only capability providers added on llm).
- `interfaces.js` imports `@endo/platform/fs/lite`, whose barrel
  (`packages/platform/src/fs/index.js`) re-exports `snapshot-blob.js`
  and `checkin.js`, which import `@endo/exo-stream` (Node-only).

The `ses-boot` bundle still builds. PR #124's `rust.yml` bundle step
uses `continue-on-error` pending this fix.

Approach (pick one or combine):
- Split `interfaces.js` so the XS-worker-facing interface
  (`WorkerFacetForDaemonInterface`) does not transitively import the
  Node-only platform barrel; or import the guards directly from
  `@endo/platform`'s `fs/interfaces.js` (currently not in the exports
  map) behind a new export.
- For the daemon bootstrap, either exclude the Node-only capability
  providers from the XS bundle graph (verifying the XS daemon does not
  exercise git/shell/host-spawner paths at runtime) or refactor those
  providers to load lazily so the top-level import does not entrain
  them.
- Add a `llm`-side CI workflow (or extend `rust.yml`) that runs the XS
  bundles so this cannot regress unobserved again.

Verify: `yarn bundle:xs` builds all three bundles green; flip
`continue-on-error` to `false` on the bundle step in
`.github/workflows/rust.yml`.

Refs: https://github.com/endojs/endo-but-for-bots/pull/124#issuecomment-5136436206
