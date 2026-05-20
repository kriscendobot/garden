---
ts: 2026-05-20T05:18:53Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/20/050724Z-dispatch-liaison-50e490.md
---

# Result: designer studies antoinezambelli/forge and produces a gap analysis

Dispatch root: `dispatches/designer--50e490/`.
Project worktree: `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Deliverables

- Design document: `designs/forge-gap-analysis.md` on
  `endojs/endo-but-for-bots@design/forge-gap-analysis` (HEAD
  `3d2e60fc5`).
- DRAFT PR: https://github.com/endojs/endo-but-for-bots/pull/310
  (base `llm`).
- `designs/README.md` synced: row added to Summary table as
  `Reference (exploratory)`; *See also* caption updated;
  `Last updated: 2026-05-20`; totals updated to 105 designs.

## Forge head SHA at read

`f1b87b05b863c7d12927f3dbdbd716af2dc3ace1` (tag `v0.6.0`, last
push 2026-05-19).
PyPI name: `forge-guardrails`. Python 3.12+. MIT.
542 stars, 26 forks, 4 open issues, primarily one contributor.

## Forge in one sentence

A Python reliability layer for self-hosted LLM tool-calling that
wraps a multi-step agentic loop with rescue-parse + retry-nudge
validation, declarative step enforcement, tiered context compaction,
and a multi-backend client adapter, plus an OpenAI-compatible HTTP
proxy that injects the same guardrails between any OpenAI client and
a local llama-server / Ollama / Llamafile / Anthropic API.

## Top 3 gaps from endo's perspective

1. **Tiered context compaction** with reasoning-trace preservation as
   the slowest-cut tier (`src/forge/context/strategies.py`).
   Directly addresses what `LAL_MAX_MESSAGES` papers over in
   `@endo/lal`.
2. **Rescue-parse + retry-nudge pipeline** for malformed tool calls
   (`src/forge/guardrails/response_validator.py`).
   Slots under `extractToolCallsFromContent` at
   `packages/lal/agent.js:944` and recovers conversations that today
   terminate when the model fails to emit a structured call.
3. **Type-tagged transcript messages** (`MessageMeta` with `type`,
   `step_index`, `original_type`).
   Prerequisite for any kind-aware compaction; also useful for
   lal's existing transcript-tree persistence.

## Top 3 gaps from forge's perspective

1. **Capability-based tool isolation.**
   Forge tools are raw Python callables in the runner's process;
   endo tools are caplets with method interfaces and scoping.
2. **Persistent agent identity** via `@endo/daemon` PINS and
   restart survival (`packages/fae/README.md` § "Restart survival").
3. **SES lockdown + Compartment Mapper** — module-level isolation at
   the npm-package boundary.

## Trust-model verdict

**Compatible at the loop layer; incompatible at the tool-binding
layer.**
Forge's compaction, validation, step enforcement, and retry
budgeting operate on message arrays and value objects;
they never see a capability and port without violating ocap
discipline.
`ToolDef.callable` is the part that does not port:
replacing it with `E(toolCap).call(args)` is the right adaptation.
No part of forge's design contradicts endo's;
the clash is one of scope, not philosophy.

## High-leverage adoption recommendation

Land **type-tagged transcript messages** in `@endo/lal` first,
then **tiered compaction** on top of that, then the **rescue-parse +
retry-nudge** pipeline.
The three compose; the order minimizes refactor cost.
Estimated sizes: M, M, S respectively.
A shared package (`@endo/llm-loop` or similar) is plausible but the
fae/lal transcript-shape divergence may make a per-package port the
pragmatic first step.

## Open questions surfaced

1. Compatibility of forge-style compaction with lal's transcript-tree
   persistence (which node holds the compacted summary; how branched
   replies behave).
2. Where a forge-port should land (`@endo/lal`, `@endo/fae`, or
   shared `@endo/llm-loop`).
3. Whether to write a `journal/library/concepts/forge.md` page.
4. Whether the forge proxy is worth a deeper look as prior art for
   `designs/endo-gateway.md`.
5. Whether to dispatch a follow-up to scope an `@endo/forge-loop`
   package.

## Scope discipline

- No implementation; no `@endo/*` source edits.
- No PR or contribution to `antoinezambelli/forge` upstream.
- PR stays DRAFT (no un-draft from this dispatch).
- Forge clone in `dispatches/designer--50e490/scratch/forge/`;
  torn down with the dispatch root.

Self-improvement: nothing this time.
