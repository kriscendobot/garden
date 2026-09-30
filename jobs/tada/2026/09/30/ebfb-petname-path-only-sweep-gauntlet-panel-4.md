I ran panel round 4 on PR #1390 (head `257db20fe5`, base `llm-8e53cc0` / `8e53cc0f89`) and the result is **must-fix**. `panel.sh` exited 0, and all 33 seats finished with no errors.

**The vote:** 7 seats asked for changes (archivist, assessor, integrator, orthographer, packager, stylist, surfacer), 5 were comment-only (changeset-auditor, corner-prober, fast-checker, saboteur, scribe), and 21 approved.

**Verdict posted:** https://github.com/endojs/endo-but-for-bots/pull/1390#pullrequestreview-5371776848. It went up as a COMMENTED review, not request-changes, because GitHub won't let the bot request changes on its own PR. Earlier rounds were posted the same way. The full panel output was 88KB, over GitHub's 65KB limit, so the review holds a summary plus each non-approving seat's findings.

**Must-fix findings:**
- **Unconverted call sites.** Some calls still pass a bare string where the daemon now requires an array. Each one throws `TypeError` at runtime, and the tests don't catch it because their mocks skip the new check:
  - `space-file-explorer/src/preact/use-file-explorer.js`: the `lookup` calls in `resolveProfileHost()`, `openByPetName()` and the inventory classifier.
  - `spaces-util/src/send-form.js` and `spaces-util/src/command-executor.js`: the channel-mode `post()` calls.
  - `space-channel/src/share-modal.js`: `post()` and `send()`.
  - The typedefs that describe the channel `post` method still declare the old argument shape (should-fix).
- **Naming in commit `abaf878461`.** The same argument is spelled four different ways across the daemon source files.
- **`srcDir`** in the two new tests should be `sourceDirectory`.
- **Docs:** `lal/primer/tools.md` still documents `adopt(..., petName)` instead of `petNamePath`.
- **Spelling:** `'Cancelled'` should be `'Canceled'` in `daemon/src/host.js:2236`.

**Should-fix and comment-only findings:**
- The `@endo/lal` changeset doesn't mention the `petNameOrPath` → `petNamePath` rename, which breaks agent callers.
- The channel member `post` now validates its arguments before `checkAccess()`; the access check should come first.
- Two changesets describe the same rename and should be merged into one.
- The `lal` search-tool test stub accepts bare strings, so those tests don't reflect the real contract.
- Property-based tests for the two path helpers would be a useful follow-up.
- Two fix-up commits (`ab42d2de95`, `09350117e6`) have no summary comment on the PR.
- The PR description is 343 words, over the 300-word limit.

I made no fixes, didn't un-draft the PR, and ran only this one round. The fixer stage gets these findings next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (781266 cached reads)
- Output: 6701 tokens
- Cost: $0.8901932
- Wall-clock: 785s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
