---
ts: 2026-05-13T05:35:11Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/13/051029Z-dispatch-liaison-04526e.md
---

# Result: context-library and friends (tasks A through G)

Dispatch: [entries/2026/05/13/051029Z-dispatch-liaison-04526e.md](051029Z-dispatch-liaison-04526e.md). Single gardener engagement covering the maintainer's coherent design pass on agent-facing documentation.

## Files written

**Garden `main`** (pushed to `origin/main`):

- A1 `roles/gardener/AGENT.md`: new "Context management for new subagents" operating norm; cites the new context-library skill; author bumped to include gardener.
- A2 `skills/context-library/SKILL.md` (new): directory-as-hierarchy + abstract-at-the-top + exit-criteria conventions for agent-optimized journal context trees.
- B `roles/journalist/AGENT.md`: two new operating norms ("Topological sort" reminder and "Bulletin sections carry no procedural prose"). The matching prose strip on the journal-side bulletin sections is a separate commit.
- C `skills/journalism/SKILL.md` (new): user-of-the-journal manual (kinds, frontmatter, refs chains, grep recipes, projects/ index, inbox-drain shortcut).
- D `roles/librarian/AGENT.md` (new): read-only, walk-the-hierarchy answer-and-cite role; any agent can dispatch one.
- F `roles/scholar/AGENT.md` (new): autonomous index-grower for `journal/projects/`; idle-mode default cadence; maintainer-tunable. Also `roles/steward/AGENT.md` § Subordinate roles dispatched: scholar named as autonomous sibling.
- G `skills/dispatch-worktree/SKILL.md` (new) plus `git mv` of all five `scripts/<name>.sh` into their skill directories. Internal `GARDEN_ROOT` path in each moved script bumped from `../` to `../../`. Reference updates in every role and skill that cited the old paths: `CLAUDE.md`, `WORKTREES.md`, `roles/COMMON.md`, `roles/liaison/AGENT.md`, `roles/steward/AGENT.md`, `roles/monitor/AGENT.md`, `roles/review-queue/AGENT.md`, `skills/inbox-drain/SKILL.md`, `skills/monitor-garden/SKILL.md`, `skills/review-queue-poll/SKILL.md`, `skills/worktree-per-pr/SKILL.md`.
- H `CLAUDE.md`: inventory adds `librarian`, `scholar`, `context-library`, `journalism`, `dispatch-worktree`; § Dispatch contract script paths bumped. `WORKTREES.md` § Per-dispatch worktree triple cites the new skill.
- `skills/journal-sync/SKILL.md`: new Notes-from-the-field row dated 2026-05-13 on the sync-first ordering for multi-file journal edits (the failure mode the prior gardener `82b357` hit and this one `04526e` would have hit again).

**Journal**:

- E `projects/README.md` plus `projects/{endo,endo-but-for-bots,agoric-sdk,cosgov,garden}/README.md` (six files, all new): the seed of the per-project context tree. Each README's abstract is specific per the context-library discipline; topic files are intentionally absent (the scholar's job).
- B-bulletin + F-bulletin `journal/README.md`: bulletin sections reordered to start with *Pending kriskowal reviews*; procedural prose stripped from every section (heading + items + delimiter comments only); scholar kick-off row added to *Awaits maintainer decision*. Section bodies between the delimiters preserved byte-for-byte.
- `journal/worktrees/kmkmbp2021/boatman--ferry-syrups-109--20260513-013417--83172a.md`: body text bumped to reference the new `skills/dispatch-worktree/dispatch-teardown.sh` path.

## Commit SHAs

Garden `main` (pushed to `origin/main` on first attempt):

- `3b3966b` gardener: context-library responsibility for new subagents (A1)
- `62a4aab` context-library skill: agent-optimized hierarchical doc conventions (A2)
- `3305731` journalist: procedural matter to role; topo-sort emphasized (B)
- `2604791` journalism skill: how other roles find information in the journal (C)
- `69fff0b` librarian role: dispatch-on-demand journal search (D)
- `7b9f2d6` scholar role: autonomous index-growing for project documentation (F)
- `a782112` scripts: move into their relevant skill directories; dispatch-worktree skill (G1 + G2 combined)
- `874d56e` CLAUDE.md, WORKTREES.md: inventory + script-path updates (H)
- `e8f4dd1` journal-sync: notes-from-field row on sync-first ordering for multi-file edits

Journal (this entry's batch; push pending):

- `261d722` projects: index + per-project READMEs for the five seed projects (E)
- `634dc0e` bulletin: reorder sections; drop procedural prose; scholar kick-off row (B-bulletin + F-bulletin)
- this entry — result

## Note on the dispatch-worktree scripts

The moved scripts adjust `GARDEN_ROOT` internally for the deeper path (`scripts/<name>.sh` → `skills/<skill>/<name>.sh`, so `dirname/..` becomes `dirname/../..`). The currently-running standing-monitor and review-queue daemons (PIDs in `/tmp/garden-monitor-*.pid` and `/tmp/garden-review-queue.pid`) still execute the old path from their `nohup` invocations and are not affected by the rename. The next steward liveness-check respawn picks up the new path from the updated `roles/steward/AGENT.md` § Standing monitors. Active restart is unnecessary per the dispatch instructions.

Self-improvement: this dispatch landed two structural lessons inline (sync-first ordering in `skills/journal-sync/SKILL.md`; scripts-into-skills as the canonical home for skill-implementing shell scripts), so no `message` to liaison is owed. One observation worth flagging for the maintainer: the `scripts/` directory was the natural home for cross-cutting helpers, and the reorganization scattered them across skill directories that an outsider would not search first; if a future skill-implementing script does *not* belong with any one skill (a cross-cutting helper that several skills depend on), the right answer is probably to keep a slim `scripts/` for that genuinely cross-cutting case rather than forcing a fit. None of the five scripts moved in this pass were cross-cutting; the reorganization is correct for them.
