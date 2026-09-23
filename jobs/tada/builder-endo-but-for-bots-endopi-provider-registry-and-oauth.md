PR #672 is confirmed as a draft against the frozen base `llm-08f5acc`. Inbox is empty. The build is complete.

## Completion report

**Job:** Build the subscription-OAuth slice of the `endopi-provider-registry-and-oauth` design (Phases 3–4) by wiring pi-ai's OAuth scaffolding through Genie, deferring the Lal-vs-Genie consolidation.

**Delivered:** Draft PR **[#672](https://github.com/endojs/endo-but-for-bots/pull/672)** on `endojs/endo-but-for-bots`, base `llm-08f5acc` (frozen), head `feat/genie-subscription-oauth`. Affected package: **`@endo/genie`**.

**What I did**
- Confirmed base-branch inference: `packages/genie` exists only on `llm`, so the PR is `llm`-based (reused the existing `llm-08f5acc` frozen base, which matches the worktree checkout SHA).
- New `packages/genie/src/agent/oauth.js` — the missing seam over `@earendil-works/pi-ai/oauth`: `loginOAuthProvider` (run flow, persist), `makeApiKeyResolver` (the `getApiKey` callback: OAuth token → refresh/re-persist on expiry → env-key fallback), `applyOAuthModelModifications` (Copilot base-URL rewrite), `makeMemoryOAuthStore` reference store, and the injected `OAuthStore` interface. pi-ai handles the provider-specific request shape (Anthropic OAuth headers, Copilot bearer) once handed a token.
- Wired `makePiAgent` (new `oauthStore` option, installs the resolver, applies model rewrites; ollama keeps its sentinel key) and threaded `oauthStore` through `makeGenieAgents` → main, heartbeat, observer, reflector. Exported the surface from `src/index.js`. Documented it in `DESIGN.md`.
- 16 new tests in `test/agent/oauth.test.js`, all passing (memory store, provider recognition, OAuth/env precedence, refresh-and-persist, login-and-persist via faux registered providers, model rewrite, and a `makePiAgent` integration check).

**Verification**
- New tests: 16/16 pass under `ava-endo-lockdown`. Existing `loop/agents` + `observer` + `reflector` suites: 82/82 pass (no regression from the threading).
- Typecheck: **zero new errors** in touched files (base tree 86 → 84; the one remaining `agent/index.js` error is a pre-existing exhaustiveness issue in untouched code, line-shifted).
- eslint: 0 errors (warnings are pre-existing `jsdoc/reject-any-type` / `safe-await-separator` styles consistent with the package). No `yarn.lock` change (no new deps — pi-ai and its `/oauth` subpath were already dependencies). No changeset (`@endo/genie` is private, matching repo convention).
- No banner-rule comments; inline `import()` JSDoc converted to `@import`; DESIGN.md addition in sentence-per-line shape (pre-push gates respected).

**Deferred to the design's Open Questions (not resolved in code), per the job framing:** the encrypted formula-graph-backed store, the interactive `/login` UX, and the Lal-vs-Genie consolidation.

**Heads-up for the panel/maintainer:** An open PR **#670 (`feat/lal-subscription-oauth`)** implements the *same design phase from scratch under `packages/lal/providers/oauth/`*. This PR is its Genie-side counterpart (reusing pi-ai's existing stack, the path the design's §Status calls the "genuinely missing" enablement). The two touch **disjoint files** and are the two sides of the deferred Lal-vs-Genie consolidation question — not a blocking duplicate. I framed the relationship prominently in the PR body so the maintainer can make the consolidation call. The draft PR is open and ready for the gauntlet (panel → fix-loop → un-draft).
