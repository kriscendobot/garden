---
ts: 2026-05-13T00:00:16Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
---

# Hand-off received from prior endo-but-for-bots steward — migration index

A prior generation of the garden ran an autonomous steward against
`endojs/endo-but-for-bots`, accumulating per-cycle process state under
`process/` on that repository's `garden` branch. The maintainer asked
the current generation's steward to migrate that state into this
garden's journal in its entirety, including a forward tracking surface
for scheduled work.

Source: `endojs/endo-but-for-bots` `garden` branch at
`cc79140a6723d76c89197a237919f3063be1f155` (commit subject
"process: designer/builder notes — mermaid diagrams + prettier on
Markdown (per kriskowal #165 review)"). Worktree on this host:
`worktrees/endojs-endo-but-for-bots.git` (bare clone). The garden
branch was fetched fresh for this migration.

## What was migrated

The prior process tree had eighteen files. Each is mirrored verbatim
into its own journal entry below; this entry is the index. Cross-refs
are by entry path so a grep on `project: endo-but-for-bots` finds the
whole batch, and `refs:` walks the package as a graph.

### Forward state (load-bearing for the next cycle)

| Source file | Mirror entry | Notes |
|---|---|---|
| `process/STEWARD-HANDOFF-2026-05-11.md` | [`000020Z-message-steward-afa436.md`](000020Z-message-steward-afa436.md) | The session-ending hand-off doc with 24 in-flight directives. Read this first. |
| `process/STEWARD-STATE-2026-05-10.md` | [`000030Z-message-steward-9a0c4c.md`](000030Z-message-steward-9a0c4c.md) | Older snapshot, superseded by the 05-11 hand-off but kept for historical context. |
| `process/scheduled-engagements.md` | [`000040Z-message-steward-54f6f4.md`](000040Z-message-steward-54f6f4.md) | The watchman-schedule's calendar index; one row (2026-05-17 major-general sweep). |
| `process/dependabotany.md` | [`000050Z-message-steward-e08492.md`](000050Z-message-steward-e08492.md) | Botanist verdict ledger; six MERGE-NOW awaiting manual maintainer merge plus one REJECT. |
| `process/major-generalship.md` | [`000100Z-message-steward-d95cb2.md`](000100Z-message-steward-d95cb2.md) | Per-package upgrade scout ledger; next sweep date 2026-05-17. |
| `process/GROOM-OPEN-QUESTIONS.md` + `process/GROOM-ANSWERS.md` | [`000110Z-message-steward-67c92f.md`](000110Z-message-steward-67c92f.md) | Two open-questions from 2026-05-05 grooming pass plus the maintainer's directives. |
| `process/tracking/120.md` | [`000120Z-message-steward-6ff168.md`](000120Z-message-steward-6ff168.md) | Issue #120 (review-priority dashboard) liaison posture file. |
| `process/tracking/README.md` | [`000130Z-message-steward-4728a3.md`](000130Z-message-steward-4728a3.md) | Tracking-dir convention doc (one file per open liaison-tracked issue). |
| `process/README.md` | [`000140Z-message-steward-f5707d.md`](000140Z-message-steward-f5707d.md) | Process-directory index as the prior steward maintained it. |

### Rolling steward state

| Source file | Mirror entry | Notes |
|---|---|---|
| `process/PR-DISPATCH-STATE.md` | [`000200Z-message-steward-1bfc1c.md`](000200Z-message-steward-1bfc1c.md) | Per-cycle PR snapshot; the prior steward rewrote it each conductor cycle. ~49 KB. |
| `process/PR-CYCLE-LOG.md` | [`000210Z-message-steward-2ed7c3.md`](000210Z-message-steward-2ed7c3.md) | Append-only steward cycle log. |

### Audit and curation snapshots

| Source file | Mirror entry | Notes |
|---|---|---|
| `process/AGENT-READY-ISSUES.md` | [`000300Z-message-steward-169d63.md`](000300Z-message-steward-169d63.md) | 2026-04-28 triager snapshot of agent-ready issues with implementation plans. |
| `process/TRIAGE.md` | [`000310Z-message-steward-a143b6.md`](000310Z-message-steward-a143b6.md) | 2026-04-26 triager snapshot of likely-landed / superseded open issues + PRs. |
| `process/DESIGNS-WITHOUT-PR.md` | [`000320Z-message-steward-e8e8bb.md`](000320Z-message-steward-e8e8bb.md) | 2026-05-01 designs/* gap report (designs that lack a tracking PR). |
| `process/PR-REBASE-AUDIT.md` | [`000330Z-message-steward-d95cb3.md`](000330Z-message-steward-d95cb3.md) | 2026-04-30 shepherd snapshot of which PRs need rebase. |
| `process/ROLES-SKILLS-AUDIT.md` | [`000340Z-message-steward-4728a4.md`](000340Z-message-steward-4728a4.md) | Roles/skills audit from the prior garden. |
| `process/UNLINKED-TODOS.md` | [`000350Z-message-steward-f5707e.md`](000350Z-message-steward-f5707e.md) | 2026-05-01 investigator hygiene scan with proposed-issue draft. ~133 KB. |

## Scheduled-work tracking, going forward

The user explicitly asked for tracking of scheduled work to come along.
The prior garden's `process/scheduled-engagements.md` is the
forward-state source. To make that surface visible to a steward cycle
in the current garden idiom, I am adding a **Scheduled engagements**
section to the bulletin board in `journal/README.md`, seeded with the
single live row carried over (2026-05-17 weekly major-general sweep).
Future per-cycle steward closes should treat that section the same way
they treat the other bulletin sections: post when an item arises, clear
when the underlying engagement has been fulfilled.

The watchman-schedule role from the prior garden (whose job was to
regenerate the index from per-source process docs at each cycle's
close) is not present in this garden's active library; the steward's
loop and wakeup standing instructions also still live in `references/`
pending a liaison port (see the cadence research dated 2026-05-12 in
the prior session's conversation). Until those land, the steward
manually reads the Scheduled engagements bulletin and dispatches the
relevant role on the engagement date.

## Action items routed to the liaison

These are items the steward cannot act on alone:

1. **Port the cadence / loop standing instructions** from
   `references/endo-but-for-bots/roles/watchman-cadence.md` and
   `references/endo-but-for-bots/skills/autonomous-loop-pacing.md` into
   `roles/steward/AGENT.md`. The prior session captured what needs
   porting (the `<<autonomous-loop-dynamic>>` prompt, cache-window
   delay rules, active-vs-idle mode triggers, hard 9-hour upper
   bound, cycle-close gate). Currently step 7 of the steward's role
   says only "schedule a next fire" with no cadence guidance.

2. **Decide whether to canonize the Scheduled engagements bulletin
   section.** I am adding it as a steward bulletin extension to make
   the migrated 2026-05-17 row visible. If the liaison prefers a
   different surface (e.g., a `journal/scheduled/` directory, or a
   watchman-schedule port), let me know and I will move it.

3. **Decide which prior-garden roles to port into the active
   library.** The hand-off references `director`, `marshal`, `groom`,
   `conductor`, `shepherd`, `weaver`, `botanist`, `major-general`,
   plus the three watchmen. The current active set is
   `liaison / steward / monitor / boatman`. Until the per-PR roles
   exist here, the prior steward's per-PR dispatches in the hand-off
   cannot be re-dispatched by this steward; they remain in the
   journal as historical record. If kriskowal wants the per-PR work
   to keep moving, role porting is the gating step.

4. **Decide what to do with the 24 in-flight directives in the
   hand-off**. Each has a maintainer-facing status (re-review
   pending, kriskowal pick awaited, CI verification needed, etc.).
   The steward cannot dispatch builders/fixers/conductors without
   the corresponding roles, so the practical near-term move is to
   surface them to the maintainer through the bulletin board so
   they are not silently dropped. I will do this in a follow-up
   pass once the verbatim entries are committed (so the bulletin
   lines have something to reference).

5. **Decide whether to mark the prior `process/` tree as archived
   on `endojs/endo-but-for-bots` `garden`**, since the canonical
   forward state now lives in this journal. If yes, a future boatman
   or a maintainer push can add a `> Migrated to garden journal
   2026-05-13` banner to each file.

## Self-improvement

Migration of this size revealed that the journal has no convention for
embedding a multi-document hand-off. I am routing each prior doc to
its own entry under one project slug rather than concatenating, which
keeps individual entries grep-friendly and keeps any future
incremental update self-contained. If the liaison wants a different
shape (concatenated, or a dedicated `projects/<slug>/` subdirectory),
that is the meta-evolution to propose.

Self-improvement: nothing this time on the role file directly; the
shape question is routed to the liaison above.
