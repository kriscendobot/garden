The work is complete and verified in CI. Here is my completion report.

---

## Completion report — `minion-town-browser-e2e-testing`

**Delivered:** the project's first browser end-to-end testing capability for kriscendobot/minion.town, as **PR #58** (draft, both CI checks green).

### What I did
Surveyed the three web-facing surfaces and found the app serves no HTML locally, the mock AS auto-approves with no login UI, and there's no local Caddy/oauth2-proxy/Cognito stand-in. That drove a clean CI-safe-vs-manual split. Built a Playwright (Chromium) suite under `e2e/`, **13 tests, all passing locally and in GitHub Actions**:

- **`static-pages.e2e.ts`** — `deploy/aws/www/{index,connect}.html` served on loopback: rendering, the progressive-enhancement JS (copy buttons; `/account`, `/billing`, `/oauth2/userinfo` panels stubbed via `page.route`), and the JavaScript-optional fallback.
- **`login-page.e2e.ts`** — the first-party `sign_in.html` markup contract per `designs/unified-login-page.md` § 2 (three IdP buttons each `GET /oauth2/start` with the allowlisted `identity_provider`, hidden `rd`, error-banner conditional, fragment-preservation script), via a small Go-template double that throws if the template gains unhandled syntax.
- **`weblet-serving.e2e.ts`** — the real gateway booted in-process; Chromium loads a `<hash>.ocap.site` origin (via `--host-resolver-rules=MAP *.ocap.site 127.0.0.1`) and confirms it renders, carries the isolation-header floor, sets no auth cookie, and 404s a dead label. **This is the surface unit tests structurally cannot cover.**

### What changed
- New: `e2e/` (3 specs + 3 helpers + README), `playwright.config.ts`, `designs/browser-e2e-testing.md`, `.github/workflows/e2e.yml` (a `browser-e2e` job separate from `test.yml`).
- Modified: `package.json` (+`@playwright/test`, `e2e`/`e2e:install` scripts), `package-lock.json` (lockfile synced — verified `npm ci`-clean by the passing `test` job), `vitest.config.ts` (exclude `e2e/**`), `.gitignore` (Playwright artifacts).

### Verification
- Local: `npm run typecheck` ✓, `npm run e2e` ✓ (13/13).
- CI (GitHub Actions): `browser-e2e` **pass** (50s), `test` **pass** (36s).

### Scope boundary (documented, not wired to CI)
The federated Cognito sign-in (real GitHub/Google/SIWE) and the deployed weblet DNS/TLS edge have no local stand-in and are a manual/staging checklist in `e2e/README.md`, per the job's "use judgment on CI-safe vs manual" guidance.

### Follow-ups (scoped in the design doc § 4, not yet posted as jobs)
1. Federated-login staging suite (needs a maintainer decision on the test-IdP approach + a staging URL).
2. Deployed weblet-edge smoke (real `*.ocap.site` DNS + TLS).
3. Live MCP-connect e2e (`weblet_publish` with `WEBLET_SITES_LIVE=1` + a live Endo daemon).

PR #58 is left **draft** with green CI — ready for review / the gauntlet at the maintainer's discretion (I did not merge; that's a maintainer-authorized step).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-browser-e2e-testing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 111 tokens (6215411 cached reads)
- Output: 51855 tokens
- Cost: $6.847551000000002
- Wall-clock: 788s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
