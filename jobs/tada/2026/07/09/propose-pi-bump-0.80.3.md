The work is complete. PR #649 is open (not draft), inbox is empty. Let me write the completion report.

---

## Completion report: `propose-pi-bump-0.80.3`

**Outcome:** Opened **[endojs/endo-but-for-bots#649](https://github.com/endojs/endo-but-for-bots/pull/649)** (base `llm`, branch `build/pi-0.80.3-migration`) — the code-migration half of the `@earendil-works/pi-*` 0.79.9 → 0.80.3 move, verified green. Pushed directly to `endojs/endo-but-for-bots` (bot has write access; that's how all prior garden PRs on this repo work — there is no `kriscendobot` fork of it).

**What I did**
- **Verified the API surface against the published 0.80.3 tarballs** rather than trusting the job's description. Confirmed at runtime that `getModel` is `undefined` on the pi-ai root but a function on `/compat` — proving the breakage is real and the repoint fixes it.
- **Version bumps** `^0.79.0` → `^0.80.3` for `pi-agent-core` + `pi-ai` in agent-tools, agentry, genie, lal package.json; refreshed `yarn.lock` (pi-only churn, both resolve to 0.80.3).
- **Repointed value imports of the moved global-registry API to `@earendil-works/pi-ai/compat`** (`getModel`, `getProviders`, `registerBuiltInApiProviders`, `registerFauxProvider`) across 9 sites in agentry + genie, plus one I found only via test execution that static grep missed: the **generated faux-provider script** in `genie/test/dev-repl-sandbox.test.js` (its `PI_AI_URL` now resolves the `/compat` subpath). `/compat` is a strict superset, so co-imported root names (`fauxAssistantMessage`/`fauxToolCall`) still resolve.
- **Audited the other 0.80.x breaks — none applied:** `ExecutionEnvExecOptions`→`ShellExecOptions` not referenced; no `ApiKeyCredential` constructed directly (so the `type:"api_key"` change is moot); no `/base` entrypoint imports; `Agent` and all type-only imports still root-exported; `createAssistantMessageEventStream` (lal) stays on root, untouched.
- **Cross-linked from dependabot #607** so its mechanical pi bump isn't merged without this migration.

**Verification (real execution, sandbox-disabled, deps installed from registry at 0.80.3)**
- agent-tools: **91 passed**
- agentry: **69 passed** (exercises `getModel` + faux-provider through `/compat`)
- lal: **34 passed, 1 skipped** (live `LAL_HOST` test)
- genie: **446 passed** across lockdown/unsafe/endo configs (only `bwrap`-unavailable sandbox tests skip — environmental)
- `tsc`: agentry & agent-tools **0 errors**; lal's 12 errors are all pre-existing third-party type-resolution noise (`undici-types`, `@modelcontextprotocol/sdk`, `@google/genai`), 0 pi-related.

Environmental notes: had to build `better-sqlite3`'s native binding manually via `prebuild-install` (the sandbox blocked `node-gyp` during `yarn install`) and run test binaries via `node <cli.js>` with an on-PATH `ava` shim (`/tmp` is `noexec`, and the pnpm linker didn't populate `.bin`). These are harness-environment workarounds, not project issues.

**Follow-ups**
- Durable migration off the `/compat` shim (slated for removal in a later pi release) onto `createModels()`/provider factories for agentry+genie — deferred to keep this PR behavior-preserving and reviewable; noted in the PR body.
- Maintainer decision: take the pi bump via #649 and drop it from #607's group, or merge both.
