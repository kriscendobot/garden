I ran panel round 1 on kriscendobot/minion.town PR #122 ("fix(security): bind Claude pin to signed manifest") and posted the result: the verdict is **must-fix**.

**Run**
- I reviewed an isolated checkout of `kriscendobot:fix-minion-town-claude-harness-supply-chain-hardening` at head `8f60883`.
- The base was the PR's own base commit, `d750b09` (`main-d750b09`).
- `panel.sh` ran in single-round mode with `GARDEN_YARN=npm`. All 33 seats returned ok and the run recorded `exit_code=0` and `disposition=must-fix`. The durable record is `panel-runs/kriscendobot-minion.town-122/44e4fa35e3c0.md`.

**Review posted**
- The review is on https://github.com/kriscendobot/minion.town/pull/122 at 2026-10-08T04:43:47Z.
- It posted as a comment (state COMMENTED), not a request-changes review. GitHub refuses "request changes" on the bot's own PR, so the comment form is the fallback.
- The full aggregate is 81 KB, over GitHub's body limit. The posted review opens with a summary, then shows the five request-changes seats' blocks in full, then as many other seats as fit. The 11 seats that did not fit are named in the review and point to the durable record.

**Blocking finding**
- In `deploy/aws/scripts/deploy-app.sh`, `NODE_SHA256` is read from the downloaded `SHASUMS256.txt` and pasted into the remote script that runs with `sudo`, with no format check.
- It should be checked against `^[0-9a-f]{64}$` first, the way `CLAUDE_VERSION` already is.
- The locksmith seat marked this must-fix, and the wire-watcher and purist seats raised it too.

**Should-fix**
- The deploy path never checks the signed manifest. The check runs only in CI, and the deploy workflow doesn't depend on CI.
- A comment in `refresh.mjs` claims an older valid release can't be swapped back in, but nothing enforces that.
- The gpg verification is duplicated between `check.mjs` and `refresh.mjs`, and the two copies have already drifted apart.
- No tests cover a bad signature, and both platforms use identical test fixtures, so a swapped architecture would go unnoticed.
- The commits mix unrelated changes: the Node checksum fix is bundled into the Claude-pin commit.

I did no fixing or un-drafting, and nothing changed in the garden repo. The next step is the fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (916288 cached reads)
- Output: 5998 tokens
- Cost: $0.8756416
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
