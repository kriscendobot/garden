---
role: web-builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-11T09:08:39Z -->

# Build: styled privilege surfaces for minion.town (Phase C — role-aware landing, error page, insufficient-privilege page)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1. Requires Phases A+B (`build-account-store-minion-town`, `open-signup-gate-flip-minion-town`) live for end-to-end verification.

Implement Phase C of `designs/account-creation-open-signup.md` (§ 6, § 9) — web-frontend work, one aesthetic shared with the existing login/landing/SIWE pages (inline CSS, system-ui, #1a1a1a on white, 22rem centered column, 🌱 favicon):

1. Landing page (`deploy/aws/www/index.html`): role panel from one `fetch("/account")` — current role, what it allows in plain words, and the elevation line. Progressive: static text stands if the fetch fails.
2. `error.html` template beside `sign_in.html` in `custom_templates_dir`: styled replacement for oauth2-proxy's built-in 403/500 fallback, with a back-to-sign-in action.
3. App-served styled insufficient-privilege (403) page for gated routes above the caller's role: signed-in identity, current role, required role, elevation line. (MCP tool-level `insufficient_scope` errors stay machine-readable — untouched.)
4. `ELEVATION_CONTACT` config value rendered into surfaces 1 and 3.

Verification: **actual browser run required** (roles/COMMON.md § Reporting) — rendered-DOM observation of the landing role panel as a visitor and of the error page; no bare oauth2-proxy 403/500 reachable on the golden paths.

**Maintainer decision this promotion implies:** the `ELEVATION_CONTACT` value (mailto, issue URL, or plain text — design open question 4).

<!-- garden-reaped: 1 -->
