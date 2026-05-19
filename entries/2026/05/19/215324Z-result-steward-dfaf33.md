---
ts: 2026-05-19T21:53:24Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/213542Z-dispatch-steward-6e1528.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Steward wrap-up: #290 boundary test landed

Fixer dispatch `91818d` returned. Single commit `664bf89f9` on
`feat/lal-pi-harness`: `test(lal): pin PiAgent + tools boundary
with validateAndFixupArgs retry path (per #290)`.

**Test**: `packages/lal/test/pi-agent-tools.test.js`. Constructs
`PiAgent` exactly as `spawnWorkerLoop` does (same tool surface
via `toolDefs` + `toAgentTool` + `makeExecuteTool`; same
`convertToLlm` identity-filter). Scripted assistant turn carries
two tool calls in one batch:

- `send` with normal args (proper arrays) — first `mustMatch`
  succeeds.
- `move` with JSON-encoded-string `fromPath`/`toPath` — first
  `mustMatch` against `NamePathShape (M.arrayOf(M.string()))`
  fails for a string; the retry `JSON.parse`s each string field
  and the second `mustMatch` succeeds.

**Retry-path proof**: mock-powers' `move(fromPath, toPath)` calls
`fromPath.join('/')` which throws on a string. The test asserts
the destination pet name was created and the source pet name was
removed — only possible if `validateAndFixupArgs` produced arrays
before the switch dispatched.

**Minimal surface change**: `toolDefs`, `makeExecuteTool`,
`toAgentTool` in `packages/lal/agent.js` gained `export` so
the test can build the production tool surface. No behavioral changes.

**Local pass count**: 6/1 (was 5/1; +1 new). **Prettier**: clean.

**Reply**: [#290 issuecomment-4492357867](https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4492357867).
**Re-request**: kriskowal + jcorbin + 0xpatrickdev all added.

**Self-improvement (forwarded from fixer)**: for validation/fixup
paths, assert on a downstream call that would fail closed without
the fixup, not on the post-fixup args object. Worth a short note on
either `regression-evidence` or `coverage-driven-testing` skill.
Routing to gardener via this entry.

**Adjacent context**: PR #297 (`0xpatrickbot`,
`fix(ses, module-source): support pi-mono in confined Endo
Compartments`) opened during this cycle — patrick's split series
continues. Not garden-authored; noted but no scan owed. Issue #229
also closed by kriskowal as part of design PR #231 (`design(familiar):
MVR release plan (closes #229)`) — also routine.
