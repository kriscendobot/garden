---
ts: 2026-05-13T21:19:36Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/Jessie
    pr: 127
    role: source
---

# Dispatch: designer drafts Lal+Jessie+Blocky variation of the `define` tool

Dispatch root: `dispatches/designer--lal-jessie-blocky--20260513-211935--bce097/`. Designer's first engagement of the day; the role file is at `roles/designer/AGENT.md`.

Task: inspect dckc's work at `https://github.com/endojs/Jessie/pull/127` and propose a design document for a variation on the Lal agent's "define" tool call. The variation: limit the `define` tool's accepted JavaScript to the Jessie subset, and render proposed programs in Blocky in the Chat UI.

The Jessie PR #127 is "Add Blockly visual programming tools for JSON, Justin, and Jessie" by @Copilot. Inspect it via `gh pr view 127 -R endojs/Jessie --json files,body,title` and `gh pr diff 127 -R endojs/Jessie | head -500` for substance.

Design document destination: `designs/lal-jessie-blocky.md` (or similar slug — designer picks) on `endo-but-for-bots@llm`. Open a PR proposing the design.

Procedure (per `roles/designer/AGENT.md`):

1. Read `references/endo-but-for-bots/roles/designer.md` if any clarification on the role's idiom is needed; you have the active role file as your primary source.
2. Read the Jessie PR thoroughly. Note the Blockly tooling shape, the subset-of-JS constraints Jessie imposes, and how Copilot's PR exposes them.
3. Investigate the Lal agent's existing `define` tool call in this garden's `endo-but-for-bots` repo. Search the source for "Lal" and "define" tool references; locate the relevant package (likely under `packages/`).
4. Draft the design document. Sections per the designer role's idiom (purpose, sketch, alternatives considered, open questions). The design should:
   - Describe a `define-jessie` tool variant that limits accepted JS to the Jessie subset (citing the Jessie validator from PR #127 as the parser/checker).
   - Describe rendering of accepted programs in Blocky in the Chat UI.
   - Identify integration points: where in Lal's tool-call routing the variant fits; what the Chat UI needs (component additions); how validation errors surface.
5. Identity kriscendobot. Per the pr-creation-flow norm: open in **draft**. Conventional-commits title: `design: lal define-jessie tool with Blockly rendering`.
6. Push to `mirror/design-lal-jessie-blocky` (or similar) on `endojs/endo-but-for-bots`; open the draft PR against `llm`.

Out of scope:
- Do not author Lal source code or Blocky integration code; this dispatch is design-only.
- Do not file anything on `endojs/Jessie` upstream.
- Do not run CI or implement tests.

Report: PR URL, design file path, the alternatives considered and the recommended one (one sentence each), open questions to surface to the maintainer.
