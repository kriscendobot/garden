---
gate: orchestrated
orchestrated_by: reorg-context-library-batch-1
priority: normal
posted_by: producer
posted_at: 2026-08-13T22:08:02Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# reorg-skill-local-verify

## Context

Flagged by the focused context-graph size audit
(`journal/reports/context-graph-size-audit-focused-2026-08-13.md`) as the
largest main2 skill file: `skills/local-verify/SKILL.md`, 557 lines / ~34.5 KiB,
14 level-two sections.

**Important constraint** — unlike `context/` and journal-tree docs,
[context-library](skills/context-library/SKILL.md) explicitly does NOT apply its
directory-split discipline to role/skill files: "Role and skill files in the
garden library (main2) ... their layout is fixed by the library README; this
skill does not retroactively reshape them." A `SKILL.md`'s required shape
(purpose, inputs, state, procedure, output shape, notes — `CLAUDE.md` § Adding a
skill) stays a single file. Do **not** turn this into a multi-file directory
split the way a `context/` doc would be.

## Task

1. **Read the file** and assess it against two, not one, remedies:
   - **Tighten in place.** Some of the 14 sections may simply be verbose —
     cut repetition, compress prose, move examples to be more concise —
     without losing information a claiming agent needs.
   - **Factor supplementary material into a linked sibling file**, the same
     shape `skills/agoric-chain-snapshot/repro` already uses: a `SKILL.md`
     that keeps its required top-level shape and stays the entry point, with
     one or more reference-only files alongside it
     (e.g. `skills/local-verify/pitfalls.md`,
     `skills/local-verify/debugging-contract.md`) that `SKILL.md` links to for
     the deep-dive material. Candidates worth weighing for this treatment,
     by section: `Pitfalls`, `Notes from the field`, `The debugging-agent
     contract (selective inspection)`, and the detailed `Tests` walkthrough —
     these read as reference material a claiming agent consults on demand,
     not the procedure itself.
   - Use judgment on the mix; the goal is a `SKILL.md` a claiming agent can
     skim end-to-end quickly, with deep-dive material one link away rather
     than inline.
2. Keep every cross-reference from other roles/skills into
   `skills/local-verify/SKILL.md` working (grep for inbound links before and
   after).
3. Note in the completion report which sections you tightened versus factored
   out, and the before/after line count.

## Notes

- No PR needed; land directly on `main2` per `CLAUDE.md` § Conventions.
- House style: [em-dash-style](skills/em-dash-style/SKILL.md),
  [relative-paths](skills/relative-paths/SKILL.md),
  [no-latin-shorthand](skills/no-latin-shorthand/SKILL.md).
- This is a child of the `reorg-context-library-batch-1` orchestration; report
  through the normal job-board completion, no separate coordination needed.
