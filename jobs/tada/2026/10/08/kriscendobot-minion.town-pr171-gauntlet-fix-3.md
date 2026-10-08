I applied all four must-fix items from panel round 3 on kriscendobot/minion.town#171. The fix is pushed as `e49f49f` and CI is green (3 of 3 checks). The probe's unit tests pass locally (25 of 25); I did not re-run the repo's full `npm test` suite locally.

**What I did, per must-fix item:**
1. **Title (integrator):** retitled the PR to "feat(probe): validate the pinned Claude harness in production". The old title promised more than the PR validates.
2. **Deferred status with no expiry:** I took the panel's minimum option and removed the `claude-stdio-mcp-confinement` check. That also removed:
   - the root-bearer helper (`readRootCanaryBearer`) and the session helper added for it (`withBearerSession`, `toolPayload`);
   - the `deferred` status everywhere it appeared (`runCheck`, the summary, the run notice, the workflow comment);
   - the matching tests.

   The confinement objective is now tracked on kriscendobot/garden#89 until #167 is decided. I posted a note there, including the panel's point that the probe should get a limited status-read credential, not full root.
3. **Reusing the deploy role (decomplector):** I opened **kriscendobot/minion.town#172** for the proper fix: a probe-only role that can run only one fixed SSM command document. DEPLOYMENT.md and the PR body now record the current setup as accepted residual risk, linked to #172. I did not harden the workflow further.
4. **Concision cuts (pruner):**
   - removed the DEPLOYMENT.md paragraph that restated #167's open questions;
   - removed the PR body's deferred-check narrative and inline test tallies, and replaced them with a short "Not in this PR" section.

Removing the check also makes two non-blocking items moot: the "DEFERRED" padding issue and the root bearer being sent inside the job that runs `npm ci`.

**Follow-ups (not done):**
- The other non-blocking items are still open:
  - `DISABLE_UPDATES` is checked on the service, not on the `claude` process it spawns;
  - the service environment could point at a different binary (`ENDO_CLAUDE_BINARY`);
  - the GitHub Actions in the credential job are not pinned to commit SHAs;
  - `expectedHarness` duplicates the existing release validator;
  - the SSM wait gives up before the on-box program can finish;
  - the SSM transport is untested;
  - the commits need squashing before un-draft.
- I posted a summary comment on the PR. To post it I had to set `GARDEN_ALLOW_BARE_ISSUE_REF=1` (the bare #167 and #172 are meant to link within minion.town).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr171-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2200942 cached reads)
- Output: 12173 tokens
- Cost: $1.3859763999999997
- Wall-clock: 452s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
