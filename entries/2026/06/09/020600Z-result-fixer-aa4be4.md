---
ts: 2026-06-09T02:06:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--aa4be4/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: target
refs:
  - entries/2026/06/09/015900Z-dispatch-fixer-aa4be4.md
  - https://github.com/endojs/endo-but-for-bots/pull/430
  - https://github.com/endojs/endo-but-for-bots/pull/430#pullrequestreview-4454381962
---

# result: fixer — addressed erights's 4 inline asks on PR #430

Applied erights's CHANGES_REQUESTED review `4454381962` on PR
`endojs/endo-but-for-bots#430`. Pre-head `1ef6c174d`, post-head
`740259d2b` (four commits, one per ask).

## Commits

| # | sha | headline |
| - | --- | -------- |
| 1 | `8a4702253` | refactor(immutable-arraybuffer): rename freezableTA to typedArray in amplifyTypedArray |
| 2 | `d3a550f37` | docs(immutable-arraybuffer): drop unexplained "rendezvous participant" from race-to-install comment |
| 3 | `74db04d0a` | docs(immutable-arraybuffer): rewrite buffer-getter rationale (no genuine TA has an immutable backing buffer) |
| 4 | `740259d2b` | test(immutable-arraybuffer): strengthen indexed-assignment swallow test + add non-extensible test |

## Per-ask outcomes

- **Item 1** (`freezableTA` → `typedArray` at `freezable-typedarray-pony.js:69`):
  mechanical rename of the parameter and 5 JSDoc references inside the
  `amplifyTypedArray` definition. No call-site changes (parameter is
  function-local). Commit `8a4702253`.
- **Item 2** ("rendezvous participant" at
  `immutable-arraybuffer-shim.js:52`): took the **drop and reword**
  option. The term contrasted this shim with the harden race in
  `make-selector.js` but wasn't defined here and the contrast wasn't
  carrying its weight. Reworded the comment to describe what this shim
  actually does (a unilateral check on `arrayBufferPrototype` that yields
  to any prior installer) without inventing terminology. Commit
  `d3a550f37`.
- **Item 3** (confusing buffer-getter sentence at
  `immutable-arraybuffer-shim.js:111`): rewrote per erights's framing.
  The replaced wording said "genuine TypedArrays whose backing buffer is
  an immutable wrapper return the wrapper rather than leaking the genuine
  ArrayBuffer" — a genuine TypedArray's backing buffer can only be a
  genuine ArrayBuffer; the immutable wrapper never plays that role. New
  wording says directly that the replaced getter makes the `buffer`
  accessor return the immutable wrapper rather than leaking the genuine
  ArrayBuffer it stands in for. Commit `74db04d0a`.
- **Item 4** (test at `immutable-arraybuffer-shim-slice.test.js:132`):
  the prior `t.throws(() => { ta3[0] = 9; ta3.set([9]); })` would have
  passed even if `ta3[0] = 9` had thrown (because `set` always throws).
  Split into separate assertions: `t.notThrows(() => { ta3[0] = 9 })`,
  `t.is(ta3.at(0), 3)` via the amplifying `at` accessor (which reads
  through to the hidden TypedArray's actual byte value, unchanged from
  the original `ta1[0] = 3`), and `t.throws(() => ta3.set([9]))`. Added
  the second test erights requested: `Object.preventExtensions(ta3)`
  followed by `ta3[0] = 9` throws (can't add a new own property to a
  non-extensible object in strict mode), with the underlying byte still
  proven unchanged. Both new tests run green; full
  `@endo/immutable-arraybuffer` suite reports 50 tests pass + 1 known
  expected-fail. Commit `740259d2b`.

## Replies posted

Per-thread `/replies` (4) + top-level summary (1):

- item 1 thread: https://github.com/endojs/endo-but-for-bots/pull/430#discussion_r3377400153
- item 2 thread: https://github.com/endojs/endo-but-for-bots/pull/430#discussion_r3377400634
- item 3 thread: https://github.com/endojs/endo-but-for-bots/pull/430#discussion_r3377401005
- item 4 thread: https://github.com/endojs/endo-but-for-bots/pull/430#discussion_r3377401338
- top-level summary: https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655340915

## Out-of-scope items honored

- Did NOT re-request review (per dispatch authorization scope; the
  maintainer / senior-contributor set the pace on a draft experiment).
- Did NOT shepherd CI; the 12 pre-existing FAILURE checks from the
  premise-2 `@endo/bytes` deferral remain on the new head.
- Did NOT address the still-open premise-2 question; that requires
  separate maintainer direction.
- Did NOT touch other PRs and did NOT trigger panel/judge.

## Pre-push gate

Ran `pre-push-gates.sh --probes-only`. Two pre-existing findings from
`filename-no-stutter` on `immutable-arraybuffer-{shim,pony}*.js` files
that have carried those names since well before this PR (oldest:
`25039f561`); the probe fires on any line change in those files. Not
introduced by this dispatch and out of scope. All other probes pass
(no ASCII banners, no pull citations, no inline-import JSDoc, no
non-ASCII in source, security-md hash uniform, sentence-per-line MD,
test-package no main).

Self-improvement: nothing this time.
