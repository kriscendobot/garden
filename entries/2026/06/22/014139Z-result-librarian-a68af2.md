---
kind: result
role: librarian
dispatch: librarian--a68af2
cycle: 453
lane: designs
date: 2026-06-22T01:41:39Z
---

Cycle 453 (designs-lane, post_refactor_sequence: 101) ingested `packages/lal/primer/formatting.md` as the primary source and `packages/lal/primer/errors.md` as a companion, completing the lal primer corpus (all files now ingested). Both are 31-line agent-facing primer documents from `endojs/endo-but-for-bots` branch `llm`, commit `10594d09fa6efff9f7d4271adc2f2f19214fd756` (2026-03-26, Kris Kowal).

**Single most structurally interesting move**: §the-named-quasi-markdown-dialect-as-non-standard-inline-formatting. The `formatting.md` primer discloses that the LAL chat surface uses a **custom markdown dialect** — Quasi-Markdown — with non-standard inline formatting optimized for capability-path contexts: `*bold*` (single asterisk, not double), `/italic/` (forward slash), `^superscript^`, `~subscript~`, monospace backtick. This is the cluster's first explicit custom-language-definition. Prior cycles recorded IMPORTANT-marker usage (cycle 407) and SmallCaps encoding (cycle 449); cycle 453 adds the inline-formatting layer as a third distinct encoding surface in the LAL primer corpus.

**Companion section** (errors.md): §the-named-verify-before-act-as-universal-pet-name-precondition — every tool call that accepts a pet name must first verify the pet name exists and resolves to the expected type before acting; violation produces a four-step error response protocol (acknowledge, explain, verify, retry or ask).

**Citation arc delta**: five arcs closed across both sections (formatting: cycle 452 arc 1 adjacent-forward + cycle 449 arc 3 + cycle 407 arc 3; errors: cycle 407 arc 3 + cycle 413 arc 3). Pushes citation-arc-closures-in-pivot past NINE-HUNDRED-AND-SIXTY.

**State delta**: sections 967 → 969 (+2); topics/agent-conventions count 54 → 56, topics/chat-ui count 57 → 58, topics/errors count 32 → 33; sources/README.md +2 rows; lal primer corpus complete (all 10 primer files now ingested: README, capabilities, chat-reference, cli-reference, howto-capabilities, howto-code, howto-inventory, howto-messaging, messaging, smallcaps, tools, formatting, errors — the primer index lists 10; formatting + errors were the final two); post_refactor_sequence: 101.

**Files created**: `sections/endo-but-for-bots--packages-lal-primer-formatting-md--quasi-markdown-dialect-with-non-standard-inline-formatting.md`, `sections/endo-but-for-bots--packages-lal-primer-errors-md--verify-before-act-and-error-handling-discipline.md`, `sources/endo-but-for-bots--packages-lal-primer-formatting-md.md`, `sources/endo-but-for-bots--packages-lal-primer-errors-md.md`.

**Files updated**: `sections/README.md` (cycle 453 heading + 2 entries, count 5559→5561), `topics/agent-conventions.md` (+2 rows), `topics/chat-ui.md` (+1 row), `topics/errors.md` (+1 row), `topics/README.md` (3 counts updated), `sources/README.md` (+2 rows before designs/familiar-app-ui-hosting entry).
