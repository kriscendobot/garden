# Completion report: fix-minion-town-guest-recovery-oauth-bonding

**Both reported defects reproduced, root-caused, fixed, deployed to production, and re-verified. Draft PR: [kriscendobot/minion.town#129](https://github.com/kriscendobot/minion.town/pull/129), CI fully green.**

## What reproduced (headless Chromium against production, pre-fix)

1. **URL-based guest recovery** — create → copy URL → Forget → paste the URL: BROKEN in the natural same-tab flow (the paste is a same-document fragment navigation; `start()` never re-runs, page stays on "Start as a guest"). Worked in a fresh tab, which is why it hid in development. Evidence: screenshots + logs under `/tmp/mt-repro/evidence/`.
2. **OAuth recovery bonding** — arriving on `/#recover=1`: the page claimed "Recovery provider bonded to this guest" **even with no session and nothing bonded** (the gated POST's redirect lands on the sign-in page, HTML with status 200, which the shell counted as success), and even on genuine success the guest section was never rendered — the start page showed with the guest apparently forgotten. The bond link went to `/oauth2/start`, which never offers a provider choice (with a live Cognito session it bounces straight back).

## The fix (all frontend: `deploy/aws/www/guest.js` + `guest.html`)

- `hashchange` → reload, so a pasted guest/invitation URL is processed (replaceState paths don't fire it — no loop).
- `api()` treats a redirect into `/oauth2/*` as "sign-in required", never success — no more false "bonded" claims.
- The bond branch renders the guest first, then bonds; failure reports "Not bonded: …" with the guest still visible and stored; a dead credential (401) falls through to recovery instead of bonding a corpse.
- Both recovery links now route through the first-party chooser `/oauth2/sign_in?rd=/%23recover=1` (GitHub / Google / Ethereum, rd fragment preserved).
- Startup errors forget the stored credential only on a definitive 401, never transient failures.

## Regression test

`test/web/guest-recovery-browser.test.ts`: Playwright-driven Chromium against an express harness mimicking the Caddy+oauth2-proxy topology, including the 302→200-HTML sign-in shape. **Verified 4/4 fail on the old shell, 4/4 pass on the fix.** CI installs Chromium and runs it with `MT_E2E_REQUIRE_BROWSER=1` (fails loud, can't skip); `MT_E2E_ORIGIN=https://minion.town` runs the prod-safe subset (verified passing post-deploy). Full suite: 541 passed, typecheck clean.

## Deploy + re-validation

Standard `deploy-www.sh` over SSM at 20:43Z (maintainer-authorized). Pre-verified by sha256 that all other www files were byte-identical, so only `guest.html`/`guest.js` changed; no service, database, or guest-formula state touched. Post-deploy: caddy/minion-mcp/oauth2-proxy/endo-daemon all active, NRestarts=0, healthz 200. Prod re-run: same-tab URL recovery recovers the **same formula identifier**; the bond link lands on the chooser; a session-less `/#recover=1` arrival says "Not bonded…" with the guest intact.

## Not verifiable automatically

- The full OAuth bond/recover round-trip with a real provider needs an interactive human login (scripted up to the provider hand-off; the identical frontend paths are covered by the harness test).
- **Residual risk for a human pass:** with a live Cognito hosted-UI session, choosing a *different* provider sends `identity_provider=<other>` — if Cognito prefers its existing session, the bond would key to the old identity; the fix would be a scoped Cognito-logout hop (noted in the PR).

Side effects: a handful of inert test guests created on prod during reproduction (harmless). PR left draft for the maintainer's gauntlet, on frozen base `main-19cb5b8`; note prod runs ahead of git main for these two files until it merges.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-guest-recovery-oauth-bonding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (8615299 cached reads)
- Output: 59062 tokens
- Cost: $14.764279000000005
- Wall-clock: 1292s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
