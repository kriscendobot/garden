**Fix round 5 for kriscendobot/minion.town#229 is done: the one must-fix is fixed and CI is green (7/7 checks).**

**What the panel asked for.** The latest panel review (5760368207) had one must-fix, from the saboteur juror. When replacing a key, the Replace dialog still showed the radio buttons for picking an existing provider. Picking one hid the new-provider fields, but submitting still sent `/replace` with the hidden key and every checked agent, which is not what the user had selected.

**What I changed** (commit `637a9a08`, pushed to `feat/claude-api-provider-ui` with `safe-push-pr-head.sh`):
- **The fix** (`deploy/aws/www/provider-ui.js`): when replacing, `openCreate` now hides `#provider-choices`, and submit ignores any provider choice while replacing.
- **One small should-fix from the same juror:** a submit that the user cancelled no longer clears the busy state of a newer submit when it finishes (`if (operation === current)` around `setBusy(false)`). To keep that guard from leaving a reopened dialog stuck busy, `openCreate` now calls `setBusy(false)`.
- **New browser test** (`test/provider-ui-browser.test.ts`): it clicks "Replace key" and checks that the provider choices are hidden, the new-provider fields are visible, and the attached agent is moved to the replacement. I confirmed the test fails with the hide removed and passes with it in.

**Checks I ran locally:** the provider-UI browser tests pass in Chromium (4/4) and `tsc --noEmit` is clean. Prettier reports style issues in both files, but they were already there before my change and the repo doesn't enforce Prettier, so I left them alone.

**Not addressed.** The remaining panel items were all should-fix or comment-only, and this round covers only the must-fix. The main ones left open:
- the app receives the whole registry root rather than a facet with only `directoryFor`;
- `POST /create` has no per-owner rate limit or cap;
- the status check can unlock a different key while the first request is still running;
- `grantIds` has no count cap.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1439751 cached reads)
- Output: 7317 tokens
- Cost: $0.9988022000000001
- Wall-clock: 407s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
