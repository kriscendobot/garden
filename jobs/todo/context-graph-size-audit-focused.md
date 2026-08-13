---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# context-graph-size-audit-focused

## Context

Follow-up to `context-graph-size-audit` (landed `journal/reports/context-graph-size-audit-2026-08-13.md`,
tool at `scripts/context-graph-size-audit.py` on main2). The maintainer's
feedback on the first run: large `designs/*.md` documents are not frequently
reused context (they're one-shot rationale docs, read once at design time, not
re-hydrated repeatedly the way `roles/`, `skills/`, `context/`, and
`journal/library/` are) and shouldn't be in scope for a reorganization pass.
Re-run scoped down to just the frequently-reused trees: **library, context,
roles, and skills** — drop `designs/*.md` from the main2 roots and drop the
`journal/projects/` tree from the journal2 walk (the maintainer named library,
not projects).

## Task

1. **Extend `scripts/context-graph-size-audit.py`** with a general way to
   scope a run, rather than hand-editing the hardcoded root list for this one
   ask (future re-scoped runs will want the same knob):
   - a repeatable `--exclude-root-glob <pattern>` to drop main2 roots matching
     a glob (e.g. `designs/*.md`) before the graph walk, and
   - a repeatable `--exclude-journal-seed <path>` to drop a journal2 seed
     (e.g. `projects/README.md`) so the walk doesn't start from it.
   Keep the existing default behavior (no excludes) unchanged when the flags
   are omitted, so the original full audit remains reproducible.
2. **Run it** with `--exclude-root-glob 'designs/*.md' --exclude-journal-seed
   'projects/README.md'`, keeping every other default root: `CLAUDE.md`,
   `AGENTS.md`, `README.md`, `WORKTREES.md`, `roles/*/AGENT.md`,
   `roles/jurors/*/AGENT.md`, `roles/COMMON.md`, `skills/*/SKILL.md`,
   `context/**/*.md` on main2, and `README.md` + `library/README.md` (and
   whatever they transitively reach) on journal2.
3. **Land the new report** as `journal/reports/context-graph-size-audit-focused-<date>.md`
   (do not overwrite the earlier full-scope report; this is a distinct,
   narrower companion) through `scripts/jobs/land-journal-edit.sh`, same as
   the prior run.
4. Complete the job with a short summary (documents walked, candidates
   flagged, report path) and the exact report path so the URL can be handed
   back.

## Notes

- Same house style as before: [em-dash-style](skills/em-dash-style/SKILL.md),
  [relative-paths](skills/relative-paths/SKILL.md),
  [no-latin-shorthand](skills/no-latin-shorthand/SKILL.md).
- No PR needed; this is a change to the garden's own repo/journal, pushed
  directly per `CLAUDE.md` § Conventions.
- Still a one-off run, not a schedule.
