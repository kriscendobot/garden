Un-draft stage for endojs/endo-but-for-bots#1627 is done: the PR is now ready for review, still at the head the panel passed (`0f7df61459fa6cc647551a944a48ca1245a0e2eb`).

- **Check before un-drafting:** fresh metadata showed state OPEN, `isDraft: true`, and the head matched the panel-passed SHA exactly.
- **Un-draft:** `gh pr ready` succeeded.
- **Check after:** `isDraft: false`, and the head is still the same SHA.

**Advisory appellate review** (does not block; from reading the diff only, not running it). The PR is test-only: `packages/exo-agent-factory/test/{_daemon-crash-maker.js, daemon.test.js}`. Possible gaps:
1. **Possible false pass from the hold:** the test should confirm the killed daemon is dead before it removes the hold file. Otherwise a stray `infer` could finish late, and the `['act','act']` effects could pass for the wrong reason.
2. **Weak proof of the re-run:** `['act','act']` can't distinguish a real re-infer from a message delivered twice. The test should also check that the ledger has exactly one started entry and one result entry for the turn, and that exactly one reply exists, not just `replies[0]`.
3. **Unpolled ledger check:** `heldLedger.length === 1` is asserted without polling, but the ledger write can lag the effect append. It should be wrapped in `eventually`.
4. **Point-in-time negative checks:** the empty-replies check and the final `['act','act','again']` assertion each look once, so a late duplicate effect would be missed. A short settle window would catch it.
5. **Misleading failure if `env` isn't forwarded:** `effectsPath` would be undefined, but the `eventually` timeout would report it as a generic failure.

These could go into a follow-up test-hardening job if wanted; I did not post one.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1627-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177770 cached reads)
- Output: 1540 tokens
- Cost: $0.41911400000000004
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
