PR kriscendobot/minion.town#143 ("make the clip gutter the signed-in landing, listing real clips") is now out of draft: `gh pr view` shows `isDraft:false, state:OPEN`.

**What I did:**
1. **Idempotence check:** the PR was still a draft and open, so this stage had real work to do.
2. **Advisory appellate pass:** I ran a light `claude -p` (sonnet) review over the full diff (2,564 lines). It is advisory only and did not block the un-draft. It confirmed the auth ordering and the guard against reading another owner's clips (a spoofed `?owner=` is ignored) on the new `/account/clips` endpoint. It raised these items the panel may have missed, for later triage:
   - **Log out needs JavaScript:** the Log out and Connect-an-MCP-client links now sit inside `#overlay`, which ships `hidden` and is only shown by `shell.js`. Before, they were plain links that always rendered. If the script fails, a signed-in user has no way to log out.
   - **Greeting fallback dropped:** the "…You are signed in." text in `#who` now ships empty and hidden, so users without JavaScript see nothing there.
   - **Caddy routing unconfirmed:** the diff only adds `/account/clips` to the `@guestSelf` auth-gate matcher. Nobody has checked that the `/account/*` proxy rule actually forwards this path; the tests call the Express app directly and skip Caddy.
   - **Two deploy scripts now required:** a shell change needs both `deploy-caddy.sh` and `deploy-www.sh`. Running only one would leave the new route and the new files out of step.
   - **Owner key unchecked against MCP:** `identityKey(issuer, subject)` in `/account/clips` is not tested to match the key the MCP `listSites` tool uses. If they differ, the list could show another owner's clips or always come back empty.
   - **`shell.html` safety is now implicit:** the stub lost its own frame-bust script. It is safe only because the same gated Caddy block serves it; there is no routing test to keep it that way.
   - **Old links lose their state:** `/shell.html?...` bookmarks now redirect to a generic `/index.html` and drop the query string.
   - **New `serving` field:** `/account/clips` now shows the gateway's serving status to the browser. Minor, but it is new exposure.
3. **Un-draft:** ran `gh pr ready`, which succeeded.

**Follow-ups:** none were posted. The Log out regression and the unconfirmed Caddy routing are the two worth a fixer job if the maintainer agrees.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-gutter-default-landing-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (166236 cached reads)
- Output: 1645 tokens
- Cost: $0.3966432
- Wall-clock: 146s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
