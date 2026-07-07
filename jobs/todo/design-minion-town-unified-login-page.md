---
role: designer
---

# minion.town: one unified, minimal login page (GitHub / Google / SIWE) + a landing page with log-out

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws` (install via `bash scripts/aws/install-aws-cli.sh` from the garden repo if absent; creds hard-linked in `$HOME/.aws`), region us-west-1. Box access SSM only (no SSH): instance `i-0380cd68b90020fad` (`aws ssm send-command`/`start-session`). **Secrets only in Secrets Manager.**

## Mandate

Replace the generic Cognito Hosted UI entry with **one custom, minimal, first-party login page** on minion.town that offers **Sign in with GitHub / Google / Ethereum (SIWE)**, and give the authenticated **landing page a Log out button that returns to that login page**. Design AND implement AND deploy live, then verify. This is the maintainer's chosen **Tier 2** (custom UI, Cognito stays the token backend — do NOT stand up a new OAuth server).

**Style: minimal. Center the form on the page.** One coherent aesthetic across the whole login experience — the login page and the SIWE thunk's wallet page (`deploy/thunks/siwe/`, already built) should look like one product.

## What exists (reuse; don't reinvent)

- **Cognito** pool `us-west-1_mDaTgjr1m`, hosted-UI domain `minion-town.auth.us-west-1.amazoncognito.com`, issuer `https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m`. Web-gate confidential client `1ado9v94gl9lpufejiekpehnli` (secret in Secrets Manager `minion/web-gate-client`). GitHub + Google IdPs are **live** (both work end-to-end today). SIWE IdP is **not deployed yet** (parked job `deploy-siwe-thunk-minion-town`).
- **oauth2-proxy** on the box (loopback :4180) behind Caddy `forward_auth`; currently `skip_provider_button = true` sends users straight to Cognito's Hosted UI. Caddy `deploy/aws/caddy/conf.d/minion-town.caddy` proxies `/oauth2/*` and gates the default route. The current default/landing route is a placeholder `respond`.
- **SIWE design + wallet page:** `designs/siwe-onchain-authz.md`, `deploy/thunks/siwe/` (portable OIDC thunk + wallet-connect page). Match its visual language.

## Design + build

1. **Unified login page (Tier 2).** A single minimal page, form centered, with three actions:
   - **GitHub / Google** → initiate the OAuth flow *pre-selecting the IdP* so Cognito's own chooser is skipped (Cognito `/oauth2/authorize?...&identity_provider=GitHub|Google`). Wire this through oauth2-proxy's **custom sign-in page** mechanism (`custom_templates_dir` / a custom sign-in template) so oauth2-proxy still owns state/PKCE/session but renders OUR page and lets each button target its provider. Work out the exact oauth2-proxy templating/params (this is the crux); document what you chose.
   - **Ethereum (SIWE)** → the same pattern with `identity_provider=SIWE` (routes to the SIWE thunk's wallet page once that thunk is deployed). Include the button now, styled; it becomes functional when `deploy-siwe-thunk-minion-town` lands — **do not block on SIWE**; degrade gracefully if the IdP isn't present yet.
   - Keep it provider-portable (mostly static markup + redirect URLs; no AWS-specific coupling in the page itself) per the loose-coupling directive.
2. **Landing page + Log out.** Replace the placeholder default route with a minimal authenticated landing page that includes a **Log out** button/link → oauth2-proxy `/oauth2/sign_out`. Configure sign-out to **return to the login page** (post-logout redirect). Decide and document whether logout should also clear the **Cognito** session (Cognito `/logout` endpoint) so the next login re-prompts rather than silently re-using the IdP session — recommended for a real "log out," and note the trade-off.
3. **Deploy + wire on the box** via SSM (render the page(s), oauth2-proxy config with `custom_templates_dir` + `skip_provider_button` as needed, Caddy routes), consistent with the existing base64→`tee`→validate→reload pattern. Commit the page(s) + config to the repo under `deploy/` so a redeploy reproduces it (no live-only drift — this repo has had drift; keep it clean).

## Constraints / guardrails
- Minimal style; centered form; one aesthetic shared with the SIWE wallet page.
- Cognito stays the backend — no new OAuth server (Tier 3 is explicitly out of scope).
- Secrets only in Secrets Manager; repo stays private.
- Don't break the working GitHub/Google login or lock out the maintainer; the break-glass admin path must survive.

## Verify + report
- Unauthenticated `https://minion.town/` → the **custom minimal centered login page** (not Cognito's Hosted UI).
- **GitHub and Google buttons complete sign-in end-to-end** to the landing page.
- Landing page shows **Log out**; clicking it ends the session and returns to the login page (and, if implemented, re-prompts at the IdP).
- SIWE button present + styled (functional pending the SIWE deploy job).
- `/mcp` with a Bearer token still works (unaffected). No config drift: box matches repo after redeploy.
- Update `DEPLOYMENT.md`. Report the oauth2-proxy custom-sign-in mechanism you used and the logout/Cognito-session decision. Screenshot not required (no browser in-container) but describe the rendered layout.
