---
ts: 2026-05-13T21:27:06Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/13/211936Z-dispatch-liaison-bce097.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 237
    role: target
    title: "design: lal define-jessie tool with Blockly rendering"
  - repo: endojs/Jessie
    pr: 127
    role: source
---

# Result: designer drafted `lal-jessie-blocky.md`

Draft PR open: https://github.com/endojs/endo-but-for-bots/pull/237 against `llm`, on topic branch `design/lal-jessie-blocky`.

Design file: `designs/lal-jessie-blocky.md` (one screen and change, project's metadata-table conventions followed). README updated: new row in the summary table, milestone-4 row, per-design estimate, totals incremented (105 designs, 51 remaining).

Recommended approach (one sentence): add `define-jessie` as a sibling of `define` in Lal's tool registry, validate the proposed source against the Jessie checker from endojs/Jessie#127 before forwarding to `E(powers).define`, tag the resulting host-side package message with `language: 'jessie'`, and render the proposal in Chat via a new `define-jessie-form.js` that embeds the Jessie workspace from `@jessie/blockly-tools`.

Alternatives considered (one sentence each):
- Replace `define` outright with `define-jessie` (rejected: would break proposals needing JS features Jessie excludes).
- Validate as Justin instead of Jessie (rejected: too narrow; Jessie matches the Blockly tooling's natural scope).
- Render Jessie in Monaco with a Jessie-aware linter rather than Blockly (rejected for v1: text-editor presentation does not match the proposal model; Blockly is the documented bet).
- Inline the Blockly workspace in the chat message bubble rather than as a modal (rejected for v1: complicates focus and threading; revisit after Phase 3).
- Build Lal-specific Blockly blocks with baked-in Endo capability references (rejected for v1: couples Lal to bespoke blocks and diverges from PR #127's shared Jessie tooling).

Open questions surfaced to the maintainer:
1. `@jessie/parse` package name and checker API after Jessie #127 lands and is published.
2. Cleanest extension point for the `language` tag on `define` (recommended: optional `options` arg; fallback: reserved slot key).
3. Library-build packaging of `@jessie/blockly-tools` for embedded use in Chat (PR #127 ships a Vite app, not a library export).
4. Custom `jessie_slot` block (recommended) vs. Blockly's standard variable blocks for slot identity.
5. Whether soft system-prompt steering toward `define-jessie` will be effective, or if a hard reject-and-suggest rule is needed (Phase 4+ tuning).

Phasing: Phase 1 (Lal tool registration, S), Phase 2 (host language tag, S), Phase 3 (Blockly form component, M), Phase 4 (tests and docs, S). Total ~5 days (M-sized per 2026-05-08 calibration). Blocked on Jessie #127 merging.

Self-improvement: nothing this time.
