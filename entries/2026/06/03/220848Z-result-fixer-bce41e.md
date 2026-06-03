---
ts: 2026-06-03T22:08:48Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--bce41e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - entries/2026/06/03/220122Z-dispatch-liaison-bce41e.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617126205
---

# result: fixer — #417 ponyfill docs + parity proposal + @endo/bytes spackle ramifications

Addressed kriskowal's three asks on PR #417 (issue-comment
2026-06-03T22:00:49Z) in a single README-only commit. PR is non-draft
and not re-drafted by this dispatch.

## Files touched

- `packages/immutable-arraybuffer/README.md` (+196 lines, 0 deletions).

Single file. No source edits. No `@endo/bytes` edits (the dispatch
brief authorized only documentation of the spackle ramifications, not
package source changes).

## Content summary

Five new sections added to the immutable-arraybuffer README:

1. **"The Freezable TypedArray Ponyfill"**: documents the new
   companion ponyfill (`freezable-typedarray-pony.js`) public surface.
   Names the two callable exports (`makePseudoTypedArrayConstructor`,
   `virtualTypedArrayBufferGetter`), explains the brand-check
   encapsulation, and tells callers to construct freezable views only
   through `makePseudoTypedArrayConstructor`.

2. **"Using the Ponyfills Across Native and Shim"**: the central
   ask. Documents the canonical idiom (import the named exports
   rather than reaching for `ArrayBuffer.prototype` methods),
   shows the freezable-typedarray-pony parallel, and names the two
   preconditions for source-compat across shim and native (consistent
   discipline + treating `isBufferImmutable` as the type discriminator
   rather than `instanceof`). Subsection on feature detection covers
   the `optTransferBufferToImmutable !== undefined` and
   `'immutable' in new ArrayBuffer(0)` cases.

3. **"Proposed XS / Node.js Parity Tests"**: a four-artifact proposal
   following the parity-test pattern from
   `skills/node-parity-test/SKILL.md`. Sketches the shared assertions
   module, the shared fixture, the Node-side `parity-node.test.js`,
   and the XS-side `_xs.js` entry point. Cites
   `packages/ses/test/_xs.js` and
   `packages/ses/scripts/generate-test-xs.js` as the XS-runner
   precedent. Pure-prose proposal; XS toolchain implementation
   deferred.

4. **"Ramifications for `@endo/bytes` as a Spackle"** (with three
   subsections): identifies the three candidate operations
   (`bytesToImmutable`, `bytesFromImmutable`, `concatImmutables`)
   and excludes the four that are not candidates. Sketches the
   install-and-prefer-install dance modeled on `@endo/harden`'s
   `Object[Symbol.for('harden')]` pattern. Documents the
   non-breaking migration path and the unchanged public API. Surfaces
   the open question (whether the operations are realm-identity-
   sensitive enough to warrant the coordination cost) as the gate
   for whether to spackle now or later.

## New head SHA

`2071b71e3` on `mirror/3164-freezable-typedarrays`, pushed via
`git push origin HEAD:mirror/3164-freezable-typedarrays`. No force.

Previous head was `0bf3dc8e6`; commit is a single regular append.

## Reply comment ID

[`IC_kwDORRE4FM8AAAABEzN5fQ`](https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617126205)
on PR #417's issue-comment thread, posted via `gh pr comment 417
--repo endojs/endo-but-for-bots --body ...`. Summarizes each of the
three sections that landed, names the commit SHA, and surfaces the
judgment call on skeleton XS test files.

## Judgment calls

**Skeleton XS test files vs. pure prose**: chose pure prose. Reasoning:

- The dispatch brief authorized skeleton test files but flagged the
  full XS test implementation as out of scope. Skeleton files without
  the XS-runner wiring (`scripts/generate-test-xs.js`-style script,
  `xst` binary in CI) would not be runnable; the `test:xs` script in
  `packages/immutable-arraybuffer/package.json` currently exits 0
  with no fixture, so a stub `test/_xs.js` would just sit there.
- The maintainer's ask said "propose tests that verify these patterns
  by sharing a fixture and assertions between code running under XS
  and Node.js". A README proposal that names the four artifacts, the
  shared assertions shape, the fixture shape, the Node-side test, and
  the XS-runner precedent (citing `packages/ses/test/_xs.js`) is a
  proposal. Skeleton files without the runner are not.
- The deferred follow-up is well-scoped: land the Node-side test
  pair + shared assertions + shared fixture as a self-contained
  Node-only piece, then add the XS-side runner wiring in a separate
  PR once the Moddable SDK toolchain is in scope.

**Where the content lives**: chose to land all three pieces in the
existing package README rather than creating a separate
`docs/freezable-typedarray.md` or `designs/` document. Reasoning: the
ponyfill-usage section is a natural README extension (the README
already documents the immutable-`ArrayBuffer` ponyfill, the shim,
caveats), the parity-test proposal is a forward-looking section that
benefits from sitting next to the existing test description, and the
`@endo/bytes` ramifications section is short enough that it doesn't
warrant its own file. If the maintainer prefers a `designs/`-style
document, the section can be promoted in a follow-up.

**No `@endo/bytes` source edits**: explicitly authorized scope. The
ramifications section documents the option; the actual install lives
in a follow-up PR against `@endo/bytes` once the spackle-now-or-later
decision is made.

## `@endo/bytes` assessment summary

Three operations are candidates for the spackle rendezvous:
`bytesToImmutable`, `bytesFromImmutable`, `concatImmutables`. The
install would mirror `@endo/harden`'s pattern (`Object[Symbol.for(
'endo.bytesToImmutable')]` etc.).

Four operations are explicitly not candidates: `bytesEqual`,
`bytesFromText`, `bytesToText`, `concatBytes`. They operate purely on
`Uint8Array`, have no realm-wide identity concern, and the spackle
coordination would add cost without benefit.

The required changes to `@endo/bytes` are non-breaking: the public
named exports (`bytesToImmutable`, etc.) stay; only the implementation
files (`src/to-immutable.js`, `src/from-immutable.js`,
`src/concat-immutables.js`) add the install-and-prefer-install dance.
No new dependencies (the pattern uses `Symbol.for` and
`Object.defineProperty` both already available). No new package
exports. No coordination required with existing dependents
(`@endo/marshal`, `@endo/pass-style`, vat infrastructure); they
benefit automatically from realm-wide single-source-of-truth.

The open question: whether the operations are realm-identity-
sensitive enough to warrant the spackle pattern's coordination cost.
`@endo/harden` has clear needs (`WeakSet` dedup, eval-twin
recognition). `@endo/eventual-send` (forthcoming spackle) has clear
needs (marked-promise recognition). `@endo/bytes` has a softer case:
the principal benefit is forward-compat with a future native
`bytesToImmutable` analog or a TC39-standardized
`Uint8Array.prototype.toImmutable`. The maintainer's judgment on
whether to spackle now or wait for a precipitating downstream caller
is the right gate; the README section documents the option and the
shape, the actual install is a follow-up.

## CI status

Not run. This commit is README-only; the gate's deterministic probes
relevant to prose (`no-ascii-banners`, `no-pull-citations`,
`sentence-per-line-md`) pass on the new content. `yarn format` and
`yarn lint` could not be run (the dispatch worktree has not been
through `yarn install` and the pre-push-gates script reported
"project doesn't seem to have been installed"). The
`filename-no-stutter` probe surfaces three pre-existing findings on
`packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js`,
`test/immutable-arraybuffer-pony-slice.test.js`,
`test/immutable-arraybuffer-shim-slice.test.js`; these predate this
PR and are not in this dispatch's scope.

## Definition of done

- [x] All three ponyfill-usage / parity-proposal / @endo/bytes-
  ramifications asks addressed in `packages/immutable-arraybuffer/
  README.md`.
- [x] Single regular-append commit (`2071b71e3`); no force push; no
  un-draft / re-draft.
- [x] Pushed to `mirror/3164-freezable-typedarrays`.
- [x] Reply comment posted on PR #417 issue-comment thread citing
  the commit SHA and summarizing each of the three sections.

Self-improvement: nothing this time.
