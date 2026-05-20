---
ts: 2026-05-20T05:14:02Z
kind: message
role: boatman
to: liaison
project: endo
repo: endojs/endo
worktree: dispatches/boatman--ferry-module-source-74--20260520-050914--ca9df6
refs:
  - entries/2026/05/20/050922Z-dispatch-liaison-ca9df6.md
---

# Blocker: upstream branch force-updated mid-flight, fast-forward append impossible

The dispatch promised a fast-forward append onto `endojs/endo#3241` with upstream
tip at `c7fef87bc415615848d9f33f8cd8ba55ad8510c4`, no `--force` / `--force-with-lease`.
At push time the remote rejected with `fetch first`. Re-fetching shows
`origin/kriskowal-module-source-1596` has been force-updated to
`dac52928571fd2083f8a64fedcfb6186230763d2`. The pre-flight ancestor check
(`git merge-base --is-ancestor origin/kriskowal-module-source-1596 HEAD`) now
exits 1: my cherry-pick is built on the old `c7fef87b`, which is no longer in
the ancestry of the new tip.

## What the new tip looks like

`dac52928` and its parent `2560db72b` rewrite the original two upstream commits:

- Author flipped from `Kris Kowal <kris@agoric.com>` to the same identity, but
  with new committer dates of `Tue May 19 22:12:39 2026` (right now).
- Body's `Refs endojs/endo#1596` rewritten to `Refs #1596`.
- The `Co-Authored-By: Claude` trailer on what was commit two has been dropped.
- Also rebased onto a newer `master`: the new tip diff against `c7fef87b`
  picks up `packages/module-source/tsconfig.composite.json` (new file) and a
  `packages/module-source/tsconfig.json` rewrite, both from the composite
  TypeScript build work that landed on `master` between dispatch issue and
  push attempt.

This is not a pure attribution rewrite. It is a maintainer-side rebase onto a
fresher base, possibly performed by the user directly. It supersedes the
ferry's fast-forward append plan.

## What I did before discovering the conflict

1. Confirmed source head `cb73507827eaa6ec8173909155156ea732839279` and the
   stated upstream tip `c7fef87b...` matched the dispatch.
2. Detached at `c7fef87b`, set local identity to `Kris Kowal
   <kriskowal@kriskowal.com>` (the NEW attribution default flagged in the
   dispatch).
3. Cherry-picked `cb735078`. The cherry-pick auto-merged cleanly. The new
   commit `c450eaef1` carried the original endolinbot author.
4. Amended with `--reset-author` and a new message: subject
   `fix(module-source): apply boneskull review comments` (stripped `(#74)`,
   stripped `endo#3241`), body preserved verbatim (no fork-only refs in this
   body to drop; no Claude trailers in this body). New SHA `29507b80a`.
5. Verified attribution: author and committer both `Kris Kowal
   <kriskowal@kriskowal.com>`. `git interpret-trailers --parse` is empty.
6. Pre-flight ancestor check passed against the **stale** `origin` ref.
7. `git push origin HEAD:kriskowal-module-source-1596` was rejected.
8. Refetched; observed the force-update; the ancestor check now fails.

## What I did not do

- No second push, no `--force`, no `--force-with-lease`. The dispatch
  explicitly forbids them; even if they were permitted, replaying my
  fast-forward push onto a non-ancestor remote would overwrite the
  maintainer's force-update and erase the new tsconfig work that arrived
  with the rebase.
- No comment on `endojs/endo-but-for-bots#74`. The dispatch's source-side
  cross-link step is conditional on a successful upstream push.
- No journal `result` entry. This is a `message`-to-liaison instead.

## What the liaison needs to decide

Three plausible paths, in increasing order of effort:

1. **Re-issue the ferry against the new tip.** If the maintainer's force-update
   already includes the `cb735078` content (boneskull's two review fixes),
   the ferry is already done by other means and the source-side cross-link
   comment is the only remaining step. Verify by diffing
   `packages/module-source/src/transform-source.js:33` and
   `packages/module-source/test/module-source.test.js:464,479` against
   `dac52928`. If those changes are present at the new tip, the boneskull-
   review content is upstream and #74 can be closed.
2. **Re-cherry-pick onto the new tip.** If the maintainer's force-update
   only rebased the existing two commits onto a fresher master without
   adding the boneskull-review content, dispatch a fresh boatman against
   `dac52928571fd2083f8a64fedcfb6186230763d2` as the new upstream tip.
   Same plan, fresh starting point.
3. **Ask the maintainer directly.** The force-update happened while a ferry
   was in flight, which suggests the user picked up the work and rewrote
   the branch by hand. A liaison ping confirms whether the user wants the
   boatman to continue, or considers the ferry obsolete.

The cherry-pick is left in place at `29507b80a` in my detached project
worktree, in case the orchestrator wants to inspect it before teardown.

Self-improvement: the pre-flight ancestor check correctly guarded the
push, but a single-pass `fetch -> check -> push` race window let the
maintainer's force-update slip in unnoticed; a future boatman skill (when
the procedure crystallizes) could refetch immediately before push and
re-run the ancestor check, so the LLM diagnoses the conflict instead of
the push command's `fetch first` rejection. Also worth flagging for the
gardener's brief: the new `kriskowal@kriskowal.com` attribution default
applied cleanly through this dispatch — when the path forward unblocks,
that default still produces the intended author/committer triple under
`--reset-author`.
