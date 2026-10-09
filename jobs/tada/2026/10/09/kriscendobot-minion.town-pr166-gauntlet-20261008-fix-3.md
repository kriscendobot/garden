I applied the round-3 must-fixes on PR #166 and pushed them as `525596d`. CI on that head is green: `test (typecheck + vitest)` passed, and it is the same single check that ran on the previous head.

**Must-fixes applied:**
1. **Wrong file in DEPLOYMENT.md:** the `clip-content-addressed-hard-cache` row now points to `IMMUTABLE_CACHE` in `src/endo/gateway/cache-policy.ts`. I also removed the note saying a unit test keeps the probe's own copy of the isolation floor in sync, since the probe now imports the gateway's constants directly.
2. **Old evidence in the PR body:** the Evidence section now opens with a run at head `525596d` on 2026-10-09 against production, without the credential. The 5 checks that don't need a credential passed, the 2 that do were skipped, the overall result was `incomplete`, and the unit tests pass 20/20. The full 7/7 credentialed run at `501b1e1` is still listed, but marked as older than the later fix commits and not re-run. This host can't reach the secret, so the first strict scheduled run after merge will re-check those two.
3. **Concision:**
   - Removed the doc comments that only restated signatures (`HARD_CACHE_MAX_AGE`, `websocketAccept`, `exitStatus`, `overallStatus`, `tableCell`).
   - Skip, credential and exit rules are now written once, in the header of `deploy/probe/prod-objectives.mjs`. The workflow header and DEPLOYMENT.md point there.
   - Removed the step-by-step implementation description from DEPLOYMENT.md.
   - Shortened the PR body's "What it adds" file list to one sentence.

   One security note was in a paragraph I removed: setting `MINION_PROBE_BASE` or `MINION_PROBE_TOKEN_URL` changes where the token and secret are sent. It now lives in the script header.

**Should-fix item also done:** the PR body now says the two `MINION_PROBE_CLIENT_CREDENTIALS_*` secrets must exist before merge.

**Problems along the way:**
- `ci-wait-merge.sh` couldn't use `gh pr view` on this host: every check failed and it kept retrying. This is the known limit of this host's bot token, which can't read check status. I stopped it and read the GitHub Actions runs for the head commit directly instead.
- My closing inbox check timed out, so I didn't see any messages that may have arrived.

**Not done:** the non-blocking items from wire-watcher (a 304 test with a wrong `If-None-Match`, and fetching the `resource_metadata` URL taken from the challenge), assessor (quoted `max-age`) and scribe (formatting).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1489439 cached reads)
- Output: 10744 tokens
- Cost: $1.0379277999999998
- Wall-clock: 1964s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
