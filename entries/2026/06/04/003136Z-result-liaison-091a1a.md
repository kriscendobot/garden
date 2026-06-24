---
ts: 2026-06-04T00:31:36Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/04/001616Z-dispatch-liaison-091a1a.md
  - entries/2026/06/04/002943Z-result-fixer-091a1a.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
---

# result: #418 evasive-parser injection refactor complete; new head 0bbf4e8ec

User asked the fixer to address kriskowal's #418 inline.
Fixer `091a1a` closed cleanly.

## Outcome

- **New head**: `0bbf4e8ec` on
  `fix/endo-make-node-evasive-runtime` (regular append).
- **Inline reply**: `3352709881` on thread `3352662259`.

## Refactor

Moved evasive-transform parser-map wiring out of platform-
agnostic `worker.js` into the Node-specific powers layer:
- `worker.js` now accepts `loadArchiveParsers` as injected
  power; no `./worker-archive-parsers.js`, no
  `@endo/evasive-transform`, no `@babel/*` references at
  runtime.
- Three Node-side bootstraps (`worker-node-powers.js`,
  `bus-worker-node-powers.js`, `worker-go-powers.js`) each
  supply the loader as a deferred `import(...)` returning
  `evasiveParserForLanguage`.
- `MignonicPowers` in `types.d.ts` grew documented
  `loadArchiveParsers` field.
- Lazy-load shape preserved (workers that never call
  makeArchive/makeFromTree still pay no Babel cost).

Files (6, +101/-25): `worker.js`, `worker-node-powers.js`,
`bus-worker-node-powers.js`, `worker-go-powers.js`,
`bus-worker-node-raw.js`, `types.d.ts`.

## Gates (Node side)

- `yarn lint`: 0 errors (385 pre-existing warnings).
- `yarn lint:types`: 0.
- `yarn format`: 0 (rewrap on two await-import lines).
- AVA: 2/2 evasive regression + 6/6 makeArchive + 13/13
  tree tests pass.

## Rust validation: option B (deferred)

Toolchain present (`cargo 1.95`) but `rust/endo/` depends on
`xsnap` which requires the Moddable XS submodule
(`c/moddable`) populated; submodule uninitialized in the
fork worktree and `git submodule update --init c/moddable`
didn't complete in dispatch window.

Sanity: `cargo test` on `rust/ocapn_noise/` (no Moddable
dep) compiled+ran cleanly, confirming toolchain works.

**Structural argument**: refactor only moves WHERE the Node
worker fetches its parser map; the archive wire format and
the Rust supervisor's untransformed-read path are untouched.
Per existing `worker-archive-parsers.js` docstring: "The
Rust supervisor reads the same untransformed archives and
does NOT apply this transform."

Inline reply requests maintainer-side `cargo test` run OR
hand-off to the Rust-credentialed verifier.

## Judgment calls (fixer)

1. Wired `loadArchiveParsers` into all three Node-side
   bootstraps (not just `worker-node-powers.js`) so the
   invariant holds uniformly.
2. Kept the loader lazy (preserves prior commit's "no Babel
   load cost if no makeArchive" behavior).
3. Did not touch pre-existing `pathToFileURL` vs
   `MignonicPowers` type drift (out of scope).
4. Did not touch any `rust/` source per dispatch
   authorization (validation only).

## Teardown

`dispatches/fixer--091a1a` torn down.

## Steward queue post-engagement

- **#418** refactor at `0bbf4e8ec`; awaits maintainer
  reassessment + Rust-side validation (maintainer or
  Rust-credentialed verifier).
- **#417** sequential impl at `83133cceb`; awaits
  reassessment.
- **#411** rebased at `37440d0e2`; awaits CI green + boatman
  re-ferry.
- All other queue items unchanged.
