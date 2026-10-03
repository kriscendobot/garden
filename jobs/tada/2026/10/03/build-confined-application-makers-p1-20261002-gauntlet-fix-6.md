## Fix round 6 for endojs/endo-but-for-bots#1417: all 4 must-fix items done, CI green

I pushed one commit, `85457233dd`, on top of `7e0be5e1a2` using `safe-push-pr-head.sh`. `ci-wait-merge` returned rc 0: all 33 checks finished with 0 failures.

**Must-fix items**
1. **Percent-encoded control characters.** Encoded controls like `%09`, `%0a`, `%0d` and `%7f` used to reach `lookup`. `decodeSegment` now checks for control characters after decoding, so they are refused the same way raw ones are. That covers every power and also what the `canonicalSegments` hook returns.
   - The test generator `pathFragment` now produces encoded controls.
   - Tab is no longer in the `safeSegment` alphabet or the pinned-encoding table.
   - New tests cover each power, `pathToFileURL`, and the hook.
2. **PR description.** It now names `canonicalSegments` and says a `Mount` must be passed as `readOnly()` or as a snapshot. It also covers the empty-segment collapse and the NUL/control refusal. I tightened or dropped the sections that only said "none".
3. **Design doc.** Phase 2 now says "`canonicalSegments` hook".
4. **Summary comments.** I posted the missing round-3 and round-5 summaries late, plus a round-6 summary with a status line and a map from each item to its commit.

**Should-fix items: 5 of 6 done**
- **Read-only is the caller's job.** The module header, the function doc, the changeset, the README and the design now say nothing checks that the tree is read-only, and the caller must pass `readOnly()` or a snapshot.
- **File-vs-directory check.** There is a new shared `isDirectoryEntry` helper in `packages/platform/src/fs/entry-kind.js`. `checkinTree`, `checkoutTree` and `isFile` all use it now, so the three copies are gone. New tests cover an entry with both `list` and a reader, and one with only a reader.
- **Frozen-segments test.** The test comment now says that `E()` freezes arguments itself, so the test does not prove the `harden` calls are needed. A new test checks that the hook receives frozen segments, where `E()` is not involved.
- **Design paragraph.** It is rewrapped and "relies on this" points at the right sentence.
- **Node versions.** The escaping comment now says Node 22 and 24 are confirmed and Node 20 is unverified.

**Checks:** all 424 `packages/platform` tests pass locally, eslint shows 0 errors on the touched files, and prettier is clean. I could not run `tsc` locally because it isn't installed in the worktree, so CI is the only type check.

**Follow-ups**
- **Commit regrouping is still open.** Squashing the 14 commits into feat / test / docs / one `chore: Update yarn.lock` needs a history rewrite and force-push, which this stage doesn't do. It has to happen before the PR comes out of draft.
- The panel's comment-only items are not done: no model-based `maybeRead` property and no tests for different Unicode normalizations of the same name.
- Panel round 7 comes next and the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2766615 cached reads)
- Output: 20439 tokens
- Cost: $1.6915749999999998
- Wall-clock: 2310s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
