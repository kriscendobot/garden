---
role: designer
---

# Design: auto-provision per-repo watchers when the garden creates a fork

**Repo:** the garden's OWN repo (this repo). Land the design on `main2` and the
watch-set change on `journal2` directly — no PR (garden convention). Deterministic,
**no LLM in any surveillance-gating path.**

**Authorization:** the maintainer-authorization record for this widening is the
journal broadcast `20260709T225552Z-e61229` (2026-07-09, "watch the garden's own
forks"). Cite it. This job is the § Monitoring safety constraint's "role-author
lands the change" step.

## The gap

The garden's per-repo watchers are provisioned **manually** by adding a slug to
two journal-backed sets that `repo-watcher.sh` reconciles to systemd units:
`journal/repos/` → `garden-triager@<slug>` (commit watch, laxer bar) and
`journal/comment-repos/` → `garden-comment-watcher@<slug>` + `garden-ci-watcher@<slug>`
(comment + CI, strict bar). Because nobody added `kriscendobot/minion.town`, three
kriskowal APPROVED reviews on `kriscendobot/minion.town#3` went unwatched. The
garden already holds a bare clone (`worktrees/kriscendobot-minion.town.git`) and
works the repo — but watch provisioning never followed fork creation.

## What to build

1. **Auto-provision at fork creation.** Pick the cleanest deterministic seam and
   wire it so that when the garden first creates/works a fork, the repo is added to
   the watch set without a human. Candidates to evaluate: `clone-keeper.sh` (bare-
   clone maintenance — the moment a new `worktrees/<owner>-<repo>.git` appears),
   `ensure-project-worktree.sh` (first per-job worktree for a repo), or a new
   reconcile step that maps existing bare clones → watch-set membership. It must be
   idempotent and journal-CAS-safe (the set lives in `journal/`).

2. **Reconcile with the § Monitoring safety constraint — the load-bearing part.**
   - `repos/` (commit triager): safe to auto-add for own forks.
   - `comment-repos/` (comment surveillance): comment text enters `claude -p`
     context. **Our own forks may be public**, so repo-gating cannot make them
     safe. Add a deterministic **sender-trust gate** to the comment-watcher path
     for own-forks, mirroring `mention-watcher.sh` / the issue-inbox: in plain
     code, **before any comment reaches a job or `claude -p`**, drop comments whose
     author is not on `trusted-senders/allowlist`, the `maintainers/allowlist`, or
     a current endojs/Agoric org member. Auto-provisioned comment surveillance on
     an own-fork is permitted ONLY behind this gate.
   - `ci-watcher` reads only CI status (no external text) and rides the cleared
     `comment-repos/` set — no extra surface.
   - Distinguish **own forks** (`kriscendobot/*` — auto-provision with the sender
     gate) from **upstream/third-party repos** (still require the existing explicit
     per-repo maintainer authorization; do NOT auto-widen surveillance onto repos
     we don't own).

3. **Arm `kriscendobot/minion.town` as the first concrete instance.** Add slug
   `kriscendobot-minion.town` to `journal/repos/` and `journal/comment-repos/` so
   the missed-review class of gap closes the moment this lands.

4. **Update CLAUDE.md § Monitoring safety constraint** to document own-fork
   sender-gated auto-provisioning as a sanctioned widening shape (same paragraph
   family as the mention-watcher and issue-inbox exceptions), citing the
   authorization broadcast.

## Definition of done

Fork creation deterministically adds the new own-fork to the watch set with the
comment-watch sender-gate in force; `kriscendobot/minion.town` is watched
(triager + comment + CI); a `designs/` doc records the seam, the gate, and the
own-fork-vs-upstream distinction; CLAUDE.md's constraint text is updated. If the
design surfaces a decision the maintainer must make (e.g. exactly which orgs count
as trusted for own-fork comments), stop and route it to the maintainer inbox rather
than guessing.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  claimed_at: 2026-07-09T22:56:32Z
