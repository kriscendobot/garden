# Fix round 6 for kriscendobot/minion.town #249: done, CI green

The latest panel verdict was review 5782848429, posted against `de1e42ba`. Its request-changes items came from two jurors, pruner and decomplector. I applied every pruner item and the one decomplector must-fix, and pushed them to `fix/api-key-agent-panel3`. All 7 CI checks pass on head `769eed99`.

**Decomplector must-fix: key replacement keeps only the agent move path** (commit `f147cdd0`)
- The speculative grant path in `replacementMoves` is removed: the snapshot ownership guesses and the registry `providers.reattach` branch.
- Key replacement now moves only active factory agents (`agentIds`). An agent still being created is still refused. A retry of a replacement that already committed still reports a refused selection only as `unmovable`.
- **Behavior change:** any non-empty `grantIds` sent to `/account/providers/:id/replace` is refused with 400 `invalid-request` before anything commits. The changeset's Breaking line now says so.
- UI (`provider-ui.js`): a grant-only record is still listed, with a disabled, unchecked checkbox marked "cannot move; reattach it after replacing". The request no longer sends `grantIds`.
- Tests:
  - Tests that only exercised the grant path were deleted.
  - Tests with an equivalent agent scenario were converted to `agentIds`.
  - New tests cover the `grantIds` refusal (nothing is superseded or reattached) and the empty-`grantIds` case.
  - `test/inference-provider-service.test.ts` sent `grantIds` through the replace route, so those two route tests became one refusal test. The registry reattach tests there are unchanged.

**Pruner items**
- **Comments that restated the code** (commit `bd9eae3b`, plus two removed in `f147cdd0`): removed from `provider-ui.js`, `agent-endpoint.test.ts` and `agent-ui-browser.test.ts`. The doc comment on `replacementMoves` is shortened, without the two paragraphs that repeated the PR body.
- **PR body:** cut from 395 to 288 words. The repeated closing paragraph and the repeated retry bullet are gone, and the text now describes the agent-only behavior.

**CI**
- The first push (`bd9eae3b`) went red on the three browser gates (chromium, firefox, webkit). `test/provider-ui-browser.test.ts` still expected the UI to move a grant-only record, and my local checks had not covered that file.
- Commit `769eed99` updates that test to expect a disabled checkbox and no reattach. It passed locally in chromium.
- `ci-wait-merge.sh --no-merge` then returned rc 0: 7 of 7 checks green. CI was slow to start and needed several bounded waits.

The full local `npm test` had one failure, `projectPartition > propagates a git failure…`. This PR doesn't touch that code, and CI's `test` job passed.

**Follow-up for panel 7:** the decomplector's should-fix items 2 and 3 are not done. Item 2 is a declarative field table for the `publicAgent` projection. Item 3 is to reject or fully ignore the deprecated `operationId`, which is currently still validated when sent.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1982647 cached reads)
- Output: 13687 tokens
- Cost: $1.8322519
- Wall-clock: 4654s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
