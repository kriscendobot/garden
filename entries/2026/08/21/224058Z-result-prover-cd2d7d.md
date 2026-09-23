---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-08-21T22:41:00Z
---
Prover seat, PR kriscendobot/minion.town#50 ("port whoami tool"), diff base origin/main,
head worktree project-wt-kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-panel-1-9e96a583.
Primary dispatch: kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-panel-1.

### prover

**Verdict:** approve

**Findings:**

- (none — all new/rewritten tests are load-bearing.)

**Notes (out of scope but worth flagging):**

- comment-only — `authorize()` (`src/server.ts:84-102`) and the `whoami` handler
  each independently call `resolveEffectiveScopes` for the same request, so
  every `whoami` call resolves effective scopes twice. Not a correctness bug
  (`resolveEffectiveScopes`'s auto-provision path is idempotent on the second
  call — `store.get` finds the row the first call provisioned), just doubled
  work; a decomplector/pruner concern, not a regression-evidence one.
  [proposed-rule: a per-call authorization gate that resolves the same derived
  value the handler also needs should return it to the caller rather than
  making the handler re-derive it]

**Method:** ran the full new/changed test set (`test/auth.test.ts`,
`test/scopes.test.ts`, `test/endo-guest-http.test.ts`) at HEAD — 13 passed.
Then reverted `src/auth/scopes.ts` and `src/server.ts` to `origin/main` only
(test files untouched) and re-ran: the 6 new/rewritten `whoami`-specific tests
and the new `test/scopes.test.ts` all reddened with clear, on-topic failures
(missing `whoami` from `tools/list`, `isToolAllowed is not a function`, wrong
`role`/`scopes` payloads, `Tool whoami not found` instead of
`insufficient_scope`). Restored the production files afterward and confirmed
`git diff HEAD` was clean. Each new test therefore pins real behavior the
production diff introduces, per `skills/regression-evidence/SKILL.md`:
- `test/scopes.test.ts` pins `TOOL_SCOPES`/`isToolAllowed` directly.
- `test/auth.test.ts` "advertises whoami alongside guest_* tools…" and the
  mirrored `test/endo-guest-http.test.ts` case pin that `whoami` is
  unconditionally registered.
- "an admin sees their resolved identity…" and "a fresh verified user
  principal is admitted as guest and whoami reports it" pin the full
  identity/role-resolution path (including the static-policy-overrides-account-
  role precedence the code comments).
- "allows whoami with only the baseline mcp/tools scope" pins that `whoami`
  requires ONLY `mcp/tools`, distinct from the daemon-guest tools' `mcp/guest`
  gate — the one place this PR could plausibly have over-scoped the new tool
  and didn't.
- "denies whoami when effective scopes omit mcp/tools" pins the `authorize()`
  throw path.

The renamed "denies a token missing mcp/tools with insufficient_scope" test in
`test/auth.test.ts` exercises the pre-existing `src/http.ts` route gate
(unchanged in this diff) — it passed both before and after the revert, so it
is not new evidence for this PR's production change, but it is not
mischaracterized either; no finding.

Self-improvement: no friction. The revert-and-redden check was cheap here
because the package's dependencies were already installed in the worktree and
`vitest run <files>` scopes to just the touched suites.
