---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T02:49:42Z
---
role: prover
repo: endojs/endo-but-for-bots
project: endo
pr: 796
panel: gauntlet-panel-2

### prover (regression evidence)

**Verdict:** request-changes

All findings below were verified by mutation against the worktree
(`scratch/project-wt-endojs-endo-but-for-bots-pr796-gauntlet-panel-2-a55b0f0f`);
baseline is green (crc32 8/8, hashline 42/42) and the tree was restored after
each experiment. The composition, CAS, reapply, and both round-1 fixes ARE
load-bearing: reverting the leading-LF blank seed reddens
`a blank anchor never collides with a bare-digit content line`, reverting the
ambiguity/mismatch coexistence reddens its regression test, swapping
before/after composition reddens 5 tests, and reverting `bytes.at(offset)` to
`bytes[offset]` reddens the emulated-view test. Those are properly pinned.

**Findings:**

- `packages/crc32/test/crc32.test.js:62` — `rejects a non-conforming proxy over a
  Uint8Array` asserts only `{ instanceOf: TypeError }`, but the native
  `%TypedArray%.prototype.length` brand check already throws a TypeError on a
  proxy receiver. Verified: deleting the entire `try/catch` diagnostic wrapper at
  `packages/crc32/src/crc32.js:46-56` leaves all 8 tests green. The test pins
  "throws" — which the unpatched code already did — not the contract the code
  claims. Assert the message
  (`{ instanceOf: TypeError, message: /genuine or emulated ArrayBuffer view/ }`).
  must-fix [rule: skills/regression-evidence/SKILL.md]
  [rule: AGENTS.md § Testing with AVA — "Prefer `t.throws(fn, { message: /.../, instanceOf: X })` over bare `t.throws`"]

- `packages/daemon/src/hashline.js:166` — the 4-char anchor width is never
  exercised through `renderHashlineLines`. Verified: hard-coding `hexWidth = 2`
  there leaves all 42 tests green. This regression is *silent*: narrow anchors
  still validate against a wide file (`test/hashline.test.js:365` proves exactly
  that), so a broken render emits 2-char anchors for a 5000-line file, degrading
  collision resistance from 1/65536 to 1/256 in precisely the files the width
  switch exists for, and raising the reapply ambiguity rate — with no error
  surfaced anywhere. `anchorHexWidthForLineCount` is unit-tested
  (`test/hashline.test.js:83`) but neither of its two call sites is. Add a
  >4096-line render assertion. must-fix [rule: skills/regression-evidence/SKILL.md]

- `packages/daemon/src/hashline.js:590` — same gap on the other call site:
  hard-coding `fileWidth = 2` also leaves 42/42 green. The one test that
  distinguishes `hashActualAtPatchWidth` from `hashActualAtFileWidth`
  (`test/hashline.test.js:312`) uses a 3-line file, where 2 is right by accident
  of file size rather than by computation. `hashActualAtFileWidth` is the field
  that tells the agent the file's native width, so an unpinned wrong value is
  bad re-read guidance. should-fix
  [rule: skills/coverage-driven-testing/SKILL.md]

- `packages/daemon/src/hashline.js:239-241` — the read-each-untrusted-property-
  once hardening (`rawAnchor` / `rawAnchorEnd` / `rawPayload`), landed in
  e85632df5b as a purist should-fix, has no test: the suite contains no
  getter-backed or Proxy-backed op object, so reverting to inline `raw.anchor`
  reads cannot redden anything. One op whose `anchor` is an accessor returning a
  valid anchor first and a hostile one second pins it in ~6 lines. should-fix
  [rule: skills/regression-evidence/SKILL.md]

- `packages/daemon/src/hashline.js:890` — removing `.sort((a, b) => a.relocatedTo
  - b.relocatedTo)` on the relocation report leaves 42/42 green; both relocation
  tests happen to have insertion order equal to sorted order. The determinism of
  the reported order is unpinned. comment-only
  [rule: skills/coverage-driven-testing/SKILL.md]

**Notes (out of scope but worth flagging):**

- `packages/daemon/test/hashline.test.js:617` — the title
  `reapply hash checks at the relocated line strip the seed` names the mechanism,
  but the test asserts that relocation *fails* (`hash-mismatch`). The test is
  load-bearing (using `anchor.line` instead of `candidateLine` in `searchReapply`
  would make it succeed); only the title misspells the contract.
  [rule: skills/test-title-spec-spelling/SKILL.md]

- `packages/daemon/src/hashline.js:552` — deleting the `options.sha256Hex`
  function check leaves 42/42 green, because `sha256Hex(...)` then throws a
  TypeError and `test/hashline.test.js:762` uses a bare `t.throws`. Same shape as
  finding 1, lower stakes (a diagnostic, not a security boundary). The two
  loop-driven `t.throws(..., undefined, 'case N')` suites
  (`test/hashline.test.js:135`, `:255`) carry the same weakness: a case can pass
  on an unrelated error. [rule: AGENTS.md § Testing with AVA]

Self-improvement: `skills/regression-evidence/SKILL.md` § Procedure tells the
author to break the code and watch the test redden, but says nothing about the
failure mode all three must-fix/should-fix findings here share — a *guard* whose
removal leaves a native error of the same class (a TypeError from a brand check,
a TypeError from calling a non-function), so a bare `instanceOf` assertion stays
green. Worth a named sub-case in that skill: "when the code under test replaces
a native throw with a better-diagnosed one, `instanceOf` alone is not evidence;
assert the message." Routing as a message to `liaison`.
