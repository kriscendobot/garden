---
created: 2026-05-14
author: liaison
---

# Endo design drafts awaiting maintainer triage

Designs authored by garden designer dispatches but not yet committed to `endojs/endo`. Each file is a verbatim copy of the dispatch worktree's `project/designs/<slug>.md`, preserved here so the dispatch root can be torn down without losing the work. The maintainer reviews these in-place; when triaged, the next dispatch (designer revision or builder) reads from here and lands them on a fork branch as part of opening the PR.

## Current drafts

**2026-06-11 Endo strategy engagement** (maintainer brief; liaison sub-orchestration `32c83f`):

- [resequencing-2026-06.md](./resequencing-2026-06.md) — Workstream A: M3–M11 resequencing proposal for the two-stage O1/O2 objective; 15 proposed gap-design files; old→new mapping table ready to apply on authorization. Maintainer-gated; no ledger edits applied. Designer dispatch `d4cf94`.
- [prospectus-2026-06.md](./prospectus-2026-06.md) — Workstream B1: supportive-investor prospectus (attenuation moat, staged plan, funding-the-commons). Journalist dispatch `2a3e67`.
- [bear-brief-2026-06.md](./bear-brief-2026-06.md) — Workstream B2: bear brief; eight objections at full strength with per-objection dispositions and retirement conditions. Journalist dispatch `199b06`.
- [operators-pitch-2026-06.md](./operators-pitch-2026-06.md) — Workstream B3: operator's pitch (O1 developer audience; practical second person; stage-honesty section). Journalist dispatch `a0a95f`.
- [hosts-pitch-2026-06.md](./hosts-pitch-2026-06.md) — Workstream B4: host's pitch (O2 community-operator audience; candor register; open problems named from the gap inventory). Journalist dispatch `dd5978`.
- [road-to-maturity-2026-06.md](./road-to-maturity-2026-06.md) — Workstream C: the synthesis (argument / machine / road / maturity), successor to "A Choice of Giants". **Identity-sensitive: not for publication or attribution until the maintainer explicitly approves.** Journalist dispatch `58f7ba`.

- [exo-import.md](./exo-import.md) — plug-and-play import mechanism using compartment-mapper primitives, Go-style version resolution, snapshot-strict. Authored by designer (dispatch `e3b1aa`, 2026-05-14). Sibling: exo-npm-registry. Open questions surfaced in [`entries/2026/05/14/051353Z-result-designer-e3b1aa.md`](../../../entries/2026/05/14/) and on the bulletin's *Awaits maintainer decision*.
- [exo-npm-registry.md](./exo-npm-registry.md) — daemon-side capability that captures, indexes, and vends readable-trees for `(npm name, version)` couples; the lookup interface that `exo-import` consumes. Authored by designer (dispatch `e3b1aa`, 2026-05-14). Sibling: exo-import.
- [ses-import-attributes.md](./ses-import-attributes.md) — propagate JavaScript's import-attributes (`with { type: 'json' }` clause) through normalization → memo-key extension → SES `importHook` signature → source-type multiplex in ModuleSource. JSON in v1; CSS/Wasm deferred. Authored by designer (dispatch `96bd08`, 2026-05-14, priority: medium).
- [ses-top-level-await.md](./ses-top-level-await.md) — top-level-await in SES and `@endo/module-source`. Leads with a 17-row test suite (12 spec-transliterated from test262 `language/module-code/top-level-await/`, 5 SES-shim-only including bundle-source round-trip and `importNow` rejection). Body covers static analysis (one Babel `AwaitExpression` visitor), module-instance contract additions (`asyncEvaluation`, `topLevelCapability`, `[[CycleRoot]]` via Tarjan low-link), evaluation procedure, `compartment.importNow` synchronous-TypeError guard, bundle-source coupling, and sync-module backward compatibility. Authored by designer (dispatch `759853`, 2026-05-14, priority: extreme low).
- [endopi.md](./endopi.md) and 8 siblings ([endopi-edit-tool](./endopi-edit-tool.md), [endopi-extension-package-manifest](./endopi-extension-package-manifest.md), [endopi-iterative-compaction](./endopi-iterative-compaction.md), [endopi-jsonl-transcript-format](./endopi-jsonl-transcript-format.md), [endopi-prompt-templates](./endopi-prompt-templates.md), [endopi-provider-registry-and-oauth](./endopi-provider-registry-and-oauth.md), [endopi-skills-markdown-format](./endopi-skills-markdown-format.md), [endopi-stdio-rpc-bridge](./endopi-stdio-rpc-bridge.md)) — comparative analysis of `badlogic/pi-mono` (Pi agent harness) vs Endo, with 8 gap-closing spin-outs. Authored by designer (dispatch `c29438`, 2026-05-15); opened as PR #265 draft.
- [endopen.md](./endopen.md) and 4 siblings ([endopen-concurrent-subagents](./endopen-concurrent-subagents.md), [endopen-openrouter](./endopen-openrouter.md), [endopen-tui-shell](./endopen-tui-shell.md), [endopen-acp-server](./endopen-acp-server.md)) — comparative analysis of `anomalyco/opencode` (HEAD `d59d9966`) vs Endo, mirroring the [endoclaw](../../../../project/designs/endoclaw.md) precedent: architecture comparison table, feature-by-feature mapping, 4 gap-closing spin-outs covering concurrent subagents, OpenRouter, opencode-shaped UX, and ACP server adapter. 19 OpenCode source citations. Authored by designer (dispatch `f47931`, 2026-05-15); branch `design/endopen` pushed (PR pending).

## Lifecycle

A draft clears from this directory by one of:

- A builder dispatch lands the design on a fork branch of `endojs/endo` and opens the PR; the file here stays for the historical record (the journal is append-only) but the bulletin row moves to *Pending kriskowal reviews*.
- The maintainer signals a redesign; a fresh designer dispatch authors a new draft (either replacing this one or with a `supersedes:` cross-reference in the frontmatter).
- The maintainer signals the design is abandoned; the file's frontmatter gets a `status: abandoned` field flipped (the file body stays per append-only).
