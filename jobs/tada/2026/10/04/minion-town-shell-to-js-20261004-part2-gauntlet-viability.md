**Viability check for kriscendobot/minion.town PR #152:** proceed. The PR is open and unmerged, nothing newer replaces it, and the maintainer's request behind it still applies.

**PR facts:** draft, created 2026-10-04 18:09Z, head `8712a29291`. Its base is `chore/javascript-only-scripts-part-1-dcc2d64` (the branch of #151). It has no reviews or comments yet. It is part 2a of a three-part stack:
- #151 (part 1): policy, guard and `lib/common.js`. Open, draft.
- #152 (this PR, part 2a): ports the 14 host-run provisioning scripts.
- #153 (part 2b): the CD-path scripts, stacked on #152's head. Open, draft.

**Deciding question:** Does main still carry the 14 provisioning `.sh` scripts that #152 ports, with no other merged or open work already converting them to JavaScript?

**Evidence:**
- **The request still stands.** On #150, kriskowal approved with "@kriscendobot please post a follow up to convert shell scripts to JavaScript and use JavaScript for all Minion Town scripts going forward". The #151→#152→#153 stack is that follow-up. Nothing since then withdraws or changes the request.
- **The work isn't done on main yet.** Main's latest commit is `a378bb3dd` (2026-10-04 15:39Z, merge of #148). Its `deploy/aws/scripts/` still has every one of the 14 `.sh` files #152 targets, from `deploy-account-endpoint-secret.sh` through `set-account-role.sh`. The only `.mjs` script there is the unrelated `deploy-cd-iam.mjs`.
- **No competing PR.** A title search for "javascript" finds only #151, #152 and #153, all open and all one series.
- **Watch the merge order.** #152 targets the part-1 branch, so it should land after #151. That affects sequencing, not whether the PR is still needed.

I didn't spend any clean, panel, fix or CI budget, and I made no changes to the repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162313 cached reads)
- Output: 1594 tokens
- Cost: $0.40716660000000005
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
