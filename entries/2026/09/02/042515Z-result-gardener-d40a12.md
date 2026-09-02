---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-02T04:25:20Z
---
---
kind: result
role: assessor
repo: kriscendobot/minion.town
project: minion-town
---

Panel seat `assessor` on kriscendobot/minion.town PR #79 (`feat/tool-name-reconciliation`, head 8cf0b50, base origin/main).

### assessor (correctness logic and control flow)

**Verdict:** request-changes

**Findings:**

- `src/endo/mcp-tool-names.ts:4-6` — the manifest's stated invariant ("collisions are judged on the maximal surface") holds only if the manifest is the *sole* source of registered names, and nothing enforces that. The module-load guard at `:57-63` checks the manifest against itself; no test asserts that what `registerGuestTools` / `registerClipTools` actually pass to `server.registerTool` comes from `MCP_TOOL_NAMES`. A later facet author writing `server.registerTool("list", …)` directly leaves the guard green and still produces the `Tool list is already registered` boot crash the README rule exists to prevent. The three tool-list tests that could close the loop (`test/endo-clip-tools.test.ts:104-137`, `test/endo-guest-tools.test.ts:77`, `test/endo-guest-lockdown.test.ts:103`) still hardcode bare string literals, so they drift independently of the manifest. Concrete fix: assert the wired `tools.map(t => t.name)` set equals `Object.values(MCP_TOOL_NAMES.baseline)` (plus `.sites` when clips are wired) and is a subset of `MAXIMAL_MCP_TOOL_NAMES`. must-fix. [rule: README.md § Naming convention, rule 3 — "registerTool throws … an un-qualified collision … is a whole-surface boot crash"]

- `src/endo/mcp-tool-names.ts:9,45` — every group is `Object.freeze`d and `MAXIMAL_MCP_TOOL_NAMES` is frozen, but the outer `MCP_TOOL_NAMES` object is not; `as const` is erased at runtime, so `MCP_TOOL_NAMES.sites = {…}` succeeds. The constants are read at `registerTool` call time inside `registerGuestTools` (`src/endo/guest-tools.ts:175` ff.), i.e. after any such mutation, so the "single source of names" is mutable in exactly the window it is consumed. Repo precedent freezes both levels: `src/endo/gateway/well-known.ts:28,35`. should-fix. [proposed-rule: an exported constant manifest freezes its container as well as its members; `as const` is a type-level claim, not a runtime one]

- `src/endo/mcp-tool-names.ts:5,47` — "every implemented and approved proposed name" overstates what the manifest holds. The reminder facet's approved reconciliation names five tools (`designs/endo-reminder-minion-town.md:54-58`); only the two whose collisions are settled (`listReminders`, `cancelReminder`) are listed, per the PR body's own scoping. Nothing collides today, but a reader takes the comment as a completeness claim and judges a new name against a surface that is not in fact maximal. Restate the scope as "every name whose reconciliation is settled" (the manifest content is right; the comment is not). should-fix. [rule: designs/endo-reminder-minion-town.md:60 — per-method reconciliation is left to the reminder build]

Verified no behavioral change: all sixteen substituted constants are byte-identical to the literals they replace, and `test/endo-mcp-tool-names.test.ts`, `test/endo-guest-tools.test.ts`, `test/endo-clip-tools.test.ts` pass (29 tests) on the head commit. `findDuplicateToolNames` is correct for repeats of multiplicity > 2 (`["a","a","a"] → ["a"]`); its O(n^2) `indexOf` is irrelevant at n=22 and not on any hot path.

**Notes (out of scope but worth flagging):**

- `test/endo-mcp-tool-names.test.ts` imports the module at top level, so a future duplicate surfaces as an unhandled import error that fails all five tests — including "reports no duplicates on the real manifest" — rather than as the targeted assertion. That is the intended fail-fast and the second commit's message names it; noted only so the diagnostic is not mistaken for a suite-wide breakage. [rule: skills/panel-review/SKILL.md § In-scope vs out-of-scope]

- `MAXIMAL_MCP_TOOL_NAMES` assumes every own property of `MCP_TOOL_NAMES` is a group object; a future scalar property (e.g. a `version` string) would flatten to its characters silently. Not worth a guard today. [proposed-rule: a derived-from-shape constant states the shape assumption it flattens over]

Self-improvement: the seat's leverage here was checking whether the *enforcement* reaches the call sites rather than only the declaration — a manifest that validates itself is the recurring shape of a decorative invariant. Worth encoding in `roles/jurors/assessor/AGENT.md` § Operating norms as a named check: when a PR introduces a registry or manifest whose purpose is to prevent a collision or drift, ask what test would fail if a future author bypassed it; if none would, the invariant is advisory.
