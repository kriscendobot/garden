---
ts: 2026-05-22T19:00:15Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/22/185433Z-dispatch-liaison-f549ee.md
---

Re-ferried `endojs/endo-but-for-bots#352` (redo of #67) over `endojs/endo#3274` as a single commit, force-pushed with lease.

- Source: `endojs/endo-but-for-bots#352` at `2e8b3f89` (`design/issue-2390-harden-exports-patterns`).
- Upstream PR: `endojs/endo#3274` on `kriskowal-harden-exports-2390`.
- Prior upstream head: `c2f53e866648e8ca0918483fb56f14f0de0d6f7d` (lease point).
- New upstream head: `e153a5afa74e78d5d89d86a3740a8c3cb7f19c19`.
- Attribution: single commit, `Kris Kowal <kriskowal@kriskowal.com>` (author and committer).
- Trailer-strip: removed `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` from the source body; `git interpret-trailers --parse` is empty on the new commit. Added `Closes #2390`.
- Path-restricted tree-identity: `git diff 2e8b3f89 HEAD -- $PATHS` empty over the three changed paths (`.changeset/harden-exports-destructuring.md`, `packages/eslint-plugin/lib/rules/harden-exports.js`, `packages/eslint-plugin/test/harden-exports.test.js`).
- Pre-flight: refetched `origin/kriskowal-harden-exports-2390`, verified still at `c2f53e866` before push.
- Push mode: `--force-with-lease=kriskowal-harden-exports-2390:c2f53e866648e8ca0918483fb56f14f0de0d6f7d`. Accepted by remote (`+c2f53e866...e153a5afa HEAD -> kriskowal-harden-exports-2390 (forced update)`).
- Approval persistence: post-push `gh pr view 3274` reports `reviewDecision: APPROVED` (turadg APPROVED 2026-05-21T17:36:50Z still on file), state OPEN, mergeable MERGEABLE, headRefOid matches new SHA. Title and body left untouched on #3274.
- Source-side cross-link posted under kriskowal: https://github.com/endojs/endo-but-for-bots/pull/352#issuecomment-4521938742. Names the new upstream head SHA and the predecessor-#67 context.
- Identity discipline on `endojs/endo#3274`: no direct comments.

Self-improvement: nothing this time; the dispatch's two-step amend (cherry-pick then `--amend -F newmsg` to strip the Claude trailer and add `Closes #2390`) worked cleanly. A future pr-handoff skill should call out that `--amend --reset-author --no-edit` preserves the body including any Claude `Co-Authored-By:` lines, so a second `--amend -F` pass is required when the source body carries one.
