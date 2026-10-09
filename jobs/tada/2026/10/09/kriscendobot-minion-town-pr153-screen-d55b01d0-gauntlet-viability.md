**Viability check: kriscendobot/minion.town PR #153** ("chore: convert CD-path deploy scripts to JavaScript", part 2b of the JavaScript-only script migration)

I made no code changes, ran no clean, panel, fix or CI-wait stage, and left the PR in draft.

**PR facts:** The PR is open and unmerged. Its head is `d55b01d0` and its base is the frozen `chore/javascript-only-scripts-part-2a-1de8101`, which is #152's branch. Merge order is #151 → #152 → #153 → #154.

**Deciding question:** Does `main` still ship the CD-path deploy scripts as shell files that this PR converts to Node ESM, with no newer PR or commit already doing that conversion?

Yes, so both claims hold:
- **Not superseded:** no other PR does this conversion. Part 3 (#154) is stacked on #153, so it depends on this PR rather than replacing it.
- **The motivating need still holds:** the shell files are still on `main`, and the request behind the migration still stands.

**Evidence:**
- `main` still contains `deploy-caddy.sh`, `deploy-www.sh`, `deploy-endo-gateway.sh`, `deploy-git-remote.sh`, `deploy-oauth2-proxy.sh`, `deploy-clip-dns.sh` and `deploy-endo-federation.sh` in `deploy/aws/scripts/`. These are the files this PR converts and deletes.
- The migration comes from kriskowal's review on #150 (merged 2026-10-04). Its other parts are all still open drafts: #151 (part 1), #152 (part 2a) and #154 (part 3).
- The PR has no discussion or reviews that withdraw the premise.
- Two earlier gauntlets stopped for operational reasons, not because the PR's purpose went away:
  - **2026-10-08:** parked because GitHub Actions billing refused to start CI jobs.
  - **2026-10-09:** halted after the fix-1 stage failed with an unknown cause and used up its retries.
- CI on the current head is green.

**Follow-ups:**
- If the gauntlet's fix stage fails the same way again, the maintainer needs to look at why it failed rather than just retrying it.
- The PR description reports one `vitest` failure that is also present on #152: `test/git-remote/capability.test.ts` "propagates a git failure".

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr153-screen-d55b01d0-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176042 cached reads)
- Output: 1599 tokens
- Cost: $0.4240363999999999
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
