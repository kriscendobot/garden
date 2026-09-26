All work is complete and verified. Final state confirmed: PR #670 open and non-draft, base `llm-05ed3ac`, head `9c120d7b5e`, 23/23 CI green, kriskowal review re-requested, summary comment posted, narrative refreshed. The garden skill fix is pushed to main2 (`f52a2d7267`).

---

## Completion report: refresh endojs/endo-but-for-bots PR #670

**Both dimensions of the CHANGES_REQUESTED review addressed: mechanical re-sync AND substantive re-validation.**

### Part 1 — Mechanical refresh (done)
- Pushed new frozen base `llm-05ed3ac` (from `origin/llm` tip `05ed3ac`, 40 commits ahead of the old `llm-08f5acc`).
- Rebased head onto it: **clean, zero conflicts** (`91d601a095`). Moved PR base to `llm-05ed3ac`, force-pushed head.
- Regenerated derived artifacts against the new base: `yarn install` produced **no lockfile churn** and `yarn build:types:gen` produced **no composite-tsconfig drift**, so the PR's existing `chore: Update yarn.lock` / `chore(lal): regenerate composite tsconfigs` commits are still current. No new chore commit needed (drift check: "All composite tsconfig files are up to date").

### Part 2 — Substantive re-validation (done)
- **Validated against the deployed minion.town OAuth MCP.** Read the live server's published OAuth metadata (RFC 9728 protected-resource doc + the Amazon Cognito OIDC discovery it names, fetched read-only). The implemented authorization-code+PKCE-S256 flow, urlencoded token-exchange body (`grant_type`/`code`/`client_id`/`redirect_uri`/`code_verifier`, no secret), and refresh carry-forward (Cognito does not rotate refresh tokens) **match the server contract byte for byte** — no flow change required.
- Because it matched, added a **verified preset**: new `packages/lal/providers/oauth/presets.js` (`makeMinionTownMcpOAuthConfig`: Cognito authorize/token endpoints, public PKCE client id, published `mcp/*` scopes, two registered redirect URIs), exported from `index.js`, plus `test/oauth-presets.test.js` (7 tests pinning the flow's request shapes to that contract). Committed `9c120d7b5e`. Pure flow modules kept constant-free; presets are the one constants home.
- **Honest scope note:** did NOT claim a live end-to-end token grant (needs interactive consent a non-interactive worker cannot drive) — validation is against the server's published metadata/contract, stated as such in the PR.
- **agentry/agent-tools consolidation:** checked — it touches git-history tooling and the agent harness, not provider auth, and exposes no shared auth/token/provider-registry surface to consume. Nothing to wire; invented no integration.
- **Framing surfaced, not silently redesigned:** minion.town is an MCP resource server (authenticate *to*) vs. the subscription providers (authenticate *against*); treated its preset as a validated integration preset and left the ocap-behind-the-tool-call credential-scoping direction to a designer if the maintainer wants it to reshape the store.

### Verification (real execution)
- `yarn workspace @endo/lal test`: **86 passed, 1 skipped** (52 across `oauth-*.test.js`, +7 new preset tests). Ran locally, observed the results.
- `eslint` clean, `prettier --check` clean, `tsc` clean on new files (only pre-existing environmental `undici-types` / MCP-sdk `node_modules` errors remain).
- CI on `9c120d7b5e`: **23/23 checks SUCCESS**.

### Close-out (done)
- PR body Modules / Validated-integration / Out-of-scope / Follow-ups / Verification sections refreshed.
- Top-level summary comment posted addressing @kriskowal's review (which had no inline threads) — [#issuecomment-4963662505](https://github.com/endojs/endo-but-for-bots/pull/670#issuecomment-4963662505).
- Review re-requested from `kriskowal` after CI went green. PR kept non-draft; not merged.

### Follow-ups
- Subscription-provider presets (Claude / ChatGPT / Copilot) remain follow-ups — each needs its own registered OAuth client id this PR does not mint. Noted in the PR.
- Wiring a minion.town/subscription bearer token into the provider registry waits on the registry refactor (design phase 1).

**Self-improvement:** landed `docs(frozen-base-branch)` fix to main2 (`f52a2d7267`) — the skill's Rebase step told me to `git rebase "$NEW_FROZEN_BASE"`, but that local ref doesn't exist after only pushing the remote branch (fails "invalid upstream"); corrected to rebase onto `origin/<base>` (identical commit).
