# Press report — npm-via-CAS registry proxy (tick 2026-07-28, 00:48Z)

## Assessment

`llm` HEAD unchanged at `7f8c08d74f` (#862). All five design phases remain merged; the six gap drafts from prior ticks (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #873 workspace protocol, #875 imports field, #876 conditions/webcrypto) are all still OPEN, MERGEABLE, CI fully green (24/24), with zero maintainer reviews — nothing to land, nothing blocked on the registry-capability edge (#403/#671 stay with the byte-array arc). No live peer held any npm-cas branch; my inbox stayed empty at every checkpoint.

## What I did — pressed a newly discovered gap class: draft PR #877

Probing the finish line with `@noble/hashes` (the canonical **dual-build** npm shape: CommonJS root + `esm/` build under a nested `package.json` with `"type": "module"`) exposed three real execution gaps, fixed together in **draft PR https://github.com/endojs/endo-but-for-bots/pull/877** (branch `feat/endor-npm-dual-build-execution`, commit `25ef304ce6`, base `llm`, kept draft):

1. **Nearest-`package.json` module flavor** (`execute.rs`): `.js` parser classification now follows Node's nearest-ancestor rule instead of the package root's `type` alone — previously noble's entire ESM build was fed to the CJS loader and died on `SyntaxError: invalid import`.
2. **Package self-reference edges** (`assemble.rs`): every compartment now carries an edge for its own name, so `import { crypto } from '@noble/hashes/crypto'` *inside* `@noble/hashes` resolves through its own exports map with module identity preserved.
3. **Web text endowments** (`xsnap/lib.rs`): archive compartments get `TextEncoder`/`TextDecoder` (reusing the machine's polyfilled/native codecs; the loaded-archive path now evaluates the typeof-guarded `POLYFILLS` it previously skipped) plus new pure-JS `atob`/`btoa` — no new authority; appended as a separate statement to keep the conflict surface with #876's endowments factoring minimal.

**Real-execution evidence:** cold isolated state, real registry — `endor run entry.js` over `@noble/hashes@^1.4.0` fetched 1.8.0 into the CAS and printed the correct `sha256(abc) = ba7816bf…15ad` via the ESM build (whose `utf8ToBytes` needs `TextEncoder`), plus correct `TextDecoder`/`btoa`/`atob` round-trips (`héllo ☃`); replayed byte-identical under `--offline`. The `semver@^7.5.4` CJS regression probe stays green online and offline. Tests: `cargo test -p endo` 174/174 (+1 flavor test; self-edge assertions), `-p xsnap` 121/121 single-threaded (+1 codecs test); one pre-existing flaky XS test (`executes_cjs_require_graph_in_xs`) failed once in a parallel run and passes alone/in reruns — the known rust-endo flakiness arc, untouched. Design doc Status + Known gaps updated in the same commit (Updated → 2026-07-28).

## Follow-ups for the next tick

- **Seven** gap drafts now held for maintainer promotion: #857, #859, #860, #873, #875, #876, and new **#877** — confirm #877's CI lands green (checks were still spinning at report time; MERGEABLE/CLEAN). #877 and #876 compose (with #876's `crypto` endowment, noble's `'crypto' in globalThis` probe starts resolving); whichever lands second takes a trivial rebase around `__archiveEndowments`.
- Remaining web-global gaps: `URL`/`URLSearchParams`, `crypto.subtle`, streaming/`fatal` decoder fidelity, `encodeInto`; the default-conditions policy still awaits maintainer word on #876.
- Worktree note: my worktree carries the built binary + populated `c/moddable` and the generated bootstrap JS (copied from the 07-27 17:50Z worktree); probes live in `scratch/npm-cas-probe-20260728`.
