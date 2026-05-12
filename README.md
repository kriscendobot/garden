---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Garden journal

This is the orphan `journal` branch of `kriskowal/garden`. The garden's transcript and message bus lives here: append-only entries under [`entries/`](entries/), the cross-machine worktree index under [`worktrees/`](worktrees/), and this file is the maintainer dashboard.

The schema for journal entries and the writing procedure live in `roles/COMMON.md` § The journal on the `main` branch.

## Bulletin board

Items here need a human maintainer's attention. Newest at top within each section. **Clear an item by editing this file (delete the line or mark it `[handled <YYYY-MM-DD>]`) and pushing the change back.** Agents post here; the maintainer clears.

### Awaits maintainer review

(none)

### Awaits maintainer decision

(none)

### Surplus authority discovered

The steward writes here when it finds itself able to do something its authority bounds forbid. See `roles/steward/AGENT.md` § Authority enforcement on the `main` branch.

(none)

### Pre-staged authorizations

The maintainer (or the liaison after maintainer confirmation) may pre-stage `identity_switch_authorized` for boatman handoffs and per-action cross-repo authorizations for any role. The steward forwards staged authorizations into the relevant dispatch prompt; entries here are cleared after the gated dispatch happens. See `roles/COMMON.md` § External-repo etiquette on the `main` branch.

(none)

## Ongoing work

### Active worktrees

Full index at [`worktrees/README.md`](worktrees/README.md). Currently active or reserved:

(no active or reserved worktrees right now; one `idle` integration scratch worktree exists, see the index for details)

### Open monitors

(none running yet)

### Recent activity

For the flat chronological view, run `git log` on this branch or browse [`entries/`](entries/) by date.

## Maintenance

- **Bulletin items** may be posted by any agent via `skills/journal-sync/SKILL.md` (on the `main` branch). The maintainer clears handled items.
- **Ongoing work** sections are kept current by the steward (during its per-cycle close) and by the liaison (when it does worktree-manager work). Subagents do not update these sections directly; they post `message` entries to `entries/` that the orchestrator promotes here when warranted.
- **Schemas** for entries and for worktree index files live in `roles/COMMON.md` (on the `main` branch) and in [`worktrees/README.md`](worktrees/README.md) respectively.
