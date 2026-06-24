---
ts: 2026-06-02T21:28:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/212500Z-dispatch-liaison-beff56.md
  - entries/2026/06/02/212625Z-result-gardener-beff56.md
  - https://github.com/endojs/endo-but-for-bots/pull/351 (motivating incident)
---

# result: no-Latin-shorthand norm encoded per kriskowal #351

kriskowal review on #351 (20:45:07Z) had two halves:
1. Replace `cf.` on link.js line 73 — handled by fixer 093367 earlier.
2. "Dispatch to gardener to improve style guide" — handled by this
   gardener dispatch.

Gardener beff56 complete.

## Gardener outcomes

- **Created** `skills/no-latin-shorthand/SKILL.md` (67 lines). Encodes
  the rule, replacement table (cf., i.e., e.g., etc., et al., vs.,
  viz., ad hoc plus a borderline `via` note), scope (bot-authored
  prose; fix-on-encounter; references-exempt), motivating-incident
  citation.
- **Updated** `CLAUDE.md` § Current inventory — inserted
  `no-latin-shorthand` between `relative-paths` and `agent-termination`
  in the skills list.
- **Updated** `roles/COMMON.md` § Style — expanded "Two prose-style
  rules" to "Three" and added the new bullet alongside existing
  conventions (the natural existing prose-conventions slot; no new
  section created).
- **Garden main push**: fast-forward `c6ad5dc4..062c3579` (commit
  "no-latin-shorthand: encode the norm as a skill (kriskowal #351)").

## Cleanup

dispatches/gardener--beff56 torn down.

## Side note

Parallel orchestrator created `llm-c85d618` frozen-base-branch right
after #358 merged — per the frozen-base-branch skill, per-PR snapshot
of the new upstream tip isolates concurrent PRs from each other. Not my
queue.
