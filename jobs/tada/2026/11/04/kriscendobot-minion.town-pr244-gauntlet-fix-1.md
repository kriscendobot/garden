**Fix round 1 for PR #244 is done: all must-fix items are applied and pushed, and CI is green at `d1587e923cc`.** `ci-wait-merge` returned rc 0, and both Actions runs (`test (typecheck + vitest)` and `clip frame browser gate`) succeeded. On this host it can only see Actions runs, not commit statuses or non-Actions checks.

**Commits pushed with `safe-push-pr-head.sh` (e9d0a15a → d1587e92):**
- `4594745f`: keeps the idempotency key while an outcome is unknown (saboteur 1, a must-fix). This now covers dropped connections and `-unavailable` answers, and holds across Back and Next and a reopened reattach dialog. The refresh after a create also moved out of the create's `try`.
- `21d8b8a9`: Create waits for the model catalog, and a stale catalog answer is ignored (saboteur 2 and 3).
- `993d4e03`: a factory outage no longer hides providers on the server or in the browser, and step 2 stops at the provider while no harness can be offered (assessor 2, saboteur 4).
- `80701632`:
  - Guards the `find()` cast, so a missing old provider reports an unknown remainder (typist 1, a must-fix; also assessor 5 and saboteur 6).
  - Merges registry and factory attachments (assessor 3).
  - Adds a distinct `agentId` field, and `/replace` now takes `agentIds` (typist 2).
- `7be790fe`: route checks narrow without casts, and the unread count defaults to 0 (typist 3 and 4).
- `d1587e92`: cuts the comments pruner 2–5 flagged.

I also applied pruner 1's cuts to the PR body, added a CI link, and posted the item-to-commit summary: https://github.com/kriscendobot/minion.town/pull/244#issuecomment-6630895815

**Testing:** typecheck and the six test files covering this change pass locally on Chromium (114 tests, including new browser and endpoint tests). The full suite hit its 400-second limit locally, so CI is the only full-suite evidence. Firefox and WebKit could not launch here.

**Panel claims that didn't hold up:**
- **Assessor 4:** no change needed. `confirmAction` replaces the inputs with the summary, so the second press can't confirm a raise the user never saw. A test assertion now pins this.
- **Assessor 1:** overstated. `reload()` catches its own failures, so a failed refresh never reached the create's `catch`. The commit only tightens the `try`, and a new test covers the behavior.

**Left open (all recorded in the PR comment):**
- Assessor 6: the unpriced-model note still asks for a token budget, and the form has no field for one.
- Pruner 6 and 7: acknowledge items, left unchanged.
- Remaining nits: typist 5 and 6, saboteur 5 and 7. Whether a repeated `dismissMail` is a no-op in the factory is still unverified.
- **Attachment merge:** it is only tested against fakes, because the registry on endo-but-for-bots#1648 reports no `attachedAgents` yet. If the registry later reports attachments without `agentId`, factory agents would be counted twice.

**Out of scope, not fixed:** `openAgent` has no error handling, so a failed fetch when opening an agent's detail view gives the user no feedback.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr244-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2830333 cached reads)
- Output: 42610 tokens
- Cost: $2.6005306000000004
- Wall-clock: 1731s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
