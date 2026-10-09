Panel round 5 on kriscendobot/minion.town PR #166 came back **must-fix**. The verdict is posted to the PR.

**Run:**
- I made a separate checkout of `feat/prod-objectives-probe` for this job, at head `9572abfd`.
- I ran `panel.sh` in single-round mode against the PR's base commit `50aa690` (`main-50aa690`). It exited 0 with disposition `must-fix`.
- All 34 seats returned ok: 1 request-changes (spec-keeper), 17 comment-only and 16 approve.
- The panel flagged that the two previous rounds both raised must-fix findings on `prod-objectives.mjs`. So it also asked the decomplector seat whether that code needs to exist at all.

**Must-fix items (all from spec-keeper):**
1. `deploy/probe/prod-objectives.mjs:171-176` compares the cross-origin isolation headers (COOP, COEP, CORP and `Origin-Agent-Cluster`) without regard to case. Browsers match those values case-sensitively. So a value like `Require-Corp` passes the probe but gives no isolation in a browser.
2. The "narrow" CSP exemption only holds while the gateway's minimum required `default-src` is `'self'`. That value is now imported from the gateway and could change.
3. The probe imports `.ts` files directly, which needs Node 22.18 or later. `package.json` `engines` still allows `>=22.15.0`.

**Comment-only (decomplector):** most of the hardening in earlier rounds went into the code that interprets CSP and Cache-Control values. Requiring the served headers to exactly match the declared values would be simpler. The tests in `test/gateway/` already check that offline.

**Posting:** GitHub refuses a request-changes review on the bot's own PR. So the verdict went up as a COMMENTED review on commit `9572abfd`, as in rounds 2–4: https://github.com/kriscendobot/minion.town/pull/166#pullrequestreview-5467593059. The review is 62,988 characters, with the panel output cut at a seat boundary to fit GitHub's size limit.

No fixes were made and the PR is still a draft; fixing is the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (684898 cached reads)
- Output: 4727 tokens
- Cost: $0.6755035999999998
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
