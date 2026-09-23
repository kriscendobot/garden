---
ts: 2026-06-16T04:27:00Z
kind: result
role: fixer
worktree: dispatches/fixer--32650e/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/16/035500Z-dispatch-fixer-32650e.md
---

# Fixer result: PR #435 erights 29-comment review

Addressed all 29 inline asks from review id 4502549835 on PR #435
(immutable-arraybuffer drop-the-pseudo-prototype).

## SHAs

Pre-engagement HEAD: `448fa0298`
Post-engagement HEAD: `9926e4187`

Four append-only commits:

- `285bdac8` `feat(immutable-arraybuffer)!: drop public exports; package becomes side-effect-only`
- `e3c91668` `feat(immutable-arraybuffer): stage-3 detect-then-skip shim install`
- `6f942682` `fix(pass-style): tighten byteArray own-property check with typed allowlist`
- `9926e418` `docs(immutable-arraybuffer): apply review-feedback to DESIGN.md, README.md, and changeset`

## Substantive design moves

All three substantive directions in the review are now in scope and landed:

- **Premise-2 fold-in.** The package is side-effect-only.
  `packages/immutable-arraybuffer/index.js` is deleted; `package.json`
  `exports` is `./shim.js` plus `./package.json` only.
  Public names (`isBufferImmutable`, `sliceBufferToImmutable`,
  `optTransferBufferToImmutable`) are gone from the package surface.
  The lib's free-function helpers remain `export`-ed from `src/lib.js`
  so in-package tests can exercise them directly.
  `@endo/bytes`'s `to-immutable.js` migrates from
  `sliceBufferToImmutable(buf, ...)` to `buf.sliceToImmutable(...)`
  on the prototype, and imports `@endo/immutable-arraybuffer/shim.js`
  for its side effect.
- **Stage-3 detect-then-skip shim install.** Replaces the prior
  warn-and-overwrite. The shim's entire install is gated on
  `!('sliceToImmutable' in ArrayBuffer.prototype)`; a prior install
  (native or shim) wins. The `expectedOverwrites` static list and
  the `typeof console !== 'undefined'` guard are removed (no longer
  reachable).
- **Typed byteArray own-property allowlist.** `Set([Symbol.toStringTag])`
  becomes `Map([[Symbol.toStringTag, 'string']])`; the check now
  verifies each enumerated own-property is a non-enumerable data
  property of the expected `typeof`.
  `packages/pass-style/src/byteArray.js` also adopts the destructure
  form per the suggestion (`const { prototype: arrayBufferPrototype }
  = ArrayBuffer`) and drops the "or natively, once the proposal
  stabilises" hedge from the comment block.
  New `packages/pass-style/test/byteArray.test.js` covers six cases
  (one canonical accept, one well-formed-shape accept, four
  augmented-shape rejects).

## Per-ask resolution mapping

| Inline | File:line | Resolution | SHA(s) |
| --- | --- | --- | --- |
| `3417576450` | DESIGN.md:132 | Suggestion: `amplifyArrayBuffer = buffer => {` | `9926e418` |
| `3417581855` | DESIGN.md:159 | `arrayBufferSlice` still exists; added clarifying paragraph | `9926e418` |
| `3417591118` | DESIGN.md:179 | `optResize === undefined` typed diagnostic | `285bdac8` + `9926e418` |
| `3417592294` | DESIGN.md:185 | Same for `optTransfer` (+ `optTransferToFixedLength`) | `285bdac8` + `9926e418` |
| `3417628515` | DESIGN.md:280 | Moot after premise-2 fold-in | `285bdac8` + `9926e418` |
| `3417629696` | DESIGN.md:265 | Drop `.` entirely; premise-2 folded in | `285bdac8` + `9926e418` |
| `3417655926` | DESIGN.md:359 | Stage 3, not stage 1 (and same TC39 proposal) | `9926e418` |
| `3417695983` | DESIGN.md:366 | Detect-then-skip at stage 3 | `e3c91668` + `9926e418` |
| `3417777228` | DESIGN.md:467 | Own-property purposeful violation kept | `9926e418` |
| `3417785927` | DESIGN.md:480 | Feature test on `sliceToImmutable`, stage 3 | `e3c91668` + `9926e418` |
| `3417794922` | DESIGN.md:517 | Defer to prior installation | `e3c91668` + `9926e418` |
| `3417804440` | DESIGN.md:538 | Only `shim.js` exported | `285bdac8` + `9926e418` |
| `3417814465` | DESIGN.md:558 | Keep shared helper; rename off "heir" | `9926e418` |
| `3417819345` | DESIGN.md:569 | In scope (premise-2) | `285bdac8` + `9926e418` |
| `3417821093` | DESIGN.md:573 | In scope (bytes migration) | `285bdac8` + `9926e418` |
| `3417826137` | DESIGN.md:581 | Purposeful violation in scope (already done) | `9926e418` |
| `3417837245` | .changeset:15 | Stop exporting `isBufferImmutable` | `285bdac8` + `9926e418` |
| `3417845611` | .changeset:33 | Drop all exported names | `285bdac8` + `9926e418` |
| `3417867066` | index.js:1 | Deleted | `285bdac8` |
| `3417880102` | README.md:4 | Lib layer removed from README | `9926e418` |
| `3417882964` | README.md:5 | Side-effect-only framing | `9926e418` |
| `3417884856` | README.md:7 | Internal mechanics removed | `9926e418` |
| `3417899182` | README.md:43 | Suggestion: "frozen `Uint8Array`" | `9926e418` |
| `3417902943` | README.md:74 | Lib layer section removed | `9926e418` |
| `3417909998` | README.md:92 | Suggestion: new "Without either" wording | `9926e418` |
| `3417919469` | README.md:99 | Stage-3 defer-to-prior framing | `9926e418` |
| `3417936240` | byteArray.js:20 | Drop stabilisation hedge | `6f942682` |
| `3417940728` | byteArray.js:22 | Destructure form per suggestion | `6f942682` |
| `3417948858` | byteArray.js:42 | Typed `Map` allowlist + new tests | `6f942682` |

No items declined.

## Test results

- `corepack yarn workspace @endo/immutable-arraybuffer test`: 53 passed.
- `corepack yarn workspace @endo/pass-style test`: 30 passed (includes 6 new `byteArray.test.js` cases).
- `corepack yarn workspace @endo/bytes test`: 32 passed.
- `corepack yarn workspace ses test`: 505 passed (2 pre-existing known failures unrelated).
- `corepack yarn workspace @endo/marshal test`: 78 passed.

## Pre-push-gates

Final run: `result: gate passed.` All eight probes pass; `yarn format`
and `yarn lint --fix` auto-fixed and re-staged (no manual intervention
required); `yarn typecheck` skipped (no per-package script in the
touched packages).

## URLs

- Top-level summary comment: `https://github.com/endojs/endo-but-for-bots/pull/435#issuecomment-4714974596`
- Re-requested reviewer: `erights`
- 29 inline replies posted via
  `gh api repos/endojs/endo-but-for-bots/pulls/435/comments/<id>/replies`;
  URLs follow the `pull/435#discussion_r<reply-id>` shape and
  range from `r3418109152` (first) to `r3418111719` (last).

## Recommended next stage

PR #435 is in `reviewDecision: CHANGES_REQUESTED` from the erights
review now addressed. Recommended next stage:

1. Wait for erights's re-review on the new HEAD. Expected outcome:
   APPROVED (the substantive directions are landed; remaining risk
   is whether the docs rewrites read as intended). If erights
   surfaces follow-up asks, dispatch a second fixer.
2. If APPROVED, dispatch [boatman](roles/boatman/AGENT.md) to ferry
   the PR upstream to `endojs/endo` (the bot-fork PR is the mirror;
   the actual landing target is upstream).

CI status on the new HEAD was not checked in this dispatch; the
shepherd may want a follow-up if any matrix has gone red on the
detect-then-skip transition.

## Self-improvement

The four-commits-by-topic shape worked well for a 29-comment review
spanning multiple files and concerns; the maintainer's per-ask table
in the top-level comment maps cleanly to commit SHAs because the
commits are topically distinct. The one snag was the JSDoc-only
changes in `lib.js` traveling with the diagnostic guards in the same
commit; in a future split-by-topic engagement, separating "code
change" from "comment-only rewrite" into two commits would let a
reviewer skip the comment-only diff faster.

Self-improvement: nothing this time.
