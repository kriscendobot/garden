---
ts: 2026-05-15T05:04:15Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/044500Z-dispatch-liaison-c29438.md
---

# Result: endopi comparative analysis + gap-closing raft

## Target disambiguation

The maintainer's directive named "the pi harness" without a URL. Five
candidates surfaced via web search; chose `badlogic/pi-mono`
([github.com/badlogic/pi-mono](https://github.com/badlogic/pi-mono), MIT,
~49.5k stars, v0.74.x, head SHA `a8af0b5e99e3309c5cbc3301c276302512789ca5`
at clone time) for three reasons:

1. It is the canonical source-of-truth monorepo; `earendil-works/pi`
   mirrors the same content.
2. Pi and OpenClaw share an author (Mario Zechner / `badlogic`), and
   the existing [endoclaw.md](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md)
   § *Persistence and Memory* already references "Pi-compatible jsonl
   files" as a target shape. The endopi/endoclaw pair therefore covers
   the same author's coding-agent and assistant projects.
3. The other candidates are forks (`tibormester/pi-harness`,
   `werg/pi-harness`, `davidondrej/pi-agent`), a Rust port
   (`Dicklesworthstone/pi_agent_rust`), or a downstream skin
   (`can1357/oh-my-pi`) of the canonical upstream; mapping the upstream
   covers them.

Inflection AI's Pi was explicitly considered and rejected: consumer
chatbot, no harness surface to compare against endo.

## PR + head SHA

- PR: https://github.com/endojs/endo-but-for-bots/pull/265 (DRAFT,
  base `llm`, head `design/endopi`).
- Branch head SHA: `b5fd77d4e6beeddcd38d807fc6966d055efd1454`.

## Files authored

In `endojs/endo-but-for-bots:designs/`:

1. `endopi.md` (Reference) — umbrella with metadata table,
   architecture-comparison matrix, feature-by-feature mapping, gap
   table, contrasts (capability / persistence / extensibility / security
   / agent-orchestration), Pi-specific-moves-endo-declines section,
   citation index, related-designs cross-links, `## Prompt`.
2. `endopi-edit-tool.md` (Proposed) — LLM-friendly oldText/newText edit
   primitive on `File` capability.
3. `endopi-jsonl-transcript-format.md` (Proposed) — on-disk JSONL
   projection of the Lal transcript graph; satisfies endoclaw's
   Pi-compatible-jsonl directive.
4. `endopi-provider-registry-and-oauth.md` (Proposed) — multi-provider
   registry + subscription OAuth (Claude Pro/Max, ChatGPT Plus,
   Copilot) + cross-provider mid-session handoff.
5. `endopi-skills-markdown-format.md` (Proposed) — on-disk SKILL.md
   format per agentskills.io; paired with daemon-side
   endoclaw-skill-registry.
6. `endopi-prompt-templates.md` (Proposed) — reusable user-prompt
   scaffolds with `{{var}}`.
7. `endopi-iterative-compaction.md` (Proposed) — auto-compaction
   algorithm; concrete substrate for the existing
   lal-transcript-memory-management problem statement.
8. `endopi-stdio-rpc-bridge.md` (Proposed) — LF-delimited JSONL RPC
   for embedding Lal/Fae in another process; short-term shape before
   endor-bus-tui.
9. `endopi-extension-package-manifest.md` (Proposed) — `package.json`
   `endo` keyword bundling guests + skills + prompts + providers in
   one `endo install`.

Plus: `designs/README.md` updated per `designs/CLAUDE.md` (See-also
header line, summary table rows, totals line, per-design estimate
rows; mileposted across M1, M4, M5).

Drafts preserved under `journal/projects/endo/drafts/endopi*.md`.

## Counts

- Gaps spun out as sibling designs: **8** (eight `endopi-*` files in
  addition to the umbrella `endopi.md`).
- Pi source files cited at file level in the umbrella's citation index:
  **27 file-level URLs** (plus four directory URLs for `providers/`,
  `harness/`, `modes/rpc/`, `src/` of the agent package).

## Notes for the orchestrator

- No implementation work touched. No upstream comment / reactji /
  cross-link beyond the PR body itself.
- PR opens DRAFT per role norm; un-drafting is the maintainer's
  decision after design review.
- Per today's self-improvement directive, the commit + push landed
  before any extended local validation (no `yarn format` / `yarn lint`
  was run; design files are markdown-only and the project's eslint /
  type-check do not apply to designs).

Self-improvement: target-disambiguation worked smoothly when the
dispatch prompt named it as the first step. The prior `endoclaw.md`'s
explicit mention of "Pi-compatible jsonl files" was the deciding
evidence; future designers facing an under-specified target benefit
from grepping the project's existing designs for prior references to
the candidate's name before going to the web. Suggest a one-line note
in `roles/designer/AGENT.md` § Operating norms: "When the dispatch
target is named only by a short label, grep the consuming project's
existing `designs/` for prior references before web-searching; the
maintainer's prior framing usually disambiguates."
