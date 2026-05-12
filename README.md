---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Garden journal

This is the orphan `journal` branch of `kriskowal/garden`. The garden's transcript and message bus lives here: append-only entries under [`entries/`](entries/), the cross-machine worktree index under [`worktrees/`](worktrees/), and this file is the maintainer dashboard.

The schema for journal entries and the writing procedure live in `roles/COMMON.md` § The journal on the `main` branch.

## Bulletin board

Items here need a human maintainer's attention. Newest at top within each section. **Agents own the bulletin entirely: they post when something needs maintainer attention and they clear the item once they detect the underlying condition is resolved.** The maintainer never edits this section. Read it, then act in the natural place (review the PR on GitHub, comment on the issue, fix the deployment); the next steward cycle picks up the change and clears the bulletin item.

If a posted item lingers because its resolution is hard to detect automatically, that itself is worth flagging in the next agent's report or as a self-improvement update to the relevant skill.

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

### Pending kriskowal reviews

PRs across all visible repos where `kriskowal` is currently a requested reviewer. The [review-queue](../roles/review-queue/AGENT.md) role on the `main` branch rewrites the body of this section between the delimiters below whenever its daemon reports an ADD or REMOVE. Order is the three-tier rule documented in `roles/review-queue/AGENT.md` § Priority and ordering: (1) ball-back-in-your-court (kriskowal's prior `CHANGES_REQUESTED` followed by a push), (2) explicit re-request, (3) fresh request newest first, with draft PRs grouped at the bottom within each tier. The maintainer reviews the PR on GitHub; the next review-queue cycle picks up the resolution and removes the line.

<!-- BEGIN pending-kriskowal-reviews -->
(none)
<!-- END pending-kriskowal-reviews -->


## Ongoing work

### Active worktrees

Full index at [`worktrees/README.md`](worktrees/README.md). Currently active or reserved:

- `endolinbot`: 4 active standing monitors (`watch-endo`, `watch-endo-but-for-bots`, `watch-agoric-sdk`, `watch-cosgov`) on `endojs/endo`, `endojs/endo-but-for-bots`, `agoric/agoric-sdk`, `dcfoundation/cosmos-proposal-builder` respectively.
- `kmkmbp2021`: 1 idle integration scratch worktree (`integrate--liaison--20260512-194515`), see the index.

### Open monitors

`endolinbot` runs 5 long-lived poll daemons via the steward's standing-monitors discipline (see `roles/steward/AGENT.md` § Standing monitors on the `main` branch). Cadences: `endo` 60s, `endo-but-for-bots` 30s, `agoric-sdk` 60s, `cosgov` 60s, `review-queue` 120s. PIDs and logs in `/tmp/garden-monitor-*.{pid,log,err}` and `/tmp/garden-review-queue.{pid,log,err}`.

### Recent activity

For the flat chronological view, run `git log` on this branch or browse [`entries/`](entries/) by date.

## Maintenance

- **Bulletin items**: posted *and cleared* by agents via `skills/journal-sync/SKILL.md` (on the `main` branch). The steward typically clears items during its per-cycle close, by re-checking each item's underlying condition (was the PR reviewed? was the decision made? was the staged authorization forwarded?) and dropping items whose condition is resolved. The maintainer never edits the bulletin.
- **Ongoing work** sections are kept current by the steward (during its per-cycle close) and by the liaison (when it does worktree-manager work). Subagents do not update these sections directly; they post `message` entries to `entries/` that the orchestrator promotes here when warranted.
- **Schemas** for entries and for worktree index files live in `roles/COMMON.md` (on the `main` branch) and in [`worktrees/README.md`](worktrees/README.md) respectively.
