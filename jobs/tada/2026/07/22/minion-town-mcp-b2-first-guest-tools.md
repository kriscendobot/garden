B2 was already merged on `main`; added its missing local PKCE validation support and refresh regression in draft PR https://github.com/kriscendobot/minion.town/pull/17 (commit `760c9ee`).

Changed:
- `dev/client.ts`: `guest` mode writes/reads guest text and supports post-restart read-only checks.
- `test/endo-guest-http.test.ts`: verifies a fresh same-identity PKCE token is accepted on the pinned session.

Validation:
- `npm run typecheck` passed.
- Focused guest suites: 15/15 passed.
- B1 temp-daemon helper integration: 3/3 passed.
- Local mock AS + app + PKCE client: wrote/read `durable-across-restart`, restarted daemon, then read the same value successfully.

Follow-up: full `npm test` still has two unrelated SIWE suites blocked by missing `viem`; 131 tests passed and 3 daemon tests skipped without `ENDO_CHECKOUT`.
