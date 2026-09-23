---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-08-28T06:14:05Z
---
# assessor review — endojs/endo-but-for-bots PR #1074 (panel seat)

Dispatch: jury seat `assessor`, `journal/jobs/doin/endojs-endo-but-for-bots-pr1074-gauntlet-20260828-panel-4.md`
(gauntlet `endojs-endo-but-for-bots-pr1074-gauntlet-20260828`, panel round 4).
Worktree reviewed: `scratch/project-wt-endojs-endo-but-for-bots-pr1074-gauntlet-20260828-panel-4-b186e450`,
diff base `8629faeb207df77b3f5fb7c51e1e19c5689d996b` → HEAD.

### assessor

**Verdict:** approve

**Findings:**

None must-fix or should-fix. The diff is one new test262-style file,
`packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js` (129 lines),
plus 36 mechanical per-host `baseline/*/{passed,skipped}.txt` line additions
recording where the new test lands. Walked the test's control flow and its
invariant claims against the spec it encodes:

- `new TypedArray()` / `TypedArray()` both correctly assert `TypeError` for the
  abstract %TypedArray% superclass (lines 8-21).
- `assertSharedSuperclass`/`assertToStringTagName` are applied via
  `testWithTypedArrayConstructors` and `testWithBigIntTypedArrayConstructors`
  (lines 42-43, 96-97) so both Number- and BigInt-backed families are covered,
  not a spot-checked subset — no early-return or fall-through skips a family.
  [rule: roles/jurors/assessor/AGENT.md]
- The joined-string `metadata` assertion (lines 46-63) and the detached-buffer
  tail (lines 118-129) match spec behavior as I can verify it: `@@toStringTag`
  keys off `[[TypedArrayName]]`, which survives `ArrayBuffer.prototype.transfer()`
  detachment, so asserting the getter and `Object.prototype.toString` still report
  `'Int8Array'` post-detach is the correct invariant, not a contradicted one — no
  breaker-overlap finding here.
- Baseline placement (skipped everywhere except `module`/`lockdownModule` across
  all three engine baselines) exactly matches the pre-existing pattern for the
  sibling `*IteratorPrototype/intrinsic-metadata.js` tests already in those same
  files — not a new asymmetry this PR introduces. [rule: roles/jurors/assessor/AGENT.md]

**Notes (out of scope but worth flagging):**
- The single `.join('|')` + one `assert.sameValue` for 9 unrelated properties
  (lines 46-63) means a failure on any one property reports a single opaque diff
  rather than naming which property regressed. Diagnostic-quality taste, not a
  correctness defect; single-seat comment-only. [rule: roles/jurors/assessor/AGENT.md]

Self-improvement: no brief change proposed. The brief's control-flow/invariant
remit had real surface here (spec-level invariant checks across two constructor
families) and the brief's guidance was sufficient to review it without gaps.
