---
ts: 2026-06-22T14:37:27Z
kind: result
role: librarian
project: endo-but-for-bots
---

Cycle 444 chat-lane library ingest complete.

**Source ingested**: `packages/fae/src/extract-tool-calls.js` (188 lines, commit `db3739e`, 2026-04-09, Kris Kowal).

**Single most structurally interesting move**: §the-named-three-wire-format-normalization-as-model-agnostic-layer — `extractToolCallsFromContent` normalizes LLM assistant content across three wire formats: (1) standard JSON inside `<tool_call>` tags, (2) Qwen XML `<function=name><parameter=k>v</parameter>` format inside `<tool_call>`, and (3) bare `<function=name>` blocks outside any wrapper. Three formats, one uniform output shape. This is the RESPONSE-SIDE counterpart to cycle 416's tools.js (discovery). The module is the seam between fae's capability-first design and the LLM provider's wire format (provider-determined). §the-named-three-format-normalization-as-provider-agnostic-contract as tier-3 meta-pattern.

Additional patterns surfaced: §the-named-two-pass-extraction-handles-format-ambiguity (two-pass structure prevents format confusion); §the-named-think-block-stripping-for-chain-of-thought (both closed and unclosed `<think>` stripped; tool calls inside `<think>` still extracted); §the-named-last-resort-regex-for-malformed-json (three-tier parse cascade: JSON.parse → parseFunctionParamFormat → regex fallback); §the-named-parseParamValue-typed-coercion; §the-named-synthetic-tool-id-generation; §the-named-fae-src-as-three-module-tool-pipeline (FaeToolInterface + tools.js + extract-tool-calls.js); §the-named-shareable-but-not-shared-extraction-module (cycle 415 noted extract is separate in fae, inline in lal; confirmed).

**Citation arc delta**: 7 arcs closed. Prior count: 889. New count: 897.

**State delta**: 134th consecutive non-garden source after the pivot (310-444). 92nd AUTHORED conformant single-body section doc in post-refactor era. fae/src tool pipeline now complete across three modules.

**Files written**:
- `library/sections/endo-but-for-bots--packages-fae-src-extract-tool-calls-js--multi-format-tool-call-normalization.md`
- `library/sources/endo-but-for-bots--packages-fae-src-extract-tool-calls-js.md`
- `library/sections/README.md` (updated totals and added cycle 444 entry)

Self-improvement: nothing this time.
