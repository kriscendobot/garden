---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# context-graph-size-audit

## Task

The garden's context-graph design invariant (`CLAUDE.md`): starting from `CLAUDE.md`
(and `AGENTS.md`) the reachable set of docs should be a graph of small,
abstract-routed documents (see `skills/context-library/SKILL.md`), not a few
long ones. Build and run automation that checks this invariant is holding.

Generate a script (living under `scripts/`, alongside the other audit tooling —
`scripts/jobs/library-link-check.sh` is the nearest precedent, though this new
tool is a read-only report generator, not a job-system gate) that:

1. **Walks the context graph** starting from the root `CLAUDE.md` (and
   `AGENTS.md`, if it differs) as roots, following markdown links (relative
   paths, `[text](path)`) to build the reachable set. Roots on `main2`:
   `CLAUDE.md`, `README.md`, `WORKTREES.md`, `roles/*/AGENT.md`,
   `roles/jurors/*/AGENT.md`, `roles/COMMON.md`, `skills/*/SKILL.md`,
   `designs/*.md`, `context/**/*.md`. Roots on `journal2` (the `journal/`
   worktree): `journal/README.md` and everything it reaches under
   `journal/projects/**`, `journal/library/**` (respecting that
   `journal/library/sections/README.md` is a large auto-generated flat index —
   classify it but don't flag it as a hand-authored overgrown doc), and any
   other journal context tree reachable via README links.
2. **Classifies each reachable document by size** (line count and byte size).
3. **Flags candidates for reorganization**: documents that are large relative
   to their siblings/peers in the same tree, or that mix several distinct
   topics under one file (a quick heuristic — many top-level `##` sections is
   a signal — is fine; this doesn't need to be perfect). Use judgment for the
   threshold; the [context-library](skills/context-library/SKILL.md) skill's
   "prefer many small files to one long file" section is the standard to
   classify against, but does not name a hard line-count cutoff, so pick and
   state a reasonable one (and note it in the report).
4. Also worth noting, if cheap to compute: any doc *not* reachable from the
   roots at all (an orphan) — useful signal for a stale or disconnected file,
   even though the primary ask is the size classification of reachable docs.

## Output

- Run it, and land the resulting report as a durable file — a good home is
  `journal/reports/context-graph-size-audit-<date>.md` (journal report
  precedent: `journal/reports/kimi-k3-credit-exhaustion-20260730.md`), landed
  through `scripts/jobs/land-journal-edit.sh` per the journal editing
  convention (see any role that lands journal content, e.g.
  `roles/scholar/AGENT.md` § *Land content edits through the lander*).
- The report should list, per tree (main2 role/skill library vs. each journal
  context tree), the largest N documents by line count with their path and
  size, plus the flagged reorg candidates and why each was flagged.
- Complete the job with a short summary: how many documents were walked, how
  many flagged, and the report's path.

## Notes

- This is a one-off "build and run it once" ask, not a request to wire it into
  a recurring schedule — leave that as a suggestion in the report's closing
  line if the tool seems worth running periodically (`skills/schedule/SKILL.md`
  is the mechanism), but don't set up the schedule yourself.
- House style on anything you write: [em-dash-style](skills/em-dash-style/SKILL.md),
  [relative-paths](skills/relative-paths/SKILL.md),
  [no-latin-shorthand](skills/no-latin-shorthand/SKILL.md).
- No PR is needed — this is a change to the garden's own repo/journal, pushed
  directly per `CLAUDE.md` § Conventions.
