# Completion: endo-npm-cas-registry-press-20260730-203502

**Repo:** endojs/endo-but-for-bots (base `llm`, HEAD eb64412d76)
**Role:** Fable press-driver (NPM Registry Proxy via CAS)

## What I did

Assessed the live `llm` HEAD and verified the NPM-via-CAS registry proxy finish
line with **real-execution evidence** (actual `endor run` against the real npm
registry — no `npm` CLI, no `node_modules`, no lockfile).

1. Populated the `c/moddable` XS submodule and built `rust/endo` (`cargo build
   --bin endor`) from source.
2. Generated the three gitignored xsnap boot artifacts (stubs via
   `packages/thixotrope/scripts/bundle-xs-worker.mjs`) so the crate compiles.
   The standalone `endor run <entry.js>` archive runner does not evaluate those
   stubs (it uses `ARCHIVE_ENDOWMENTS_JS`), so execution is unaffected. PR #882
   (DRAFT) restores the real worker/SES bundle generators; its known gap
   (daemon_bootstrap stub) does not block `endor run`.
3. Ran real-execution verification (commands + observed output below).
4. Ran `cargo test --lib`: 189 passed, 0 failed.
5. Posted a progress journal entry (entries/2026/07/30/204735Z-progress-gardener-322f78.md).

## Real-execution evidence

- `endor npm-resolve 'is-odd@^3.0.0'` → fetched is-odd@3.0.1 + is-number@6.0.0
  from registry.npmjs.org, stored content-addressed in CAS, MVS-selected. Exit 0.
- `endor npm-resolve --offline 'is-odd@^3.0.0'` → resolved entirely from
  registry table + CAS (zero network), identical selection. Exit 0.
- `endor registry list` → 2 packages cached; `endor registry verify` →
  2 verified, 0 incomplete. Exit 0.
- `endor run <entry.js>` (imports `is-odd`, declares `is-odd@^3.0.0`) →
  printed `is-odd(3): true` / `is-odd(4): false`. Exit 0.
- `endor run --offline <entry.js>` (cached) → identical output. Exit 0.
- `endor run <entry2.js>` (imports `semver/functions/satisfies.js` + `minVersion`
  from `semver@^7.5.0`) → printed `satisfies(1.2.3, ^1.0.0): true` /
  `minVersion(^1.2.3): 1.2.3`. Exit 0.
- `endor run <entry.js>` (imports `react@^18.0.0`, gates on
  `process.env.NODE_ENV`) → printed `React version: 18.3.1` /
  `typeof createElement: function`. Exit 0. The `process` frozen shim works
  with real published packages.
- `endor run --offline` with an UNCACHED package (`left-pad`) → clean typed
  error: `fetch: offline: network access ... refused`. Exit non-zero.

## What changed

No project source changed. This was a verification/press tick: the finish line
is already implemented on `llm`. No unblocked npm-specific code increment
remains to press. No garden-infra changes.

## Finish line status

MET and verified. `endor run <entry.js>` resolves, fetches, and executes npm
packages with no npm CLI / node_modules / lockfile; packages are
content-addressed and immutable in the CAS (deduplicated); a SQLite registry
table maps (name, version) → CAS hash; Go-like MVS resolves versions; offline
mode guarantees cache-only resolution; the `process` global shim handles
real-world packages (react).

## Follow-ups

- PR #882 (DRAFT, restore-xs-bootstrap-generators): restore the real
  `ses_boot.js` / `worker_bootstrap.js` generators so a fresh checkout compiles
  without manual stub generation. Known gap: `daemon_bootstrap.js` still stubs
  because `bundle-bus-daemon-rust-xs.mjs` fails on Node-only static imports
  (`@endo/git`, `@endo/host-spawner`) — needs the inject-backend treatment.
  No CI job builds the xsnap crate, so this regresses silently.
- PR #873 (OPEN, CONFLICTING, workspace-protocol resolution): needs a rebase;
  owned by a live worker on a shared branch — deferred.
- PR #892 (DRAFT, process-gap doc): marks the `process` global gap resolved in
  the design doc — aligns the known-gaps checkbox with the implemented reality.
- Remaining known gaps (out of scope of the core finish line): binary `.node`
  packages (not supported in XS), pre/post-install scripts (intentionally
  omitted).
