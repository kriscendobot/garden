---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Stand up browser-based automated (Playwright) end-to-end testing for
kriscendobot/minion.town. Today there is no browser/e2e testing at all —
only vitest unit/integration tests (`npm test`) and typecheck.

**Scope the first increment around the real web-facing surfaces:**
- `deploy/aws/www/index.html` and `deploy/aws/www/connect.html` (the MCP
  connect/OAuth entry point — the exact page a human clicks through today
  to authorize a new MCP session).
- The Cognito-hosted OAuth flow itself: sign-in, consent, redirect back
  to the callback with a code — at least the parts that can run against a
  real deployed environment or a realistic local/staging stand-in without
  needing a live human GitHub/Google account each CI run. Use judgment on
  how to make this credential-free/deterministic for CI (a dedicated test
  IdP user, a Cognito test user with password auth, or scoping browser
  tests to what doesn't require a real federated login and leaving the
  federated-login path to manual/exploratory testing).
- Weblet serving: publish a weblet (via the MCP tools or existing
  fixtures) and load its `<hash>.ocap.site` origin in a real browser,
  confirming it actually renders — this is the one surface that unit
  tests structurally cannot cover (real DNS/TLS/serving behavior).
- `designs/unified-login-page.md` describes the intended login surface;
  read it for what "correct" looks like before writing assertions.

Wire it into CI (`.github/workflows/`) as its own job/step alongside the
existing `test (typecheck + vitest)` workflow, not blocking on flaky
external dependencies (network to real IdPs, etc.) — use judgment on
what's CI-safe versus a documented manual/staging-only suite.

Note: this is a genuinely new testing capability being added to the
project, not a fix — expect a design-then-build shape if the scope turns
out to be larger than one increment can safely land.
