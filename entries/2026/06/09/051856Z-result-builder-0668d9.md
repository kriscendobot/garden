---
ts: 2026-06-09T05:18:56Z
kind: result
role: builder
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/builder--0668d9
short_id: 0668d9
to: steward
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: created
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
---

# result: builder implemented the drop-the-pseudo-prototype redesign as PR #435 (0668d9)

## What landed

A DRAFT PR at [endojs/endo-but-for-bots#435](https://github.com/endojs/endo-but-for-bots/pull/435)
targeting the frozen base `master-4a04d07`. Branch:
`build/immutable-arraybuffer-drop-the-pseudo-prototype` on origin.
Nine commits, one per design move plus the gate-induced fix commits.

Title: `feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic (per DESIGN.md)`.

## Commits (in order)

1. `a0e2342a9` `feat(immutable-arraybuffer): rename pony to lib, drop intermediate prototype` (Moves 1 + 3)
2. `4f0a9452f` `feat(immutable-arraybuffer): amplifier-with-this-fallthrough for ArrayBuffer` (Move 2)
3. `e2eaeff27` `feat(immutable-arraybuffer): shim copies lib property record onto ArrayBuffer.prototype` (Move 4)
4. `626014298` `feat(ses): drop %ImmutableArrayBufferPrototype% permits and intrinsic sampling` (Move 5, boundary-crossing)
5. `839b53919` `fix(pass-style): align byteArray brand check with the new immutable-ArrayBuffer prototype shape`
6. `7d059c4f5` `test(immutable-arraybuffer): amplifier-with-this-fallthrough coverage and changeset`
7. `0df10cf4c` `test(ses): tolerate immutable-arraybuffer shim overwrite warnings in stderr fixture`
8. `f0668ec99` `chore(immutable-arraybuffer): rename src/test files to drop package-name stutter`
9. `53e276c66` `docs(immutable-arraybuffer): drop pull-request URL from README per pre-push-gate`

Commits 1 through 4 are the design's five moves in order
(1+3 combined per the brief). Commit 5 is the pass-style "make the
call" simplification. Commits 6 and 7 add coverage and adapt a
ses test fixture that the new shim warning broke. Commits 8 and 9
are gate-induced fixes: the `filename-no-stutter` probe rejected
the `immutable-arraybuffer-{lib,shim}.js` basename pattern that the
design specified, and the `no-pull-citations` probe caught a
sentence-per-line split that surfaced a pre-existing `pull/2311`
URL as a new added line.

## Affected packages

- `@endo/immutable-arraybuffer` (minor): all five moves' subject
  matter; renamed lib + shim; narrowed-but-pending-premise-2 exports;
  amplifier-with-this-fallthrough methods; new test file
  `test/shim-amplifier.test.js`.
- `ses` (minor): permits entry removal; intrinsics-sampling removal;
  unrelated stderr-fixture adaptation.
- `@endo/pass-style` (patch): byteArray brand-check simplification
  (observable behaviour unchanged).

The multi-package changeset
`.changeset/drop-the-pseudo-prototype.md` carries the three bumps.

## Explicit calls made

The brief flagged `packages/pass-style/src/byteArray.js:14-45` as
needing a "leave or simplify" call: **simplify**. The
`adaptImmutableArrayBuffer` indirection that discovered the
intermediate prototype has nothing to discover in the new shape;
the structural prototype-identity check now names
`ArrayBuffer.prototype` directly. The `immutable` accessor is the
brand check, captured from `ArrayBuffer.prototype`'s `immutable`
descriptor (with a constant-false fallback when the shim has not
been imported, preserving the prior behaviour of denying
immutability on bare platforms).

## Pre-push-gate status

- `yarn format`: pass.
- `yarn lint --fix`: pass.
- `filename-no-stutter`, `no-ascii-banners`, `no-inline-import-jsdoc`,
  `no-non-ascii-in-source`, `security-md-hash-uniform`,
  `test-package-no-main`: pass.
- `no-pull-citations`: **fail** on `packages/immutable-arraybuffer/DESIGN.md`
  (designer's commit cites PRs #430 and #417 as provenance).
- `sentence-per-line-md`: **fail** on `packages/immutable-arraybuffer/DESIGN.md`
  lines 5, 8, 26 (multi-sentence prose in the designer's commit).
- `yarn typecheck`: skipped (no workspace-root script).

Both failures are exclusively on DESIGN.md and exactly the two the
dispatch brief named as expected. The probes' findings are noted
but not blocking.

## Test runs

- `packages/immutable-arraybuffer`: 47 pass (existing shim suites,
  renamed lib suites, new shim-amplifier suite).
- `packages/ses`: 505 pass, 2 known failures (pre-existing), 2 skipped
  (pre-existing).
- `packages/pass-style`: 24 pass.
- `packages/bytes`: 32 pass.

## Surface adaptations the design did not anticipate

Three small adaptations the design's text did not call out, surfaced
during implementation:

- **Lib tests now import the shim at the top.** The design's test
  plan offered this as an alternative ("Alternatively, the tests are
  restructured to install the shim first"). Without the shim install,
  emulated immutables have no methods on their prototype chain since
  the lib's property record is not yet on `ArrayBuffer.prototype`.
  Taking the alternative keeps the test bodies otherwise unchanged
  and preserves the free-function call-shape coverage that
  `sliceBufferToImmutable` and `optTransferBufferToImmutable` provide.

- **`@endo/immutable-arraybuffer` still re-exports the two free
  function helpers.** The design's narrowing to `isBufferImmutable`
  only is the destination state, but the bytes-side migration
  (premise-2 in the six-premises framing) is out of scope per the
  design itself. Removing the free-function exports would break
  `packages/bytes/src/to-immutable.js` immediately; instead the
  exports stay until the premise-2 follow-up PR retires them.

- **The shim warning now fires for four genuine accessors on modern
  Node.** `byteLength`, `detached`, `maxByteLength`, and `resizable`
  exist on `ArrayBuffer.prototype` on platforms with the
  resizable-ArrayBuffer proposal, and our installed shadow versions
  trigger the overwrite warning. The design's text predicted this
  (Move 4 paragraph 4) but the SES test fixture
  `permit-removal-warnings-node.test.js` asserted the stderr's first
  line; commit 0df10cf4c teaches the fixture to skip leading shim
  warnings before its existing assertion.

## Filename-stutter deviation from design

The design names the lib file `src/immutable-arraybuffer-lib.js` and
the test files `test/immutable-arraybuffer-lib-{slice,transfer}.test.js`.
The pre-push-gate `filename-no-stutter` probe (added 2026-05-20)
rejects basenames that start with the package directory's name.
Commit f0668ec99 renames to `src/lib.js`, `src/shim.js`, and
`test/{lib,shim}-*.test.js`. The DESIGN.md narrative still cites the
older filenames in its prose; the design's filenames were intended
as path identifiers for the redesign's authorship moment, not as
binding contracts. README prose references update to the new names.

## Comment posted to PR #430

Per the brief, replied on PR #430 with the link to PR #435 as a
top-level issue comment: id 4656379877. The comment is one
paragraph naming the implementation PR number and the design
filename so a reader of the design PR can find the implementation.

## Self-improvement

The design's five-move structure made the staging discipline
straightforward: each move maps to one commit, and the "intermediate
commits don't have to run in isolation" framing the designer's
result entry articulated meant I didn't have to reorder moves to
keep tests passing between commits.

Two things worth lifting to a skill in the future, if they recur:

- A pre-push-gate probe that names an exact file pattern the design
  text is going to violate (`filename-no-stutter` vs the
  `immutable-arraybuffer-lib.js` basename the design specified)
  should ideally be caught at design-review time, not at implementation
  push time. The designer's checklist could include a probe-name pass
  before declaring the design implementable; or the design template
  could mention the probe constraints alongside the existing
  *Status* / *Authors* / *Affects* frontmatter. Worth raising with
  the gardener if the pattern recurs (this is the first instance I
  know of).

- The lib-tests-import-shim adaptation was foreseen by the design
  ("Alternatively, the tests are restructured to install the shim
  first; this is the cleaner shape"), but the design did not commit
  to one alternative. Future builder dispatches into similar redesigns
  would benefit from designs that pick one and name the rationale,
  so the implementer can act without re-reasoning. Worth a one-line
  addition to `skills/designs/SKILL.md` if such a skill exists:
  *"when offering alternatives, name a preferred one and the
  rationale, so the implementer reads a decision rather than a
  fork."* Below the threshold for a dispatch on its own; will
  surface to the liaison if the next two design-to-build dispatches
  hit the same pattern.

Self-improvement: nothing this time. (The two observations above are
forwarded to the liaison's attention but do not warrant an inbox
message on their own; the threshold rule per
`skills/self-improvement/SKILL.md` requires a repeat pattern.)
