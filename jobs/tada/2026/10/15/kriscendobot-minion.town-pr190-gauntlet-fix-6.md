Fix round 6 for kriscendobot/minion.town PR #190 is done: all four must-fix items from the panel-6 review are applied, pushed, and CI is green on the new head. I did not re-run the panel; the driver posts panel-7.

**What changed** (three follow-up commits pushed to `clip-gutter-reorder` with `safe-push-pr-head.sh`, head moved from `c99ca91` to `0dfbf03`):

- **engine-realist (drag state)**, `f4c7550 fix(shell)`: the drop handler in `deploy/aws/www/shell.js` now clears `draggedId` itself. `dragend` only re-renders after a cancelled drag, and the `dropCommitted` flag is gone. A new test in `test/shell-clip.test.ts` sends a foreign `dragover`/`drop` with no `dragstart` after a completed drop. It checks that nothing is prevented, nothing moves, and nothing is saved.
- **spec-keeper (mixed-case labels)**, `9b82ba0 fix(gateway)`: `isClipOrder` now accepts only canonical lowercase labels (`idToLabel(labelToId(h)) === h`). Uppercase and mixed-case hashes are rejected with 400 instead of being stored and never matching. New unit tests cover this, and the endpoint's 400 cases now include an uppercase hash and an uppercase/lowercase pair.
- **spec-keeper / engine-realist (keepalive limit)**: a note beside `MAX_CLIP_ORDER_LENGTH` says the `keepalive` fetch is limited to 64 KiB in flight. A maximal body is about 55 KB, so raising the limit past about 1190 would break large saves. The `saveClipOrder` JSDoc points to that note and says some engines may not honor `keepalive`.
- **pruner (repeated comments)**: the `clip-order.ts` header now points to `designs/clip-shell-framework.md` § 2 instead of repeating its reasoning. I deleted the comments that only restated names (over `MAX_CLIP_ORDER_LENGTH`, `ClipOrderStore`, `write`, and `reorderDirectionForKey`) and the "last save wins" clause in the `saveClipOrder` JSDoc.
- **purist (admission failures)**, `0dfbf03 fix(account)`: the account-store failure handling now lives inside the shared `admit` gate, so all four routes answer a store failure with a 503 and `no-store`: `GET /account/clips`, `PUT /account/clips/order`, `/account/guest-formula-id` and `/account/guest-locator`. The PUT route's own try/catch is removed. The admission test now checks all four routes, and the route docs say "distinct lowercase clip labels".

**Verification:**
- Locally, typecheck is clean and the three touched test files pass (77 tests).
- The full local suite has 1 failure out of 1159 tests: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file has nothing to do with this change and passes in CI.
- CI run "test (typecheck + vitest)" on `0dfbf03` finished with **success**: https://github.com/kriscendobot/minion.town/actions/runs/38812016258

**Problem during the CI wait:** `ci-wait-merge.sh` (deadline 3600s) went past the shell's 10-minute limit, moved to the background, and was killed before it returned an exit code. My own polling of the Actions runs API, every 10 seconds, also ran the bot account out of GitHub API quota until it reset at 22:15Z. After the reset I polled once a minute until the run reached completed/success. So "green" here comes from the Actions runs API, not from `ci-wait-merge.sh` returning 0.

**Follow-ups:** none required. Optional items left for later from the comment-only seats:
- property-based tests for `orderClips`, `moveClip` and `createOrderSaver`
- re-running the label check when reading a saved order file
- renaming the local `clipsFor` so it doesn't clash with the dependency of the same name

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2715228 cached reads)
- Output: 15626 tokens
- Cost: $1.5273736000000002
- Wall-clock: 2450s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
