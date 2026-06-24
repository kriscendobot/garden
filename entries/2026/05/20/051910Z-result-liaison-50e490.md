---
ts: 2026-05-20T05:19:10Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 050724Z-dispatch-liaison-50e490
---

# Result: designer 50e490 — forge gap analysis (PR #310 open)

Designer dispatch `50e490` complete. Deliverable: draft PR [endojs/endo-but-for-bots#310](https://github.com/endojs/endo-but-for-bots/pull/310) — `design: gap analysis of antoinezambelli/forge vs. Endo`, branch `design/forge-gap-analysis`, head `3d2e60fc5`. Self-report at `journal/entries/2026/05/20/051853Z-result-designer-50e490.md`.

## Forge in one sentence

A Python reliability layer for self-hosted LLM tool-calling that wraps an agentic loop with rescue-parse + retry-nudge validation, declarative step enforcement, tiered context compaction, and a multi-backend client adapter, plus an OpenAI-compatible HTTP proxy.

**Read at**: forge head SHA `f1b87b05b863c7d12927f3dbdbd716af2dc3ace1` (tag `v0.6.0`, 2026-05-19). PyPI name `forge-guardrails`, Python 3.12+, MIT, 542 stars, primarily one contributor.

## Top 3 gaps (endo's side, what forge does we don't)

1. **Tiered context compaction with reasoning-trace preservation**.
2. **Rescue-parse + retry-nudge pipeline** (graceful recovery from LLM JSON-format drift).
3. **Type-tagged transcript messages** (`MessageMeta`).

## Top 3 gaps (forge's side, what endo does forge doesn't)

1. **Capability-based tool isolation**.
2. **Persistent agent identity via daemon PINS**.
3. **SES `lockdown` + Compartment-Mapper module-level isolation**.

## Trust-model verdict

**Compatible at the loop layer; incompatible at the tool-binding layer.** Forge's loop machinery (message arrays, value objects, ports) ports cleanly without violating ocap discipline. `ToolDef.callable` is what doesn't port; the right adaptation keeps `ToolSpec` and replaces the callable with `E(toolCap).call(args)`.

## High-leverage adoption recommendation

Land type-tagged transcript messages in `@endo/lal` first (size M), then tiered compaction (M), then rescue-parse + retry-nudge (S). The three compose; the order minimizes refactor cost.

## Open questions (for the maintainer's call)

1. Compatibility of forge-style compaction with lal's transcript-tree persistence (compacted-summary node placement, branched-reply behavior).
2. Where a forge-port lands: `@endo/lal`, `@endo/fae`, or a shared `@endo/llm-loop`.
3. Whether to write a `journal/library/concepts/forge.md` page (knowledge library, not design).
4. Whether the forge proxy is worth a deeper read as prior art for `designs/endo-gateway.md`.
5. Whether to dispatch a follow-up to scope an `@endo/forge-loop` package.

## Teardown

Dispatch root `/home/kris/dispatches/designer--50e490/` torn down by the liaison after this entry lands.
