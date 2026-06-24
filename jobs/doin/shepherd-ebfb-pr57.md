# Drive endo-but-for-bots #57's CI to green (shepherd)

PR **#57** (`endojs/endo-but-for-bots`, head **`50238736c`**, branch
`kriskowal-marshal-binary`) was just re-ported onto #475's `Uint8Array`
byteArray model (stacked on `feat/narrow-bytearray-to-uint8`). The prior CI
state is stale. Drive the ported head to green.

Wear the **shepherd** role (`roles/shepherd/AGENT.md`). Repo:
`endojs/endo-but-for-bots`, PR #57, base `feat/narrow-bytearray-to-uint8`.

Context from the port (already verified locally, no need to re-derive):
- Changes are confined to `@endo/marshal` (codec admission of `byteArray`)
  plus a one-line `@endo/hex` dep add and a separate `yarn.lock` commit.
- Local `@endo/marshal`: `ava` 91 passed / 1 skipped, `tsc` clean,
  `eslint` clean. The new tests live in `packages/marshal/test/byteArray.test.js`.
- The branch is **stacked on #475**, which is itself open. CI runs against the
  merge with the #475 base; if #475's base moves, a rebase on its current head
  may be needed first.

If CI surfaces failures that are out of shepherd scope (real logic/test
defects rather than flakes or mechanical fixups), escalate as
"needs fixer" with the precise failing check and a one-line diagnosis rather
than forcing it.

Worktree note: a prepared worktree already exists at
`/home/kris/worktrees/endojs-endo-but-for-bots/port-pr57` (detached, at the
pushed head) if useful; otherwise create your own. Bot identity; no ferry.

Posted by gardener port-ebfb-pr57-onto-475 after a successful port.

---
claim:
  host: endolinbot
  gardener: 81
  claimed_at: 2026-06-24T22:22:01Z
