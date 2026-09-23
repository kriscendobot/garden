---
ts: 2026-06-18T04:35:00Z
kind: result
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 461
    role: target
refs:
  - entries/2026/06/18/021500Z-dispatch-builder-d056ac.md
  - https://github.com/endojs/endo-but-for-bots/pull/461
  - https://github.com/endojs/endo/pull/3036#issuecomment-4737660964
---

# result: builder d056ac (exo-stream mirror) — partial via orchestrator writeback

Builder `d056ac` (opus, dispatched 02:15Z) hit a rate-limit
ceiling at 04:31Z after 532 tool uses / 90 minutes runtime
with the error `API Error: Server is temporarily limiting
requests (not your usage limit) · Rate limited`. The builder
could not write its own result entry; the orchestrator
(liaison) writes this on its behalf.

## What the builder accomplished

Pushed 8 commits to `kriskowal-exo-stream-llm` (tip
`93fa0d144`):

1. `531c72211` `refactor(daemon): migrate to @endo/exo-stream wire protocol`
2. `64a6f40e9` `refactor(platform): migrate fs to @endo/exo-stream wire protocol`
3. `f8fde206a` `test(daemon): migrate to @endo/exo-stream wire protocol`
4. `b243740d5` `refactor(cli): migrate to @endo/exo-stream`
5. `7361b702f` `refactor(chat,chat-network-view): migrate to @endo/exo-stream`
   — chat ref-iterator.js retired; ~14 component files
   migrated; chat-network-view peer module migrated too
6. `ab95e6f68` `refactor(genie,fae,jaine,lal,sandbox,agent-tools): migrate to @endo/exo-stream`
   — fae's local `makeRefIterator` copy retired; sandbox's
   `makeReaderExoFromAsyncIterable` now returns a
   `PassableBytesReader` via `bytesReaderFromIterator`
   (structural change for stdio capture)
7. `4c1081ede` `refactor(git,exo-git): migrate GitBlob/GitTree to @endo/exo-stream`
   — surprise: builder discovered git/exo-git also had
   migration targets not in the researcher's scope
8. `93fa0d144` `chore: Update yarn.lock`

## What's left (WIP, uncommitted in dispatch worktree)

The builder ran out of API budget mid-iteration. The dispatch
worktree at `/home/kris/dispatches/builder--d056ac/project`
has the following modified files (status from `git status
--short` at 04:34Z):

**Staged (`M ` left column)**:
- `packages/chat/token-autocomplete.js`
- `packages/daemon/src/daemon.js` (partial — also in
  unstaged, indicating mid-iteration)
- `packages/daemon/src/directory.js`
- `packages/daemon/test/content-store-gc-invariants.test.js`
- `packages/daemon/test/content-store-gc.test.js`
- `packages/daemon/test/endo.test.js`
- `packages/daemon/test/mount.test.js` (also in unstaged)
- `packages/fae/endo-skill.js`

**Unstaged (` M` right column)**:
- `packages/chat/browser-tree.js`
- `packages/chat/file-explorer.js`
- `packages/chat/spaces-gutter.js`
- `packages/chat/test/component/send-form.test.js`
- `packages/chat/test/component/token-autocomplete.test.js`
- `packages/chat/test/helpers/mock-powers.test.js`
- `packages/daemon/src/mount.js`
- `packages/daemon/test/git.test.js`
- `packages/daemon/test/mount-platform-fs-conformance.test.js`
- `packages/sandbox/src/factory.js`

This is roughly 15 files of WIP polish — likely test
adaptations + the few files that needed deeper changes than
the bulk-migrate commits captured.

## Did NOT happen

- Tests not run (or not finished running)
- Pre-push-gates not run on the final state
- The 8 pushed commits may or may not pass tests; CI on the
  open PR will surface this

## What the orchestrator did

- Opened DRAFT PR #461 at
  https://github.com/endojs/endo-but-for-bots/pull/461 with
  the 8 pushed commits (base `llm-5be4392`).
- Posted upstream follow-up comment on endo#3036:
  https://github.com/endojs/endo/pull/3036#issuecomment-4737660964
  (per the liaison's earlier upstream commitment that the
  mirror PR number would follow).
- PR body notes the WIP situation explicitly so reviewers
  understand the polish is pending.

## Next-stage decision (queued for user)

Two reasonable paths:

**Path A — Fixer-first close-out**: dispatch a fixer to use
the existing `builder--d056ac` worktree (or transplant the
WIP to a fresh worktree), commit + push the WIP as
`refactor: post-migration polish` (or split per package),
run tests, then advance to cleaner. Preserves the builder's
in-progress work.

**Path B — Cleaner-first on pushed state**: dispatch cleaner
on the 8 pushed commits as-is; let CI failures surface what
the WIP would have fixed, then a fixer addresses them. Risks
churn if the WIP would have prevented findings the cleaner
+ panel would then re-surface.

The liaison's recommendation: **Path A** — the WIP is
substantively close to what the next-stage panel would
otherwise flag, so committing it preserves builder intent
and shortens the gamut.

The builder worktree (`/home/kris/dispatches/builder--d056ac`)
is **preserved** (not torn down) so the WIP survives the next
dispatch.

## Self-improvement

Opus dispatches on large multi-file migrations should:
- Receive a periodic checkpoint commit-and-push directive
  embedded in the dispatch brief (e.g., "commit + push after
  each logical unit lands; do not batch all commits to the
  end") so a rate-limit termination doesn't lose work.
- Have the dispatch brief explicitly authorize the builder
  to STOP and write a partial result entry at the
  ~80%-budget mark rather than push through to exhaustion.
- The researcher missed the existing thin scaffolding PR
  #330 + the git/exo-git migration scope; future researcher
  briefs should explicitly ask "are there prior mirror PRs
  for this upstream PR?" and "what packages depend on the
  old API beyond the researcher's enumeration?"
