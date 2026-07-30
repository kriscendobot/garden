---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:47:36Z
---
role: gardener
job: endo-npm-cas-registry-press-20260730-203502
repo: endojs/endo-but-for-bots (base llm)

# NPM-via-CAS registry proxy — finish line verified with real-execution evidence

Assessed the live `llm` HEAD (commit eb64412d76) of endojs/endo-but-for-bots.
The design `designs/endor-npm-registry-proxy.md` records all five phases
implemented; I verified the finish line with actual `endor run` executions
against the real npm registry (no `npm` CLI, no `node_modules`, no lockfile).

## Build

Built `rust/endo` from source after populating the `c/moddable` submodule.
The xsnap crate's three `include_str!` boot artifacts (`ses_boot.js`,
`worker_bootstrap.js`, `daemon_bootstrap.js`) are gitignored generated files
absent from a fresh checkout; I generated stubs via
`node packages/thixotrope/scripts/bundle-xs-worker.mjs` so the crate compiles.
The standalone `endor run <entry.js>` archive runner does NOT evaluate those
stubs (it uses `ARCHIVE_ENDOWMENTS_JS` + `install_archive_async`), so execution
is unaffected. PR #882 (DRAFT) restores the real worker/SES bundle generators;
its known gap (daemon_bootstrap stub) does not block `endor run`.

## Real-execution evidence (commands + observed output)

1. `endor npm-resolve 'is-odd@^3.0.0'` → fetched is-odd@3.0.1 + is-number@6.0.0
   from registry.npmjs.org, stored content-addressed in CAS, MVS-selected.
2. `endor npm-resolve --offline 'is-odd@^3.0.0'` → resolved entirely from
   registry table + CAS (zero network), identical selection.
3. `endor registry list` / `endor registry verify` → 2 packages cached, 0
   incomplete.
4. `endor run <entry.js>` (entry imports `is-odd`, package.json declares
   `is-odd@^3.0.0`) → printed `is-odd(3): true` / `is-odd(4): false`. Exit 0.
5. `endor run --offline <entry.js>` (same, cached) → identical output. Exit 0.
6. `endor run <entry2.js>` (imports `semver/functions/satisfies.js` + `minVersion`
   from `semver@^7.5.0`) → printed `satisfies(1.2.3, ^1.0.0): true` /
   `minVersion(^1.2.3): 1.2.3`. Exit 0.
7. `endor run <entry.js>` (imports `react@^18.0.0` — a real-world package gating
   on `process.env.NODE_ENV`) → printed `React version: 18.3.1` /
   `typeof createElement: function`. Exit 0. The `process` global frozen shim
   works with real published packages.
8. `endor run --offline` with an UNCACHED package (`left-pad`) → clean typed
   error: `fetch: offline: network access ... refused (run without --offline
   to populate the cache)`. Exit non-zero. Offline mode is guaranteed, not
   assumed.

## Tests

`cargo test --lib` (rust/endo): 189 passed, 0 failed.

## Assessment

The finish line — `endor run <entry.js>` resolves, fetches, and executes npm
packages with no npm CLI / node_modules / lockfile, packages content-addressed
and immutable in the CAS, a SQLite registry table mapping (name, version) → CAS
hash, and Go-like MVS — is MET and verified by real execution. Remaining known
gaps (workspace-protocol resolution, binary packages, install scripts) are
out of scope of the core finish line and tracked by open PRs (#873 workspace,
#892 process-gap doc). No unblocked npm-specific code increment remains to
press; the next increments (workspace resolution #873 CONFLICTING, registry-
capability #888) are owned by live workers on shared branches.
