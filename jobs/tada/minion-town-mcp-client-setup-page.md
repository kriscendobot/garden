All done. Inbox is empty, PR #6 is open against `main` with the three expected files.

## Completion report

**Job:** web-builder — an authenticated-only "Connect an MCP client" setup page on minion.town, linked from the landing page, deployed and validated live, delivered as a PR.

**What I built**
- **`deploy/aws/www/connect.html`** — a new gated page styled to match the existing login/landing/wallet aesthetic (system-ui, dark command blocks, amber gotcha callouts, blue info callout, 🌱 emoji favicon). Sections:
  - **Claude Code (CLI):** the `claude mcp add --transport http --client-id 1uesun672b9a0lidth983v0vc9 --callback-port 8080 minion-town https://minion.town/mcp` + `claude mcp login minion-town` pair, both with progressive copy buttons; the two load-bearing gotchas (`--client-id` required — no Cognito DCR; `--callback-port 8080` must match the registered `http://localhost:8080/callback`); and the remote/container note (`--no-browser` paste-back or `ssh -L 8080`).
  - **Claude.ai connector & other OAuth clients:** server URL, RFC 9728 PRM discovery, public PKCE client id, scopes, Google/GitHub/SIWE sign-in.
  - **Tool orientation:** `minion_status` / `list_minions` / `summon_minion` and the baseline-authority note.
- **`deploy/aws/www/index.html`** — added a "🔌 Connect an MCP client" primary link → `/connect.html`.
- **`DEPLOYMENT.md`** — recorded the new page and the naming constraint below.

**Key finding:** the page must **not** be named `mcp-*.html`. Caddy's `handle /mcp*` prefix matcher routes such a path *ungated* to the Express MCP app on `:3000` (verified: `/mcp-clients.html` → 404 from Express), never to the gated `file_server`. `connect.html` falls through the default gated route.

**Grounded against the live stack:** Cognito `describe-user-pool-client` (client `1uesun672b9a0lidth983v0vc9` = public PKCE `minion-mcp-cli`, callbacks + scopes + Google/GitHub/SIWE IdPs all confirmed); live PRM document; `/mcp` 401+WWW-Authenticate.

**Deployed & validated live** (deploy → validate → PR):
- Ran `deploy-www.sh`; both files are on the box at `/srv/minion-town/www/`.
- **Gating verified:** `curl -sI https://minion.town/connect.html` → `302 → /oauth2/sign_in?rd=/connect.html` (same login gate as landing).
- **On-box content verified via SSM:** deployed `connect.html` carries the client id + login command; `index.html` carries the link.
- **Rendered in headless Chromium** from the exact deployed bytes (screenshots confirm both pages render correctly and match the aesthetic; DOM assertions confirm link, commands, copy payloads, tools).
- No Caddy change required.

**Delivered:** PR #6 → `kriscendobot/minion.town` `main` (branch `feat/connect-mcp-client-page`).

**Not independently verified (honest limit):** the post-login live DOM at `https://minion.town/connect.html` through a real Cognito OAuth sign-in — the environment is non-interactive and can't complete the browser OAuth flow. Inferred from identical gate behavior to the already-working landing page, byte-identical on-box content, and the headless render of those exact bytes. Stated as such in the PR body.

**Follow-ups:** none required. A maintainer with a live session can do the final click-through post-login if desired; PR #4 (CD on push to main) is still open, so this landed via manual `deploy-www.sh`.
