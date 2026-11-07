Viability check for kriscendobot/minion.town PR #252, "fix(home): recover guest links pasted in the open page". The PR is open, unmerged and not a draft, at head `528d4a1f`. The gauntlet can begin.

Deciding question: Does current `main` still lack any `hashchange` handling in `deploy/aws/www/home.js`, so that pasting a guest URL over the open landing page still leaves the credential unprocessed and visible, with no other PR fixing this?

Answer: yes.

Evidence:
- **Base is current:** the PR's base `5e890519` is exactly the tip of `main` (committed 2026-11-07T17:31Z), with 0 commits after it. No newer base history can have displaced the PR.
- **Problem still exists on `main`:** `home.js` has no `hashchange` listener and no reload. It checks the credential only once at startup (line 318, `fragmentHoldsCredential(location.hash)`), so a same-page fragment change is still never handled. That is the PR's stated premise.
- **Not touched since:** the last commit to `home.js` on `main` is `7c34f50d` (2026-10-25), before this PR was created on 2026-11-05.
- **No competing PR:** a search of related PRs found #129, which is open but changes the older guest shell. #252's description puts reviving that shell explicitly out of scope, so #129 is a different surface. #131 is closed and unrelated.
- **Review so far:** the PR has no closing issues and no maintainer objection. The bot jurors returned approve or comment-only verdicts. One minor should-fix: limit the reload to fragments that carry a credential.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (129782 cached reads)
- Output: 1265 tokens
- Cost: $0.43491240000000003
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
