**Viability report: kriscendobot/minion.town PR #168** ("design: clarify, list, and remove a guest's OAuth bonds")

The gauntlet may begin. I did not commit or push anything and did not touch any PR.

**PR facts:** The PR is open, a draft, and not merged. Its base is `main-d750b09` (`d750b09`), which is still the tip of `main`. Its head is `design/guest-oauth-bonds` at `de8fffd9`. It was opened 2026-10-07T22:12Z and adds one file, `designs/guest-oauth-bonds.md`. It has no comments or reviews yet.

Deciding question: Has a newer design or implementation on `main` or in another PR already explained, listed, or removed guest OAuth recovery bonds, or has the need for that gone away?

Evidence:
- **Base is current.** `main` has no commits after `d750b09`, the #165 merge from 2026-10-07T05:20Z. So nothing has landed since the design read the code.
- **The gap is still there.** A code search of the repo finds no `listBonds`, `removeBond` or `unbond` anywhere. `bondGuest` appears only in `src/auth/accounts.ts`, `src/auth/stores/dynamodb.ts`, `src/http.ts` and `test/accounts.test.ts`. That matches the PR's finding that bonds can be created and overwritten, but not listed or removed.
- **No competing design.** On `main`, `designs/` has only `account-creation-open-signup.md` that relates to accounts or recovery. It has no bond list or removal design.
- **Related open PRs complement it rather than replace it.** #114 (SIWE limited to recovery), #129 and #131 (guest-shell recovery fixes) and #133 (SIWE as a recovery-bond provider) are all older than #168. #168 cites them and builds on #114's store, and none of them covers listing or removing bonds.
- **The ask is fresh.** The maintainer prompt behind it is dated today, 2026-10-07.

The PR has not been superseded, and the need behind it still holds.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163740 cached reads)
- Output: 1416 tokens
- Cost: $0.38113199999999997
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
