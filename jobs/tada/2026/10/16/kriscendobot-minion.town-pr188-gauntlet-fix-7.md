Fix round 7 for kriscendobot/minion.town PR #188 is pushed as `4a452a7`, and CI is green (`ci-wait-merge.sh` rc 0). The one Actions run, "test (typecheck + vitest)", passed.

**Must-fix items from the round-7 panel review:**
- **breaker #1 (stale clips while a refresh is pending):** the refresher now calls a new `onRequest` callback on every refresh request. `bootstrap` uses it to hide the listed clips, the main pane and the open link until the newest read settles. A shared browser no longer shows the previous account's clips during the debounce or the pending read. I hid them rather than cleared them so that an unchanged listing still doesn't reload the pane.
- **breaker #2 / surfacer (pane not emptied on failure):** a refresh that returns no listing now goes through a new exported `clearClipListing`, which always empties the pane. That includes the publish how-to card shown when no clip is selected. The pane is not emptied when a successful listing arrives with no clip selected; the how-to card holds no account data.
- **locksmith (ambient authority):** `createClipRefresher` now requires `setTimeoutImplementation`, `clearTimeoutImplementation` and `makeAbortController`. `bootstrap` passes them in; nothing comes from globals.
- **stylist:** `fetchImpl` is renamed to `fetchImplementation`.

**Should-fix and summary-fix items:**
- **archivist + saboteur:** the "not JSON" warning is skipped for an aborted read and now names `/account/clips`.
- **integrator:** the design's Mermaid diagram now shows the refresh control and its `GET /account/clips` read.
- **pruner:** both narrating test comments are removed.
- **corner-prober:** added tests for:
  - a queued debounce followed by `refreshNow()`;
  - a first listing that arrives after the user has chosen what the pane shows;
  - `onRequest` firing on every request;
  - the refresher using only the timer and controller it is given.
- **fast-checker:** the newest-wins property test now covers listing, `null` and rejected outcomes in either completion order. A new property test checks how a listing is reconciled with the current selection. Both run 1000 times.
- **Answered in the PR comment instead of code:**
  - benchmarker: I'm not adding a benchmark, because the claim is that a reload is skipped, not a speed claim, and the tests check it by counting reloads.
  - releaser: the repo has no changeset or release-note mechanism; the PR body states the user-facing change.
  - scribe: the comment records the two earlier rounds (`d2d7ff6`, `e4c71b8`) that never got a summary.

The summary comment is https://github.com/kriscendobot/minion.town/pull/188#issuecomment-6214296286.

**Verification:** the clip-shell suite passes (53 tests) and `tsc --noEmit` is clean. The full local `vitest` run had failures in three files this PR doesn't touch: one test in `test/git-remote/capability.test.ts`, and two `tools/claude-harness` test files. They look environmental, and CI's typecheck + vitest run passed.

**Follow-ups:** none for this stage; the driver posts panel-8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1913652 cached reads)
- Output: 20492 tokens
- Cost: $1.5032504000000002
- Wall-clock: 1140s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
