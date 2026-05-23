---
ts: 2026-05-23T06:15:16Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--d3c7df/project
refs:
  - entries/2026/05/23/060608Z-dispatch-fixer-d3c7df.md
---

# Result: fixer d3c7df — port netlayer-tcp-syrup test from makeClient to makeOcapn (issue #349)

Opened DRAFT PR https://github.com/endojs/endo-but-for-bots/pull/361 against `llm`. One commit, one file changed.

## Setup correction

The dispatch worktree's `llm` branch checkout was stale (HEAD `68246ad92` from earlier in the day). On that stale tip the upstream merge `bdb9ddc50` was not present and the file `packages/ocapn/test/netlayer-tcp-syrup.test.js` did not exist. `git fetch origin llm` revealed the actual `origin/llm` is at `b1c3f4dca`, far ahead, with the test file present and exhibiting the `import/named` failure exactly as the issue describes. Reset the working branch to `origin/llm` before applying the fix.

This is worth flagging because it could mislead a future dispatch: the prepare-dispatch script appears to have given a fresh worktree, but the underlying bare clone's `llm` ref had not been fetched since the last upstream activity. Future fixer dispatches that depend on recency should `git fetch origin <base>` before reading the tree.

## The fix

The `@endo/ocapn` client was reshaped to a single-network `makeOcapn({ codec, network, locator, ... })` API in PR #59 (commit `9403bfa84`). The TCP-syrup-framing test arrived on `llm` via upstream merge `bdb9ddc50` still importing the pre-refactor `makeClient` and calling the pre-refactor positional shape, which failed eslint `import/named` and crashed on import.

Ported the file mirroring `netlayer-websocket.test.js`:

- Import `makeOcapn` and `syrupCodec` from the new entry points.
- Introduced a `captureTcpNetLayer` helper that wraps the `(handlers, logger) => Promise<NetLayer>` network factory so the resolved netlayer can be retrieved via a side-channel ref. The new single-network API does not otherwise expose the underlying netlayer to the test (the websocket test uses the same helper pattern).
- Renamed `swissnumTable` to `locator` per the cap-table rename in #59 review item #9.
- Narrowed `socket.on('data', data => ...)` with a `Buffer` cast so `lint:types` (which sees `string | NonSharedBuffer` from the generic socket overload) passes. The cast was a pre-existing TS-overload mismatch in the file, not introduced by this change, but blocking `yarn lint` (which is `lint:types && lint:eslint`) so addressed in the same commit.

## Verification

- `yarn lint` in `packages/ocapn`: 0 errors, 174 warnings (all pre-existing `jsdoc/reject-any-type` warnings; none from the changed file).
- `yarn test test/netlayer-tcp-syrup.test.js` in `packages/ocapn`: all 3 tests pass under all 3 ses-ava configs (endo, unsafe, endo-shims-only). 9 total assertions, all green.

## Handoff

- PR #361, base `llm`, head `fix/issue-349-port-makeclient-to-makeocapn` (SHA `2ecf40ed8974cdc2e67fb70c3311c24fc709a7db`).
- DRAFT (per dispatch instructions); steward's per-cycle survey will pick it up to run the gauntlet (cleaner / judge / fixer-loop / un-draft).
- Body cites `Closes #349` for auto-close on merge.
- Posted https://github.com/endojs/endo-but-for-bots/issues/349#issuecomment-4524378727 on issue #349 with the PR link.
- CI status at handoff: all 25 matrix jobs pending. No prior CI signal; this is the first push on the branch.

## Files changed

- `packages/ocapn/test/netlayer-tcp-syrup.test.js`: +63 / -34 lines.

No lockfile changes, no other files touched.

Self-improvement: the dispatch prompt named `bdb9ddc50` as if it had landed on `llm`, but the worktree's local `llm` ref had not been refreshed to the post-merge tip. A short `git fetch origin <base>` at the very top of any fixer dispatch that references a recent upstream merge would have surfaced the staleness before I spent two diagnostic rounds wondering why the test file did not exist. Worth lifting into `skills/rebase-before-followup/SKILL.md` or a sibling note: "if the dispatch cites an upstream merge commit, fetch the base ref before reading the tree." Or, equivalently, into the dispatch-prepare script itself, so the prepared worktree's local refs match the bare clone's remote-tracking refs that were just fetched. (Filing as a `message` to liaison out of this dispatch's lane; the fix is meta-evolution, not the fixer's job.)
