---
kind: result
role: locksmith
host: endolin-garden-ece02cb4
at: 2026-08-28T05:13:07Z
---
# locksmith review — endojs/endo-but-for-bots PR #1074 (panel seat)

Dispatch: jury seat `locksmith`, `journal/jobs/doin/endojs-endo-but-for-bots-pr1074-gauntlet-20260828-panel-2.md`
(gauntlet `endojs-endo-but-for-bots-pr1074-gauntlet-20260828`, panel round 2).
Worktree reviewed: `scratch/project-wt-endojs-endo-but-for-bots-pr1074-gauntlet-20260828-panel-2-b186e450`,
diff base `8629faeb207df77b3f5fb7c51e1e19c5689d996b` → HEAD.

### locksmith

**Verdict:** approve

**Findings:**

None. This PR adds one new `@endo/hardened262` test262-derived test file
(`packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js`, 124 lines)
plus 36 mechanical per-host `baseline/*/{passed,skipped}.txt` updates recording where
that new test lands (skipped on the `sesXs`/`sesNode`/`xs` compartment/lockdown legs,
passed on the plain `module`/`sloppy`/`strict` legs). There is no module code touched
and nothing in the diff crosses this seat's remit:

- **No capability flow.** The test file only reads intrinsic metadata already
  reachable from the test262 harness includes (`TypedArray`, `TypedArrayPrototype`,
  the constructor family) — `new TypedArray()`, `Object.getPrototypeOf`, property
  descriptors, `Object.prototype.toString.call`. It hands nothing to a callee, holds
  no capability across an assertion boundary, and defines no attenuator.
  [rule: roles/jurors/locksmith/AGENT.md]
- **No new export or grant.** Nothing in the diff adds a parameter, export, or call
  path a caller did not already have; the baseline `.txt` files are inert manifests
  (one filename per line), not code. [rule: roles/jurors/locksmith/AGENT.md]
- **No boundary crossing.** The lone runtime-relevant assertion (`detached.buffer.transfer()`
  then re-checking `@@toStringTag`/`Object.prototype.toString` still report the
  constructor name post-detach, `packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js:105-124`)
  observes the platform's own `[[TypedArrayName]]` slot behavior; it does not hand a
  capability across an SES/vat/endo boundary, so the warden's boundary-discipline
  overlap doesn't apply here either. [rule: roles/jurors/locksmith/AGENT.md]

**Notes (out of scope but worth flagging):**

None.

Self-improvement: this round's diff had zero surface for the locksmith's remit — a
pure test262-baseline PR with no module code. No brief change proposed; the brief's
"docs-only PR that surfaces a capability" pattern doesn't recur here since a
`baseline/*.txt` line is a test-runner manifest entry, not documentation of a call
path.
