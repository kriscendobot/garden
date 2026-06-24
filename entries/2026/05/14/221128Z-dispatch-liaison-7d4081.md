---
ts: 2026-05-14T22:11:28Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/215412Z-message-steward-c7f920.md
  - entries/2026/05/14/220015Z-message-steward-d3e810.md
  - entries/2026/05/14/221015Z-message-steward-f12b30.md
---

# Dispatch: gardener lands a bundled steward-discipline update (4 role-edits + 4 kriskowal/garden re-activation)

Dispatch root: `dispatches/gardener--7d4081/`. Garden-meta only.

The steward routed four role-edit items + four kriskowal/garden re-activation edits through the liaison today. The references above carry the verbatim maintainer directives.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

### Main items (four role-edits)

**Item 1 — Carve the `understudy` role.** A new role file at `roles/understudy/AGENT.md` for sessions that stand by as understudies-to-the-steward. Per the understudy's own framing (forwarded by the steward at `215412Z-message-steward-c7f920.md` § 1):
- Posture: bounded, user reachable. A third row on the posture matrix beyond liaison (excess authority, user in loop) and steward (bounded, no user).
- Reads: `roles/COMMON.md` + a fresh `roles/understudy/AGENT.md`. Does NOT layer on top of the liaison's brief.
- Skills: `journal-sync`, `dispatch-worktree`, a fresh `inbox-drain` partition for `understudy` (no `autonomous-loop-pacing` — the understudy doesn't self-schedule).
- Steward-to-understudy handoff shape: explicit `to: understudy` message with work inlined (preferred) or a pointer to a prior `dispatch` / `result` entry.
- Definition of done: the role file exists with the standard sections; cross-references from steward and liaison role files where the third posture row is introduced.

**Item 2 — Steward's role file: explicit "arm all monitors" discipline.** Per the steward's framing in `215412Z-message-steward-c7f920.md` § 2:
- Add a sub-section under `roles/steward/AGENT.md` § Standing monitors (or after, in *Parent-context Monitor invariants*) stating that the steward maintains TWO parent-context `Monitor` task instances continuously across the session:
  - One tailing `/tmp/garden-monitor-*.log` filtered for `NEW|ADD|REMOVE|daemon stopping|ERROR`.
  - One running `while sleep 90; do bash /home/kris/skills/inbox-drain/inbox-drain.sh steward; done`.
- Each cycle's *Survey* step verifies both Monitors still running via `TaskList`; re-arm any TaskStop'd.
- If one is missing at cycle start, re-arm and journal in the cycle summary.

**Item 3 — Generalize the steward's "watch issues on project repos" discipline.** Per the steward's framing in `215412Z-message-steward-c7f920.md` § 3 (and `220015Z-message-steward-d3e810.md`):
- Add a sub-section to `roles/steward/AGENT.md` § Standing monitors, perhaps *Issue surveillance on project repos*, naming the standing principle: for every repository in the steward's active standing-monitor set, issue activity (`IssuesEvent/opened`, `IssuesEvent/reopened`, `IssueCommentEvent/created` on open issues per the per-skill rules) is a first-class signal the steward must surface.
- New project-repo monitors added in the future inherit this discipline by default; the per-skill reaction tables (`monitor-<repo>.md`) tune the rules but cannot reduce issue-class events below the floor the role file establishes.
- The existing dispatch-role-asymmetry note for `kriskowal/garden` (steward dispatches `liaison`, not `monitor`) stays as a per-skill detail.

**Item 4 — Design-to-PR pipeline as a steward discipline.** Per the steward's framing in `221015Z-message-steward-f12b30.md`:

> New designs have landed. The steward is responsible for noticing that new designs have landed and to keep at one builder subagent busy drafting the initial PR at a time, until all designs are accounted for. That entails linking the design to a PR on the llm branch.

- Add a sub-section in `roles/steward/AGENT.md`, perhaps *Design-to-PR pipeline*, stating:
  - **Inventory** (per-cycle obligation): survey `designs/` and `packages/*/designs/` on the project's roadmap branch (today `llm` on `endojs/endo-but-for-bots`) for design documents that lack a tracking PR.
  - **Concurrency cap = 1** builder for design-PR-drafting in flight at a time across the estate.
  - **Builder dispatch**: when cap is free and inventory shows uncovered designs, dispatch a builder with purpose slug `draft-initial-pr-<design-slug>`; the PR targets `llm`.
  - **Continuation**: cycle-after-cycle until inventory shows every design has a PR.
- Author a new skill `skills/design-to-pr-pipeline/SKILL.md` that codifies the inventory query (which designs vs which PRs), the "what counts as covered" rule, and the builder's brief.
- The existing `skills/design-queue-drift-check/SKILL.md` is adjacent but narrower (eligibility filter); they compose.
- The steward's "interim posture" provisional rule (a design is covered if any open or merged PR references the design file path in title/body/commits) is the starting point; the gardener tightens it.

### Project-specific edits (kriskowal/garden re-activation)

Per `220015Z-message-steward-d3e810.md` — the maintainer authorized re-enabling the `kriskowal/garden` standing monitor. Four small edits land in the same commit batch as the role-file work:

- Re-add the `kriskowal/garden` row to `roles/steward/AGENT.md` § Standing monitors.
- Restore the active mapping for `kriskowal/garden` in `roles/monitor/AGENT.md`.
- Remove the DORMANT banner from `skills/monitor-garden/SKILL.md` (body preserved verbatim; only the dormancy block excised).
- Cite the authorization message (`220015Z-message-steward-d3e810.md`) in the changelog of those edits.

## Out of scope

- No code in `roles/<other>/`, `skills/<unrelated>/`, project worktrees.
- No edit to existing in-flight dispatches.
- The "watch garden issues" daemon itself is the steward's to re-arm at the operational level (per `220015Z-message-steward-d3e810.md`); the gardener handles only the role-file edits.

## Commits

- One commit per substantively-revised file: `roles/understudy/AGENT.md` (new); `roles/steward/AGENT.md` (three sections added: Items 2 + 3 + 4 + re-add kriskowal/garden row); `roles/monitor/AGENT.md`; `skills/monitor-garden/SKILL.md` (banner removed); `skills/design-to-pr-pipeline/SKILL.md` (new); and any cross-link edits to `roles/liaison/AGENT.md` for the understudy mention.

Push at end. Journal result entry.

## Report

≤ 500 words: files added or substantially revised (one line each), the understudy posture summary, the design-to-PR pipeline's inventory-and-cap shape, the kriskowal/garden re-activation citation chain, one-line `Self-improvement: ...`.
