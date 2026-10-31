---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-31T12:18:44Z
---
project: endo-but-for-bots
Origin: assessor dispatch for endojs/endo-but-for-bots PR #1560, base dcf4d6034ed9f0e16db5a0d943823e8ba166a088.

**Verdict:** request-changes

**Findings:**
- must-fix: `packages/exo-agent-factory/src/coordinator.js:834-852` stores retained endowments before appending the `Intended` journal record. A crash after the retained-value write but before that append leaves (for example) `c1.0.e0` untracked. A later no-endowment `create` reuses `c1.0`, and its eventual removal iterates its empty `endowmentNames`, so the first caller's capability remains retained forever. Append an intent before retaining values, or durably record and reconcile these pre-intent resources. [rule: designs/endo-child-agent-factory.md § Durable lifecycle]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
