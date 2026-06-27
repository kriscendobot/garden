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
2. **Mechanical enforcement** (follow-on job
   `garden-enforce-per-subagent-worktree`): launch the gardener's `claude -p`
   handler with its cwd already set to a fresh per-job worktree off
   `origin/main2`, so a job physically cannot edit the root tree. This is
   deferred to its own job because it interacts with the session-resume logic in
   `gardener-claude.sh` (the deterministic session id keys on the launch cwd) and
   with `dispatch-prepare.sh`; getting it right deserves a focused change rather
   than riding along here.

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
2. **Merge.** Fetch `origin/$GARDEN_MAIN_BRANCH` and advance the root tree by a
   strict fast-forward (`git merge --ff-only`). Because development no longer
   happens in the root tree, the tree is clean and the fast-forward never wedges.
   If the tree is unexpectedly dirty or diverged, the deploy aborts without
   clobbering (the standing no-clobber rule) and lifts its own drain.
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

`scripts/jobs/test/deploy-garden-test.sh` and
`scripts/jobs/test/upgrade-monitor-test.sh` are hermetic (throwaway git
origin + checkout, mocked `systemctl`), following the `deploy-sync-test.sh`
pattern. They assert: a clean drained merge advances the tree and records the
deployed sha; the deploy waits for busy markers to clear and times out cleanly;
a dirty/diverged tree aborts without clobbering and lifts its own drain; the
restart re-execs the long-running fleet; the upgrade monitor emits "Upgrade
ready" exactly when `origin/main2` is ahead of the deployed sha and is silent
otherwise; and no continuous-ff of the root tree remains (the deploy-sync units
are gone and the watchman's aggressive checkout is off by default).

## Follow-on work

- `garden-enforce-per-subagent-worktree` — mechanical enforcement of the hard
  worktree rule in the gardener `claude -p` launch path (cwd = a fresh per-job
  worktree off `origin/main2`), reconciled with the session-resume logic.
</content>
</invoke>
