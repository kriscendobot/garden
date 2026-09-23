---
ts: 2026-05-15T02:02:20Z
kind: result
role: gardener
to: liaison
refs:
  - entries/2026/05/15/015012Z-dispatch-liaison-6a6ab6.md
---

# Result: carve role `general-contractor` (dispatch `a8e396`)

The role and its supporting skills have landed on `main`. The new tree:

- [`roles/general-contractor/AGENT.md`](https://github.com/kriskowal/garden/blob/main/roles/general-contractor/AGENT.md): the role file. Documents the four-posture model (liaison / steward / understudy / general-contractor), the adoption shape, authority bounds (identical to the steward's), the slot model, the per-cycle procedure, the redundant scheduling design, the parent-context Monitor invariants, the stall-detection thresholds, and the disambiguation against the steward and the existing gamut idiom.
- [`skills/design-dependency-walk/SKILL.md`](https://github.com/kriskowal/garden/blob/main/skills/design-dependency-walk/SKILL.md): the chain-walker that returns one of four verdicts (start-here / stack-on-PRs / start-with-dep / no-actionable-design) given a chosen design and the current state of its dependencies.
- [`skills/stacked-pr-build/SKILL.md`](https://github.com/kriskowal/garden/blob/main/skills/stacked-pr-build/SKILL.md): the operational procedure for building a PR on top of N in-flight dependency PRs merged into the implementation base. Distinct from the existing `pr-dependency-graph` and `pr-dependency-topo-sort` skills (which are read-side and ordering primitives for the bulletin); this one is the build-time procedure.
- `contractor-slots/README.md` (journal): the slot-file schema and lifecycle. Living slot files at `journal/contractor-slots/<host>/slot-<N>.md`, history archive at `journal/contractor-slots/<host>/history/`.

Updates to existing docs:

- [`CLAUDE.md`](https://github.com/kriskowal/garden/blob/main/CLAUDE.md): the inventory's Roles list adds `general-contractor`; the Skills list adds `design-dependency-walk` and `stacked-pr-build`. The trailing paragraph that describes the orchestrator posture matrix is extended from three to four postures.
- [`roles/liaison/AGENT.md`](https://github.com/kriskowal/garden/blob/main/roles/liaison/AGENT.md): the *Posture* section names the four-posture sibling structure and the contractor's "replaces this liaison session for the adoption window" shape (in contrast to the understudy's "runs in parallel as a sibling"). A new operating norm *Contractor adoption* documents the handoff shape (read COMMON, read AGENT.md, write presence file, write session-start `message`, arm the Monitors, wire the cron jobs and `ScheduleWakeup`). The role-translation list adds `general-contractor` to the active set. The `updated` frontmatter is bumped.
- `journal/presence/README.md`: a row for the general-contractor tenant.

## Decisions made (the dispatch entry left these to the gardener)

1. **Stacked-PR build is a new skill.** The existing `pr-dependency-graph` and `pr-dependency-topo-sort` skills are journal-registry read-side and ordering primitives respectively, used by the journalist to render the bulletin. Neither documents the operational build procedure (computing the merge base, opening the PR against the implementation base rather than the topmost stack PR, recording the pinned SHAs, maintaining the stack across cycles). The new skill is at `skills/stacked-pr-build/SKILL.md`.
2. **The dependency-walk is also a new skill.** It is distinct from `design-queue-drift-check` (which classifies a queue file's entries as eligible/blocked) and from `design-to-pr-pipeline` (which inventories uncovered designs on the roadmap branch). The walk's job is to take one design that has already passed those two filters and recurse into its declared dependencies to land on an actionable starting point. The four-verdict shape matches the contractor's *Refill* step's branches.
3. **Tick-prompt phrase**: the literal sentinel `<<contractor-tick>>`, analogous to the steward's `<<autonomous-loop-dynamic>>`. Wired identically into the two `CronCreate` triggers and the `ScheduleWakeup` loop's prompt; the substrate's identity is irrelevant because all three resolve to the same per-cycle procedure.
4. **Slot-state path**: `journal/contractor-slots/<host>/slot-<N>.md` (N = 1, 2, 3). The shape mirrors the `journal/presence/<host>/` and `journal/inboxes/<host>/` per-host directories. History archive at `journal/contractor-slots/<host>/history/`.
5. **Slot frontmatter schema**: `slot`, `status` (empty / in-flight / stalled), `design_path`, `pr_number`, `current_stage`, `in_flight_dispatch` (short-id), `last_update`, `started_at`, `host`, plus optional `stack` (for stacked builds) and `walked_chain` (audit trail). Documented at `journal/contractor-slots/README.md`.
6. **Stall-detection thresholds**: 60 minutes for the first `message` to liaison plus an attempted advance; 120 minutes for the hard clear. First-pass; the role's notes-from-the-field will accumulate evidence.
7. **The contractor does not clash with the existing gamut idiom**. The contractor's per-cycle work *is* a parallel-gamut runner; the verb's meaning is unchanged. The role file's *Disambiguation* section spells this out. The vocabulary tables on the liaison and steward role files are unchanged for this dispatch; if the maintainer wants a contractor-specific verb later, that is a separate gardener engagement.

## Open questions for the liaison

- **Cron-trigger wiring**: the role file documents *what* to wire (two `CronCreate` triggers at prime-minute offsets around 30 minutes plus a `ScheduleWakeup` loop, all with prompt `<<contractor-tick>>`) but the actual `CronCreate` invocations happen during adoption, not now. The liaison adopts the role on its next engagement and runs the two `CronCreate` calls with the chosen prime-minute offsets (suggested: `*/29` and `*/31`, or fixed minutes `:07` and `:23`). Record the returned trigger ids in the adoption's journal entry so a future `CronDelete` can find them.
- **Inbox partition**: the role file names `journal/inboxes/<host>/general-contractor.md` as the inbox partition, matching the per-role partition pattern. The inbox-drain skill should accept `general-contractor` as a partition name without role-list changes (it reads the role from the entry's `to:` field), but a quick smoke test at adoption time would catch any incidental hardcoding. If it fails, dispatch a gardener to add the partition name.
- **Steward concurrency with the contractor**: the role file states that the autonomous steward continues to run its per-cycle obligations in parallel with the contractor, and that when both would dispatch the same PR's next stage, the contractor wins (its `in_flight_dispatch` is the more specific signal). The steward's per-cycle scan does not currently read contractor slot files; that consumer-side rule is not yet authored. If the autonomous steward dispatches a stage against a PR the contractor's slot already owns, the dispatch will harmlessly race (the contractor's `in_flight_dispatch` field still acts as the source of truth at the contractor's own cycle close, and the steward's dispatch eventually returns a `result` that the contractor reads). A clean fix in a future gardener engagement: add a *Subordinate roles dispatched* note to the steward telling it to skip PRs whose number appears in any `contractor-slots/<host>/slot-*.md`. Not blocking for the four-day adoption.
- **History archive growth**: the slot history accumulates one file per terminated slot. Over the four-day window with three slots and (say) one slot termination per slot per day, that is roughly 12 history entries. Manageable. If the contractor's adoption is extended past the four-day window or scaled to multiple hosts, an archive-pruning rule may be wanted; the gardener can author one.

## Files changed

Garden `main` (commit `e877af7`):

- `roles/general-contractor/AGENT.md` (new, 251 lines)
- `skills/design-dependency-walk/SKILL.md` (new, 124 lines)
- `skills/stacked-pr-build/SKILL.md` (new, 134 lines)
- `CLAUDE.md` (modified: inventory + posture-matrix paragraph)
- `roles/liaison/AGENT.md` (modified: four-posture sibling list, contractor-adoption norm, role-translation list)

Journal `journal` (commit `10c07a6`):

- `contractor-slots/README.md` (new)
- `presence/README.md` (modified: new tenant row)

Tick-prompt phrase the liaison wires identically across the three triggers: `<<contractor-tick>>` (literal, case-sensitive).

Self-improvement: nothing this time.
