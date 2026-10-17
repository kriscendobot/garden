**Undraft stage report: kriscendobot/minion.town#196**

I un-drafted the PR. It is now ready for review at head `82eb588576527b2f3fdee9d2947795b7792c1705`, the head the panel passed. No garden files changed.

1. **Appellate pass (advisory only, did not gate the un-draft):** I ran a Sonnet `claude -p` review of the head commit's diff. The GitHub API was rate-limited at the time, so I pulled the diff with git instead.
   - **Bearer leak on a non-JSON body: not a real issue.** The review flagged that the bearer could leak through `parseJsonBody` when the response isn't JSON. I read the function: its error reports only the body length, never the body text.
   - **Stale comment (low):** the comment in the probe script about `MINION_PROBE_BASE` and `MINION_PROBE_TOKEN_URL` redirects doesn't mention that the guest bearer is now sent to the base URL too. A possible hardening is to refuse to send the bearer unless the base URL is the production origin.
   - **Rotation note (low):** a rotated-out bearer stays valid forever, because there is no route to delete a guest. `DEPLOYMENT.md` could say so, and could add a step to deprecate the old Secrets Manager version.
   - **Test gaps (low):** no test covers a non-200 response (such as a 401), a bearer that appears JSON-escaped in the body, or the case where the bearer must not leak from a non-JSON body.
2. **Before un-drafting:** I waited about 4 minutes in the foreground for the GitHub rate limit to reset, then fetched the PR metadata. It showed `state=OPEN`, `isDraft=true`, and the head matched.
3. **Un-draft:** `gh pr ready` succeeded.
4. **After un-drafting:** a fresh fetch shows `isDraft=false` and the head still equals `82eb5885…`.

**Follow-ups (optional):** the three low items above could go into a small follow-up commit on the probe. None of them blocks this PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr196-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (403808 cached reads)
- Output: 2736 tokens
- Cost: $0.5051216000000001
- Wall-clock: 319s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
