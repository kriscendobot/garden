I opened draft PR [kriscendobot/minion.town#143](https://github.com/kriscendobot/minion.town/pull/143). It makes the clip gutter the signed-in landing page and fills it with the user's real published clips. CI is green (`test` plus both Claude harness legs). It isn't deployed yet: the PR is still a draft, so I couldn't do the live check over SSM that the job asks for after merge.

**One change from the job text:** `/` is no longer `index.html`. On `main` (commit 7bfd379) and on the live site, `/` serves the public, ungated guest page (`guest.html`). The OAuth guest recovery flow depends on that (`rd=/#recover=1`). Putting the gated shell at `/` would either lock guests out or send recovering guests (who already have a session cookie) away from `guest.html`. So:
- The shell is the gated signed-in landing at `/index.html`.
- `guest.html` gets a "Signed in? Open your clips" link to it.
- The PR body asks the maintainer whether `/` itself should send signed-in sessions to the shell.

**What changed:**
- **Landing page:** `shell.html` became `index.html`, replacing the old landing. The shell's bottom-left menu already had everything the old page had (sign-in/out, account and role, guest formula id and locator, billing, the `connect.html` link), so nothing is lost. `shell.html` is now a script-free redirect to `/index.html` for old links. `connect.html`'s back link now goes to `/index.html`.
- **Real clips:** a new gated endpoint, `GET /account/clips` in `src/auth/guest-self-endpoint.ts` and wired in `src/http.ts`, returns the caller's own clips. It's the same data as the MCP `listSites` tool, looked up by the same owner key, and uses the same access checks as `/account/guest-formula-id`. It takes no owner parameter, returns 404 when clip publishing isn't configured and 503 when the daemon is down. It's routed in Caddy through the existing `@guestSelf` matcher.
- **Gutter:** `shell.js` now loads the gutter from that endpoint. The localStorage placeholder clips are gone. The "+" button shows an inert card explaining that an agent publishes clips with the MCP `publish` tool; it no longer creates anything.
- **Clips stay inert:** the per-clip isolation rules aren't loosened (design Open question #1 is still for the maintainer), and the PR body says so. Each clip shows as an inert, empty-sandbox card naming its `https://<id>.ocap.site/` address. That address is always rebuilt from the clip's id; the server's `url` field is ignored. An "Open in new tab ↗" link sits in the shell's own top-level chrome, not inside the frame. The Caddy anti-framing headers, the frame-bust script and `isolation-headers.ts` are unchanged.
- **Docs and tests:** updated `DEPLOYMENT.md` and marked the "`/` is untouched" line in `designs/clip-shell-framework.md` as superseded. Added tests for the endpoint (owner key, access checks, 404/503) and for turning the listing into gutter entries; the placeholder tests are removed.

**Checks:** typecheck is clean, and the three affected test files pass (54 tests). In the full local run, one test fails: `test/git-remote/capability.test.ts > propagates a git failure`. That code isn't touched here and the same test passes in CI, so I left it alone.

I posted a link to #143 on #90 (https://github.com/kriscendobot/minion.town/pull/90#issuecomment-5904151589).

**Follow-ups:**
- The review gauntlet and the merge for #143.
- After merge, CD deploys Caddy, the app and www. Someone then needs to check over SSM that `/srv/minion-town/www/index.html` matches the merged file and that `/index.html` and `/account/clips` are served.
- The maintainer's answers on how `/` should route and on Open question #1.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-gutter-default-landing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3387574 cached reads)
- Output: 30812 tokens
- Cost: $2.2547948
- Wall-clock: 632s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
