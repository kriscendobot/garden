---
created: 2026-06-27
updated: 2026-06-27
author: gardener
---

# Deliberate deploy: no shared live tree

Maintainer directive 2026-06-27: **entirely dispense with the shared-live-tree
model.** No development, even on the garden itself, touches the root checkout
(`<garden-root>`, the deployed instance). Every subagent develops in its own
dedicated worktree so concurrent workers never collide. The root checkout is a
*deployed version*, advanced only by a deliberate, drained deploy, never by
continuous fast-forward.

This document specifies the new model and the parts that implement it.

## The problem this kills

Two mechanisms used to fast-forward the root checkout to `origin/main2`
continuously:

- `deploy-sync.sh` (the `garden-deploy-sync` timer) advanced the tree by a clean
  fast-forward and re-exec'd the long-running fleet.
- `watchman.sh` aggressively fast-forwarded the same tree on its own timer
  before broadcasting a reread notice.

Meanwhile gardeners sometimes edited the shared root tree directly. The two
collided: an in-tree edit wedged the fast-forward, and a fast-forward raced an
in-flight edit. That is the recurring "dirty-wedge" deploy outage. We remove the
collision by removing **both** sides: no shared-tree edits, and no continuous
fast-forward.

## Branch model

- **Dev branch (`main2`).** The accumulated next-version branch. Every gardener
  and subagent lands development here from its own worktree (never the root
  tree). `GARDEN_MAIN_BRANCH` names it (default `main2`); the deploy and the
  upgrade monitor both read that variable, so a future rename or consolidation
  onto `main` is a one-variable change, not a code edit. The branch-naming
  question (keep `main2` or consolidate onto `main`) is confirmed with the
  maintainer before any rename; the code is parameterized so either answer works.
- **Deployed version (the root checkout).** `<garden-root>` stays checked out on
  the dev branch but is advanced **only** by `deploy-garden.sh`. Its last
  deployed commit is recorded in a host-local marker
  (`$GARDEN_STATE/deploy/deployed-sha`), alongside the watchman's `seen` marker
  and outside any reset-prone worktree. The marker, not the branch name, is the
  deployed-version source of truth, so an accidental tree state never confuses
  the upgrade monitor.

The deployed-sha marker is per-host standing state (not committed to `main2`),
matching the existing convention for `$GARDEN_STATE` (the watchman `seen`
marker, gardener busy markers, the draining marker all live there).

## All development in per-subagent worktrees (the hard rule)

Every gardener or subagent doing any development, **including garden-infra work
on `main2`**, works in its own git worktree off the dev branch, never the root
checkout. The root checkout is read-only for development; only `deploy-garden.sh`
writes to it (by merge). This codifies and strengthens the existing
`feedback_garden_infra_jobs_use_isolated_worktree` norm: the isolated-worktree
path is now the *only* path.

The convention is enforced at two layers:

1. **Documentation / norm** (this change): the gardener role brief and
   `roles/COMMON.md` § Scratch discipline state the hard rule; every garden-infra
   job body repeats "build in an isolated worktree off origin/main2". A
   `claude -p` gardener reads these fresh each tick.
2. **Mechanical enforcement** (job `garden-enforce-per-subagent-worktree`, done):
   the default handler `scripts/jobs/handlers/gardener-claude.sh` launches the
   gardener's `claude -p` with its cwd already set to a fresh per-job worktree off
   `origin/$GARDEN_MAIN_BRANCH`, so a job physically cannot edit the root tree even
   if its prompt forgets to. This rode in its own job because it interacts with the
   session-resume logic in `gardener-claude.sh` (the deterministic session id keys
   on the launch cwd, so the worktree path is stable per job base, reused on
   resume, and torn down on completion). The Agent-tool dispatch path reaches the
   same guarantee independently via the worktree triple
   (`skills/dispatch-worktree/dispatch-prepare.sh`), so every developing subagent
   gets its own worktree on **both** launch paths. See § Follow-on work.

## The deliberate deploy process

`scripts/jobs/deploy-garden.sh` advances the root checkout in a single
deterministic, drained pass. No LLM. Steps:

1. **Drain.** Engage the draining marker (`drain-fleet.sh on`) so gardeners
   finish their in-flight claim and take no new ones, then **wait for the host to
   quiesce**: no gardener busy marker (`$GARDEN_STATE/gardeners/*/busy`) remains.
   The busy marker is the same host-local signal `deploy-sync.sh` uses to avoid
   restarting a mid-job gardener; here it tells us when the fleet has gone idle.
   Bounded by `GARDEN_DEPLOY_DRAIN_TIMEOUT` (default 600s); on timeout the deploy
   aborts and lifts the drain it engaged (unless the operator pre-engaged it), so
   a stuck job never strands the fleet drained.
2. **Merge (atomic per-file swap).** Fetch `origin/$GARDEN_MAIN_BRANCH`, verify
   the advance is a clean fast-forward over an un-edited root (dirty/diverged →
   abort without clobbering, the standing no-clobber rule), then advance the root
   tree **atomically per file** with `atomic_advance_tree` (`deploy-tree-swap.sh`)
   instead of an in-place `git merge --ff-only`. This closes the exec window that
   caused the recurring **rc=127 storm** (confirmed 2026-07-03; earlier the
   deploy-sync rc-127 loop of 2026-06-27): every long-lived `garden-*` unit execs
   its script straight from the checkout by absolute path, and a plain `git merge`
   rewrites a modified file by unlink+create — so a unit that execs mid-merge (a
   timer-driven oneshot firing, the gardener-scaler re-`enable --now`ing an exited
   gardener, a service crash-restart) opens a half-written or absent script and
   dies rc=127, marked Failed, dropping that tick's work. `atomic_advance_tree`
   stages each incoming blob as a sibling temp file and `rename(2)`s it into place;
   rename is atomic within a filesystem, so an opener sees the whole old or whole
   new file, never a partial one. Nothing is stopped or masked, so **no singleton
   tick is dropped** — a tick that fires mid-swap simply execs a complete
   (old-or-new) script. The whole-directory rename this doc's design space might
   suggest is not available: `$GARDEN_ROOT` is the bot's bind-mounted home and
   cannot itself be renamed, so the swap is at per-file granularity. After the file
   swaps, `git reset --mixed` advances HEAD + the index to the new sha without
   touching the working tree it just populated, leaving `git status` clean.
3. **Record + lift + restart.** Record the new HEAD as the deployed sha, lift the
   draining marker, then restart the long-running services and the gardener fleet
   so they re-exec onto the new code. Lifting the drain *before* the restart is
   safe: the drained gardeners have already exited, so nothing is running on the
   old code; the restarted units come up live on the new code and resume claiming.
   Timer-driven oneshots re-read their script from the now-advanced tree on their
   next firing, so they are not restarted here (mirrors `deploy-sync.sh`).

The restart half is shared with the retired `deploy-sync.sh` via
`deploy-restart.sh` (`restart_long_running_fleet`), so the "which units hold
stale code in a live process" knowledge lives in one place.

## Retiring the continuous fast-forward

- `garden-deploy-sync` (continuous fast-forward + restart) is **retired**: its
  `*.service` / `*.timer` units are removed and added to `install-units.sh`'s
  `RETIRED_UNITS` so an already-installed host disables them on the next
  `enable-services`. `deploy-sync.sh` itself is reduced to the sourceable
  `deploy-restart.sh` library that `deploy-garden.sh` reuses; the standalone
  reconciler is gone.
- `garden-watchman` keeps its **broadcast** role but drops the aggressive
  checkout: `GARDEN_AGGRESSIVE_CHECKOUT` defaults to `0`. The watchman no longer
  fast-forwards the root tree; it still fetches `origin`, and it still broadcasts
  a "reread your role and skills" notice when the *local* tree HEAD changes,
  which now happens exactly once per deploy. So the broadcast becomes a
  post-deploy reread signal, which is precisely when gardeners need to reread.

After this change nothing fast-forwards the root tree except `deploy-garden.sh`.

## The "Upgrade ready" monitor

`scripts/jobs/upgrade-monitor.sh` (the `garden-upgrade-monitor` timer) is a
deterministic detector: fetch `origin/$GARDEN_MAIN_BRANCH`, compare its tip to
the recorded deployed sha, and when the dev branch is **ahead** of the deployed
version, write an "Upgrade ready" signal
(`$GARDEN_STATE/deploy/upgrade-ready`, carrying the deployed→available shas and
the commit count) and emit one log line. No LLM, no side effects on the tree.
Silent (no signal, clean exit) when the deployed version is current; the signal
file is removed when the host catches up, so it is never stale.

The deployed sha defaults to the recorded marker; on a host that has never run a
deploy (no marker yet) it falls back to the current tree HEAD so the first
comparison is still meaningful.

## Session-orchestrated trigger (the liaison Monitor)

The deploy is session-orchestrated but signal-triggered. The liaison (this
terminal session) runs a Claude Code **Monitor** watching the "Upgrade ready"
signal; on seeing it the liaison automatically invokes `deploy-garden.sh`
(drain → merge → restart). This matches the maintainer's framing: the deploy
"occurs automatically when this session notices an upgrade available on main2",
yet stays on the human-facing surface (the liaison can see and interrupt it)
rather than being a fully autonomous background service. The wiring lives in
`roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor and the `CLAUDE.md`
bring-up.

A host with no liaison session present (a pure bot host) simply accumulates
"Upgrade ready" signals until a liaison runs a deploy, or an operator runs
`deploy-garden.sh` by hand. The deploy is never autonomous-without-a-session by
design: advancing the deployed version is the one garden action the maintainer
wants on the human surface.

## State summary

All per-host, under `$GARDEN_STATE/deploy/` (host standing state, not `main2`):

- `deployed-sha` — the commit the root checkout was last deployed to.
- `upgrade-ready` — present only while the dev branch is ahead; carries the
  deployed→available shas and the ahead-by count. The liaison Monitor keys on it.

## Tests

`scripts/jobs/test/deploy-garden-test.sh`,
`scripts/jobs/test/deploy-tree-swap-test.sh`, and
`scripts/jobs/test/upgrade-monitor-test.sh` are hermetic (throwaway git
origin + checkout, mocked `systemctl`), following the `deploy-sync-test.sh`
pattern. They assert: a clean drained merge advances the tree and records the
deployed sha; the deploy waits for busy markers to clear and times out cleanly;
a dirty/diverged tree aborts without clobbering and lifts its own drain; the
restart re-execs the long-running fleet; the upgrade monitor emits "Upgrade
ready" exactly when `origin/main2` is ahead of the deployed sha and is silent
otherwise; and no continuous-ff of the root tree remains (the deploy-sync units
are gone and the watchman's aggressive checkout is off by default).
`deploy-tree-swap-test.sh` covers `atomic_advance_tree` directly: it reproduces
up_sha exactly across adds/modifies/deletes/mode-flips/symlinks with a clean tree
and no temp litter; a concurrent hammer that exec's a script thousands of times
*while the swap runs* observes zero rc=127 and zero partial reads (the atomicity
guarantee); and an unstageable incoming blob aborts before any live file is
touched.

## Follow-on work

- `garden-enforce-per-subagent-worktree` (done) — mechanical enforcement of the
  hard worktree rule in the gardener `claude -p` launch path. The default handler
  `scripts/jobs/handlers/gardener-claude.sh` now launches `claude -p` with its cwd
  already set to a fresh per-job worktree off `origin/$GARDEN_MAIN_BRANCH` under
  `$GARDEN_SCRATCH`, so a job physically cannot edit the root tree even if its
  prompt forgets to. The worktree path is stable per job base (reconciled with the
  deterministic session id, whose project dir is keyed by the launch cwd), so a
  reaper requeue re-enters the same worktree and resumes the same transcript; it is
  reused on resume, torn down on completion, and garbage-collected on death by the
  reaper's scratch janitor. Covered by `scripts/jobs/test/gardener-worktree-test.sh`.
