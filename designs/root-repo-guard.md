---
created: 2026-07-21
updated: 2026-07-21
author: gardener
---

# Root-repo guard: harden the deployed root against job git-escapes

| Created | 2026-07-21 |
| Author  | gardener |
| Status  | Implemented |

## The incident (2026-07-17 / 2026-07-21)

The deployed root checkout (`$GARDEN_ROOT`) and the `journal/` worktree **share one
repo** (`$GARDEN_ROOT/.git`). Twice, a job ran a git command with that shared repo as
its enclosing repository and corrupted it:

1. **Native-git test-fixture escape (2026-07-17).** A test created a dir under the
   root but never `git init`-ed it, so its `checkout -b feature` / `commit` ops
   **ascended** to the root repo. HEAD moved off the deployed detached commit
   (`374deede65`) onto a fixture `feature` branch, and the v1 `main` branch was moved
   too. **The fleet ran the fixture working tree for four days.**
2. **Project-work escape (2026-07-21).** A worker treated the root as its project
   checkout: `git remote set-url origin ssh://…/endojs/endo-but-for-bots.git`, a
   fetch that **pruned the true origin refs** (`origin/journal2`, `origin/main2`),
   and `git branch xs2rust-endor …` — all in the root repo. Journal sync broke
   **host-wide** (the journal worktree froze; `inbox-read`/`message-user` FATALed),
   and the journal-remote cache was poisoned. The fleet survived only because each
   per-gardener state clone pins its **own** correct origin.

Both incidents share a class: **a git command whose repo resolution ascends past, or
is aimed straight at, the shared root repo.** And both went undetected for days —
nothing asserted the root's invariants.

## The fix — three coordinated layers

Defense in depth, cheapest-first, each independently useful:

1. **Prevent the ascent (env).** The worker spine (`gardener.sh`, shared by every
   worker kind — gardener/cleric/hermit) exports
   `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`. Git's upward repo discovery stops at the
   root, so an **un-inited dir under the root FATALs** with "not a git repository"
   instead of latching onto `$GARDEN_ROOT/.git` (incident 1's mechanism). Legitimate
   work is unaffected: a per-job worktree, a project checkout, and the worker's own
   state clone each carry their own `.git` found without any ascent, and an explicit
   `git -C <dir>` is exempt (the ceiling never excludes a named/current dir). This
   does **not** stop a command aimed *straight at* the root (incident 2) — that is
   what layers 2 and 3 catch.

2. **Forbid it (prompt).** The worktree-discipline paragraph appended to every job
   prompt (`handlers/worker-common.sh` `worker_worktree_note`, byte-identical across
   backends) now states plainly: **never run git in `$GARDEN_ROOT`**; a stray
   `remote set-url`/`fetch`/`checkout`/`commit` there corrupts journal sync for the
   whole host; run git only inside your per-job worktree or a project checkout from
   `ensure-project-worktree.sh`; if a tool needs a scratch repo, create and
   `git init` it **outside** the root. This directly hardens the xs2rust-endor press
   family and every other job.

3. **Repair drift that still slips through (timer).** `root-repo-guard.sh`, wired to
   `garden-root-repo-guard.timer` (~30m, `:22/:52`), runs on **every host** (each
   host's root can be corrupted independently — not leader-gated). It asserts and
   losslessly repairs:

   - **Origin URL** must match `GARDEN_PRODUCTION_JOURNAL_REMOTE_RE`
     (`is_production_journal_remote`). A wrong origin breaks journal sync host-wide,
     so it is repaired eagerly — from a source the escape **cannot poison**: the
     origin of any per-instance journal clone under `$GARDEN_STATE`
     (`_journal_remote_from_state_clones`), **re-validated against the RE before it
     is written** so a repair can only ever set the canonical URL.
   - **HEAD** must be **detached at a `main2` ancestor** — never on a local branch
     (the `feature` escape), never at a commit unreachable from `origin/main2` (a
     fixture commit). Repair re-detaches HEAD onto the recorded deploy point
     (`deployed_sha` — so it **respects deliberate-deploy** and does not advance the
     deploy) when that is a `main2` ancestor, else onto the `origin/main2` tip. The
     prior HEAD is preserved as a `root-guard-backup/<ts>` branch ref first
     (lossless). Deferred while the fleet is **draining** (a deploy owns the tree)
     and when `origin/main2` is unresolvable (never reset toward an unknown target).

   Plus a **stalled-deploy watch**: when `deployed_sha` lags `origin/main2` past
   `GARDEN_DEPLOY_STALL_DAYS` (default 3), it alerts **once per breakage window**
   (the incident also noted deploys silently stalled since 07-17), cleared
   automatically on catch-up.

   Quiet on the healthy path (one line); every repair and alert is logged and paged
   (throttled per key). Always returns 0 — a transient hiccup never marks the tick
   Failed. The guard deploys to every instance via the standard unit-derived
   enable-set (a non-template `*.timer` with `WantedBy=timers.target` is
   auto-enabled), so no host list needs editing.

## Why not fold it into an existing keeper

The `journal-worktree-keeper` reconciles the *worktree* half of the shared repo; the
guard reconciles the *root checkout* half. They are separable invariants with
different repair machinery (the keeper's active-writer/backup gating vs. the guard's
detach-to-deploy-point), and a dedicated, independently-testable timer reads more
legibly than overloading the keeper. Cadence is offset (`:22/:52`) so it audits
after clone-keeper (`:00/:30`) and the journal keeper (`:15/:45`) have refreshed the
refs it compares against.

## Coverage

`scripts/jobs/test/root-repo-guard-test.sh` — hermetic (throwaway origin/root/state
clones; `GARDEN_PRODUCTION_JOURNAL_REMOTE_RE` overridden to match the fixture;
alerts captured via `GARDEN_ALERT_CMD`): healthy no-op, origin-drift repair,
HEAD-onto-a-branch repair with a lossless backup ref, non-ancestor-HEAD repair,
draining-defer, and the stalled-deploy alert (fires once past threshold, dedupes,
clears on catch-up).
