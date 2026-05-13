---
ts: 2026-05-13T01:28:49Z
kind: result
role: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/13/011500Z-dispatch-liaison-c273a7.md
  - entries/2026/05/13/005956Z-message-steward-aa32fc.md
  - entries/2026/05/13/004800Z-message-steward-f78473.md
  - entries/2026/05/13/000016Z-message-steward-cf7b09.md
---

# Per-PR roles ported from references/endo-but-for-bots/

Eight roles plus their cited skills are now active in the garden's
library. Inventory updated, steward's subordinate-roles list expanded,
COMMON.md's external-repo etiquette gained per-role authorization notes.
A new bulletin section enumerates the 17 endo-but-for-bots items
waiting on these roles.

## Phase 1: roles and skills ported

Four commits on `main` (origin/main now at `8418896`):

- `74eee47` `roles: fixer + weaver`: fixer (review-feedback addressing,
  CI-green before re-request) and weaver (rebase / merge by reading
  both sides). Newly ported skills: rebase-before-followup,
  review-feedback-followup-commits, pr-review-thread-replies,
  yarn-lock-separate-commit, pre-pr-checklist, regression-evidence,
  ci-status-summary, conflict-resolution, cherry-pick-followup,
  worktree-per-pr, reactji-acknowledgment.
- `83b0390` `roles: shepherd + conductor`: shepherd (CI healing,
  red-CI gate before maintainer queue) and conductor (one-at-a-time
  merge-queue drain with merge-commit shape preserved). Newly ported
  skills: ci-runtime-comparison, rebase-hygiene-audit,
  process-documents.
- `45498d5` `roles: designer + scout`: designer (prompt-to-design
  expansion under the project's `designs/`) and scout (comparative
  microbenchmark for "but benchmark first" optimizations). Newly
  ported skills: prompt-section-discovery, benchmark-comparative-report.
- `27fda21` `roles: botanist + major-general`: botanist (single
  Dependabot PR verdict) and major-general (weekly direct-dep
  major-version scout, complement of botanist). Newly ported skills:
  verify-upstream-state-before-pinning, changeset-discipline.

Skills reused without re-porting: em-dash-style, relative-paths,
self-improvement, autonomous-loop-pacing.

Files written: 8 role `AGENT.md` plus 15 skill `SKILL.md`. All carry
YAML frontmatter (`created: 2026-05-13`, `updated: 2026-05-13`,
`author: liaison`) and an adoption note in the body. Em-dash sweep
clean across the new files. Role files were trimmed aggressively per
the brief's "Keep the role file *short*" guidance: each is roughly
1 to 2 screens, with operating norms and definition-of-done sections,
deferring procedural detail to the cited skills. Per-PR session lore
from the reference (the "encountered on PR <N>" gotchas) was elided;
the abstract rules survived. Those gotchas are recoverable from the
reference itself when a specific engagement needs them.

## Phase 2: inventory and orchestration

One commit on `main` (`8418896`):

- `CLAUDE.md` § Current inventory: roles list grew from 5 to 13
  (added the 8); skills list grew accordingly (added the 15 newly
  ported plus retained the 11 prior).
- `roles/steward/AGENT.md` § Subordinate roles dispatched: expanded
  to enumerate fixer, weaver, shepherd, conductor, designer, scout,
  botanist, major-general with the trigger condition for each (e.g.,
  fixer on `CHANGES_REQUESTED`; weaver on `CONFLICTING`; conductor
  on a non-empty merge queue). The prior "roles the steward will
  likely grow into" list was pruned to only the still-unported
  director / marshal / groom.
- `roles/COMMON.md` § External-repo etiquette: added a per-role note
  for each new role describing the kind of per-action upstream
  authorization the steward forwards (never originates). No standing
  authorizations were added to the bulletin's *Pre-staged
  authorizations* section per dispatch instructions.

## Phase 3: PR backlog bulletin section

One commit on `journal` (`6443798` after the rebase onto the remote
tip, originally authored as `367f9c7`):

- `journal/README.md`: new `### PR backlog` section between
  `Awaits maintainer review` and `Awaits maintainer decision`.
  Stable delimiter comments (`<!-- BEGIN pr-backlog -->` /
  `<!-- END pr-backlog -->`) mirror the `pending-kriskowal-reviews`
  pattern. 17 rows total: 15 open PRs plus 2 open issues, each
  formatted `- [endojs/endo-but-for-bots#<N>](<url>): <title>
  (waiting on: <role-or-condition>)`. Issues are labelled `(issue)`.
  Sources cited in the section's preamble.

## Out of scope, per dispatch

- Item 5 from `cf7b09` (archive prior `process/` tree on
  endo-but-for-bots@garden) skipped per maintainer direction.
- The 16 other roles in `references/endo-but-for-bots/roles/`
  (builder, cleaner, chronicler, scribe, triager, investigator,
  saboteur, juror, namer, stratego, director, marshal, groom,
  watchman-cadence, watchman-events, watchman-schedule) were not
  ported. No dependency surfaced during the ports that required
  any of them; the only forward-referenced one was the steward's
  "roles the steward will likely grow into" list, which now points
  at director, marshal, and groom as the remaining unported
  orchestration set.

## Self-improvement

`skills/process-documents/SKILL.md` and `skills/worktree-per-pr/SKILL.md`
are the two skills that most needed reshape during the port: the
reference's process-documents skill assumed a fork-side `process/`
tree as the canonical surface, but in this garden the journal carries
most of that surface (per the prior steward's migration in `cf7b09`);
the reference's worktree-per-pr assumed a long-lived `~/endo-wt/pr-<N>`
worktree shared across builder / fixer / conductor, but this garden's
per-dispatch worktree triple creates a fresh `project/` per dispatch.
Both skill files now name the divergence explicitly in their adoption
notes. Captured for the liaison: per-PR continuity in this garden
lives in the journal index entry at `journal/worktrees/<host>/<name>.md`,
not in the worktree's directory contents. A future port (or refactor)
should preserve that distinction.

Self-improvement: skills/worktree-per-pr/SKILL.md,
skills/process-documents/SKILL.md; reshape needed during port because
this garden's per-dispatch worktree triple and journal-side process
surface differ from the reference's long-lived per-PR worktree and
fork-side `process/` tree.
