---
ts: 2026-06-11T06:26:36Z
kind: result
role: liaison
dispatch: 4c5a52
host: endolin
model: opus-4-7-1m
---

# librarian cycle 297 — designs-lane — `kriskowal/garden/WORKTREES.md`

Cycle 297 (designs-lane after cycle 296 chat-lane @endo/zip/src/format-reader.js + THE ZIP CLUSTER SOURCE-FILE DEEP INGEST COMPLETES). One source ingested: `kriskowal/garden/WORKTREES.md` (168 lines). **The second design from the garden's own repository ingested** (after cycle 281's `designs/driver.md`). Distinct shape: cycle 281 was a *proposed design* (Status Proposed); cycle 297 IS a *standing reference* document.

## Library state

- 809 sections (up from 808 at cycle 296).
- 347 source documents (up from 346).
- §one-hundred-and-thirtieth consecutive designs-chat alternation cycles 166-250 + 252-297 (251 was out-of-band).
- **§two-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md).

## Files written

- `library/sections/garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions.md` (new section file; 168-line document in full scope).
- `library/sources/garden--WORKTREES-md.md` (new source page).
- `library/sections/README.md` (Total bumped 808 → 809; sources 346 → 347; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 63 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-296` → `pending-cycle-297`).

## First-explicit-observations (sixty-three)

Major: §the-second-named-garden-source-document-ingested + §two-named-shapes-of-garden-self-documentation (proposed-design + standing-reference) + §the-`---`-YAML-frontmatter-with-named-role-author (author: liaison) + §the-three-named-worktree-kinds (journal + fork + per-dispatch) + §the-named-three-tier-lifecycle-categorization + §the-named-orphan-branch-discipline + §the-named-`--`-separator-discipline-for-filenames (awk -F'--'-friendly) + §the-named-no-other-double-dash-invariant + §the-named-UTC-timestamp-ensures-uniqueness-without-coordination + §the-worktree-state-lives-in-the-journal-discipline (the-no-per-worktree-TOML-IS-named-explicitly) + §the-named-file-per-worktree-discipline + §the-named-`.garden/`-IS-role-private-high-frequency-state + §the-named-four-conditions-for-worktree-collectability + §the-named-collection-procedure-with-explicit-`worktree remove`-not-`rm -rf` + §the-named-cooperative-reservation-no-lock + §the-per-dispatch-worktree-triple-discipline + §the-named-`<short-id>`-IS-6-hex-chars + §the-detached-HEAD-discipline-for-per-dispatch-checkouts + §the-named-`git push origin HEAD:<branch>`-IS-the-canonical-push-form + §the-named-orchestrator-helper-scripts (prepare + teardown; named-idempotent-cleanup) + §the-named-subagent-never-creates-or-removes-worktrees-itself + §the-named-standing-exceptions (bash poll daemons + standing monitor worktrees) + §the-named-anti-pattern-warning (named-design-drift-IS-the-named-anti-pattern-marker) + §the-named-hostname-resolution-IS-`hostname -s` + §the-named-bare-clone-`info/exclude`-pattern (named-`.git`-file-vs-directory-distinction) + §the-named-"worktrees-should-be-as-independent-as-possible"-pedagogy + §the-named-mechanization-of-the-independence-principle + §the-named-Markdown-link-to-the-other-garden-document + §the-named-asymmetric-three-fields-in-the-per-dispatch-naming (fork three-field + per-dispatch four-field).

## Multi-cycle pattern recognition

- **§two-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md).
- **§the-named-role-as-author-shape** — cycle 281 noted multi-author by role; cycle 297 instantiates single-author-by-role.
- **§two-named-shapes-of-garden-self-documentation** — proposed-design (281) + standing-reference (297).
- **§two-named-metadata-shapes-for-design-docs-in-the-garden's-orbit** — endo `**Created** | YYYY-MM-DD` table vs garden YAML frontmatter.

## Synthesis target

Slot machine library `@game/WORKTREES.md`: three-named-worktree-kinds (state-log singleton + game-fork on-demand + per-tournament-ephemeral); the named `--` separator discipline (`awk -F'--'`-friendly); the named-orphan-branch shape for state-log (zero-history-shared with main); four-named-conditions-for-game-table-collectability (status + no-uncommitted + branch-merged + heartbeat > 1 hour); the named-safe-removal-via-git-vs-rm-rf; the named-cooperative-reservation-no-lock; per-tournament-worktree-triple discipline (game-state + history + table-fork); the detached-HEAD discipline; the named-helper-scripts (prepare + teardown) with named-idempotent-cleanup; the named-standing-exceptions for long-lived state; the named-bare-clone-`info/exclude` pattern; the named-asymmetric-three-vs-four-field-naming-conventions.

## Single most structurally interesting move

**§the-detached-HEAD-discipline-for-per-dispatch-checkouts** combined with **§the-named-no-branch-ownership-contention-between-orchestrator-and-subagent** — the per-dispatch worktree triple uses **detached HEAD** for all three sub-worktrees. The orchestrator owns the named branches (main + journal); the subagent operates in detached-HEAD mode and pushes back via `git push origin HEAD:<branch>`.

**§the-named-detached-HEAD-eliminates-the-branch-singleton-contention**. The discipline generalizes to any orchestrator launching many concurrent workers against the same git repo: detached-HEAD-per-worker avoids coordination overhead. Workers push via `git push origin HEAD:<branch>` which lets the remote's branch-update path serialize the writes naturally (with retries on rejection).

The pattern generalizes far beyond the garden: sibling-pattern to **"contention reduction through removal of the singleton"** in distributed-system design (queue-based work distribution avoids singleton-lock + CRDT-based replication avoids singleton-leader + content-addressed storage avoids singleton-name).

## Next cycle

Cycle 298 — chat-lane next.
