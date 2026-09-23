---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-08-29T14:10:53Z
---
# assessor review — endojs/endo-but-for-bots PR #1085 (panel seat)

Dispatch: jury seat `assessor`, `journal/jobs/doin/endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3.md`
(gauntlet `endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet`, panel round 3).
Worktree reviewed: `scratch/project-wt-endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3-2b2d7c65`,
diff base `65eb8869dc3b8e94bffcfdd2f0a8cc53d5947b06` → HEAD.

### assessor

**Verdict:** approve

**Findings:**

None must-fix or should-fix. The diff adds `streamGlob`/`streamGrep` (PassableReader
counterparts to the existing eager `glob`/`grep`) to `packages/daemon/src/mount.js`,
plus the matching `MountInterface`/`types.d.ts` guards and help text. Traced the
control flow against the invariants the PR's own comments claim:

- **Revocation.** `assertLive()` runs synchronously at invocation (a revoked mount
  throws before any generator is constructed) and is re-checked inside the async
  generator immediately before every `yield`, in both `streamGlob` and `streamGrep`
  (`packages/daemon/src/mount.js:949-970`, `:1003-1035`). With the default
  `buffer: 0`, `reader-pump.js`'s pump waits for a consumer sync before each
  `iterator.next()`, so the check genuinely gates the *next* pull — a mid-stream
  `revoke()` rejects the next element with no further delivery, matching the
  method-comment claim. Confirmed against `mount-stream-search.test.js`'s
  revoke-mid-stream cases. [rule: roles/jurors/assessor/AGENT.md]
- **Buffer clamp.** `clampStreamBuffer` (`mount.js:59-77`) correctly collapses
  non-number/non-finite/negative/fractional input to a whole number in
  `[0, STREAM_BUFFER_MAX]`; combined with buffer>0 pre-ack semantics in
  `reader-pump.js`, the documented "up to `buffer` already-settled elements may
  still be delivered after revoke" claim holds — those elements are pulled (and
  pass their own pre-revoke `assertLive()` check) before the consumer observes the
  revocation, which is an accurate, not an overstated, invariant.
- **Early-close vs. eager walk.** The comments on `streamGlob` and the `streamGrep`
  fallback path both assert the directory walk is eager (global sort forces the
  whole confined tree before the first element) while grep's *content* reads are
  incremental. Checked against `packages/platform/src/fs/search.js`'s
  (pre-existing, untouched) `globPaths`/`grepFiles`: `globPaths` does build its
  full `sorted` array before its first `yield`, and `grepFiles` reads file content
  lazily per path batch — so the claim is accurate, not falsified by the body.
- **`readOnly()` exclusion.** The help/JSDoc state that the read-only `ReadableTree`
  view does not carry `streamGlob`/`streamGrep`. Confirmed: `readOnly()`
  (`mount.js:1893` region and the directory-level counterpart) returns a
  `makeExo('EndoMountReadableTree', ReadableTreeInterface, …)`, a structurally
  distinct interface that never lists the two new methods — the claim holds.

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: no brief change proposed. The revocation/buffer/incrementality
invariants this PR documents were substantive and checkable against the body; the
existing control-flow/invariant remit was sufficient.
