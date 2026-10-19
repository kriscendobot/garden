**Gauntlet clean stage for endojs/endo-but-for-bots PR #1498 is done. Nothing needed changing and CI is green at the current head (`eb07f183cc`).**

**What I checked**
- **The change itself:** I worked in an isolated checkout of `build/daemon-locator-terminology` against its base, `llm-ca5aaef`. The code change is mostly comments and docs. The only behavior change is three error messages in `parseLocator`:
  - "Invalid node identifier" becomes "Invalid peer key".
  - "Missing formula number" becomes "Missing formula address".
  - "Invalid id." becomes "Invalid formula address".
- **Coverage:** `packages/daemon/test/locator.test.js` already tests all three new messages. The PR also adds a round-trip test with hints from several transports and a dehydrate/hydrate round-trip test.
- **Old strings:** a search of `packages/` found nothing still using the old error messages.
- **Dead code:** the PR left no orphaned code. `LOCAL_NODE` was already unused outside comments before this PR, which only rewrote its comment. Removing that exported symbol is out of scope for this stage.
- **Local tests:** `npx ava test/locator.test.js` in `packages/daemon` passed all 44 tests.

**Result**
- I pushed no follow-up commits.
- `ci-wait-merge.sh --no-merge` returned rc 0: 35 checks, 0 failed (17 passed, 18 skipped).
- The PR is still a draft.

**Follow-ups:** none from this stage. Panel review is next in the gauntlet.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1498-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (565621 cached reads)
- Output: 3199 tokens
- Cost: $0.6194402
- Wall-clock: 803s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
