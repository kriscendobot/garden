---
ts: 2026-06-04T00:29:43Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--091a1a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - entries/2026/06/04/001616Z-dispatch-liaison-091a1a.md
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3352662259
  - https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3352709881
---

# result: fixer — #418 inject evasive parsers from Node-specific layer

Addressed kriskowal's CHANGES_REQUESTED inline `3352662259` on PR
endojs/endo-but-for-bots#418: moved the evasive-transform parser map out
of the platform-agnostic `worker.js` into the Node-specific powers
layer. `worker.js` no longer imports `./worker-archive-parsers.js`
(transitively `@endo/evasive-transform` and Babel).

## Pre-refactor seam shape

`packages/daemon/src/worker.js` (the platform-agnostic worker facet
factory) inlined two parallel `await Promise.all([import('@endo/compartment-mapper'),
import('./worker-archive-parsers.js')])` blocks inside `makeArchive`
and `makeFromTree`, each destructuring the wrapped
`evasiveParserForLanguage` and passing it as `parserForLanguage` to
`parseArchive`. That entrained `@endo/evasive-transform` (and
transitively Babel) on the Node load path, but more importantly placed
the wiring decision in a file that other platforms (the Rust
supervisor's worker entrypoint, the engo Go supervisor) also consume.
`MignonicPowers` exposed only `connection: { reader, writer }`; the
parser map was hard-coded inside the worker facet.

## Post-refactor seam shape

`worker.js` accepts a `loadArchiveParsers: () => Promise<ParserForLanguage>`
power alongside `cancel` on `makeWorkerFacet`, and `main` forwards
`powers.loadArchiveParsers`. Each of the three Node-side bootstraps
provides the loader: `worker-node-powers.js`,
`bus-worker-node-powers.js`, and `worker-go-powers.js` each return
`harden({ connection, pathToFileURL, loadArchiveParsers })` where
`loadArchiveParsers` is a deferred async wrapper around
`import('./worker-archive-parsers.js')` that yields
`evasiveParserForLanguage`. The `bus-worker-node-raw.js` direct
`makeWorkerFacet({ cancel })` call also forwards
`powers.loadArchiveParsers`. `MignonicPowers` grows the new field with
a JSDoc explanation pointing to the Node vs Rust path asymmetry. The
lazy-load shape is preserved: workers that never see `makeArchive` /
`makeFromTree` still don't pay the Babel load cost. `worker.js` now
imports only `@endo/harden`, `@endo/far`, `@endo/exo`, `@endo/patterns`,
`@endo/zip`, `@endo/bytes`, and local files; the `@endo/compartment-mapper`
deferred import inside the facet methods is its only remaining
parser-related dependency, and that's platform-agnostic.

## New head SHA + commit

- New head: `0bbf4e8ec590222c0e1fb6f74af5d57e5c029c1f`
- Title: `refactor(daemon): inject evasive-transform parsers from worker-node-powers (keeps worker.js platform-agnostic)`
- Stat: 6 files changed, 101 insertions(+), 25 deletions(-)
  (worker.js, worker-node-powers.js, bus-worker-node-powers.js,
  worker-go-powers.js, bus-worker-node-raw.js, types.d.ts)

## Local gate exit codes (Node side)

- `yarn workspace @endo/daemon lint`: exit 0 (385 warnings, all
  pre-existing; 0 errors).
- `yarn workspace @endo/daemon lint:types`: exit 0.
- `yarn format`: exit 0 (rewrapped two `await import(...)` lines
  inside the powers loaders; cosmetic only).
- AVA, evasive regression slice (`--match '*evade*'`): 2/2 passed
  in test/endo.test.js: `makeArchive evades SES censorship of TS
  JSDoc import() in a source-only archive`, `makeArchive evades SES
  censorship of @endo/errors source in a source-only archive`.
- AVA, broader archive slice (`--match '*archive*' --match '*Archive*'`):
  6/6 passed (rejects unknown archive pet name, with empty env, both
  evade tests, without env defaults to empty env, runs source-only ZIP
  with env).
- AVA, tree slice (`--match '*Tree*' --match '*tree*'`): 13/13 passed,
  including `Phase 7: makeFromTree runs a caplet from a mounted source
  tree` and `Phase 7: makeFromTree persists and reincarnates the
  caplet`.
- AVA, cross-supervisor: 0 ran, 4 skipped (need a Rust supervisor
  binary which the bot host doesn't build; not a regression).

## Rust-side validation: option B (deferred with reason)

The bot host has `cargo` 1.95 available, but `rust/endo/` depends on
`xsnap`, whose build script requires the Moddable XS sources at
`c/moddable/xs/sources`. The submodule is uninitialized in this fork
worktree, and `git submodule update --init c/moddable` exited silently
without populating the working tree (the Moddable SDK is large; the
clone may have rate-limited or stalled within the dispatch window).
`cargo test` fails fast at the xsnap build step with the exact message
the build script defines: "Moddable XS sources not found ... no
prebuilt libxs.a ... Run `git submodule update --init c/moddable`
from the workspace root...". Built and ran `cargo test` on
`rust/ocapn_noise/` as a sanity check (no Moddable dependency); that
compiled and ran 0 tests successfully, confirming the toolchain works
but is not on the relevant code path.

Structural argument for why a Rust regression is unlikely from this
refactor: the change only moves where the Node worker fetches its
`parserForLanguage` map (from a `worker.js`-internal dynamic import to
a powers-injected loader). The archive byte format, the CapTP / bus
envelope wire shape, and the Rust supervisor's archive-import pipeline
are not touched, and they were already decoupled in the prior commit
(per the docstring in `src/worker-archive-parsers.js`: "The Rust
supervisor reads the same untransformed archives and does NOT apply
this transform; the Rust path remains the canonical untransformed
archive shape, and the wrappers here only affect the Node worker's
load path."). The inline reply on the thread asks the maintainer to
either run `cargo test` locally (where the Moddable submodule is
populated) or hand off to a Rust-credentialed verifier, matching the
dispatch brief's option B path.

## Inline-thread reply

- Replied on parent comment `3352662259` (thread ID).
- Reply ID `3352709881`, URL
  https://github.com/endojs/endo-but-for-bots/pull/418#discussion_r3352709881.
- Body cites SHA `0bbf4e8e`, summarizes the seam relocation, lists the
  three Node-side bootstraps and the lazy-load shape, names the local
  gates that pass, and surfaces the Rust deferral with a request for
  maintainer-side validation.

## Judgment calls

- **Scope of "Node-specific layer".** The maintainer's review names
  `worker-node.js` / `worker-node-powers.js` specifically. `worker.js`
  also has two other Node-side bootstraps that consume `makeWorkerFacet`:
  `bus-worker-node-raw.js` (with `bus-worker-node-powers.js`) and
  `worker-go.js` (with `worker-go-powers.js`). I wired
  `loadArchiveParsers` into all three so the seam is uniform and
  `worker.js` truly never reaches for the evasive parsers on its own.
  Without that, the bus and go Node-side bootstraps would have been
  the lone remaining callers paying the load cost from `worker.js`'s
  prior shape, which would have re-broken the maintainer's invariant
  on those paths.
- **Loader shape: lazy `() => Promise<ParserForLanguage>` vs an
  eager-injected map.** Kept it lazy to preserve the prior commit's
  "defer compartment-mapper imports so workers that never call
  makeArchive don't pay the babel/parser load cost" behavior. A
  pre-resolved map would have forced Babel to load at every Node
  worker startup even for workers that only ever `evaluate` /
  `makeUnconfined`. The deferred loader matches both the original
  intent and the maintainer's "does not entrain Babel on platforms
  that do not use it" goal at the within-Node granularity.
- **`MignonicPowers.loadArchiveParsers` typed against
  `@endo/compartment-mapper`'s `ParserForLanguage`.** That's a type-
  only import in `types.d.ts` and a JSDoc `@param` in `worker.js`;
  no runtime reference. `worker.js` itself doesn't import the type
  module at runtime, so the platform-agnostic load graph stays clean.
- **`pathToFileURL` is also Node-specific but predates this dispatch.**
  Pre-existing inconsistency: each `makePowers` returns
  `pathToFileURL` but `MignonicPowers` doesn't declare it. I left it
  alone because the dispatch was scoped to the evasive-parser seam,
  and chasing the unrelated type drift would have widened the diff
  beyond the maintainer's ask.
- **Rust validation deferred per option B.** Toolchain is present but
  the Moddable XS sources are not populated in the fork worktree;
  building xsnap from scratch is outside both the dispatch window and
  the dispatch brief's "not authorized to touch rust/ source" scope.
  Structural reasoning + an explicit hand-off request to the
  maintainer in the inline reply.

Self-improvement: nothing this time.
