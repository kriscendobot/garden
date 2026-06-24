---
ts: 2026-06-02T21:25:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriskowal/garden
project: garden
to: gardener
dispatch_root: /home/kris/dispatches/gardener--beff56
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: motivating-incident
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/351 (inline 20:45:07Z)
---

# dispatch: gardener — encode "avoid Latin shorthand" norm per kriskowal #351

kriskowal review at 20:45:07Z on endo-but-for-bots#351 (inline on
`packages/compartment-mapper/src/link.js` line 73): "Please avoid Latin.
Dispatch to gardener to improve style guide."

The fixer half landed the immediate code fix at fixer 093367 (`cf.` →
`See` on the cited line plus a whole-file scan). This dispatch executes
the gardener half: encode the norm in the garden's writing conventions
so future bot-authored prose avoids the same shorthand.

## What to land

A short skill at `skills/no-latin-shorthand/SKILL.md` (or similar
placement that fits the garden's existing skill-name conventions like
`skills/em-dash-style/` and `skills/relative-paths/`). The skill should:

1. State the norm: avoid Latin shorthand in prose, comments, design
   documents, and PR bodies. Use English equivalents.
2. List concrete shorthands to avoid with English replacements:
   - `cf.` → "See" / "Per"
   - `i.e.` → "that is"
   - `e.g.` → "for example"
   - `etc.` → "and so on" / "and similar"
   - `et al.` → "and others"
   - `vs.` → "versus" / "compared to"
   - `viz.` → "namely"
   - `ad hoc` → "improvised" / "case-by-case" (or restructure)
   - `via` (borderline; acceptable as it's fully assimilated, but flag
     for awareness)
3. Cite the motivating incident: endo-but-for-bots#351, kriskowal
   review 20:45:07Z.
4. Scope: this norm applies to bot-authored prose. Maintainer's own
   prose is not in scope. Existing prose with Latin shorthand is fixed
   on encounter, not via a sweep.

## Update inventory and conventions

After creating the skill:

- Add a one-line pointer to `CLAUDE.md`'s "Current inventory" skills
  list.
- If any existing convention doc (e.g. `roles/COMMON.md` or similar)
  has a "prose conventions" section, add a one-line cross-reference
  there too. If no such section exists, do NOT create one in this
  dispatch — leave it to a future garden-meta pass.

## Per-action authorizations

- Create `skills/no-latin-shorthand/SKILL.md`. Authorized.
- Edit `CLAUDE.md` to add the inventory pointer. Authorized.
- Edit existing convention docs only to add a one-line
  cross-reference. Authorized.
- Regular append push to garden's `main` branch (no PR for garden's
  own repo per `CLAUDE.md` convention). Authorized.

## Not authorized

- Sweeping existing files for Latin shorthand (fix on encounter, per
  scope).
- Creating new prose-conventions sections beyond the one-line
  cross-reference.
- Force-push.

## Dispatch protocol

Read in order:
1. `garden/roles/COMMON.md`
2. `garden/roles/gardener/AGENT.md`
3. Existing skill `garden/skills/em-dash-style/SKILL.md` for style
   conventions and skill-skeleton precedent.
4. Other skills just-in-time.

Garden worktree on `main` at `c6ad5dc4`.

## Report

A `result` journal entry. Include: created file path, file diff
summary, updated `CLAUDE.md` line(s), any cross-references added, and
the garden-main push outcome.
