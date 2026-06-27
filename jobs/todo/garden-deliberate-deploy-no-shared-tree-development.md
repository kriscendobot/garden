# Dispense with the shared live tree: per-subagent worktrees + a deliberate drained garden deploy

Map: **design + build** (garden infra), branch main2. Substantial/architectural — run a design
pass (a design doc) and decompose into follow-on jobs as needed. Build in an isolated worktree off
origin/main2; explicit-pathspec commits; push HEAD:main2 via a git-rebase CAS loop.

Maintainer directive 2026-06-27: **entirely dispense with the shared-live-tree model.** No
development — even on the garden itself — touches the root checkout (`/home/kris`); every subagent
develops in its OWN dedicated worktree so they never collide. The root checkout is a DEPLOYED
version, upgraded only by a deliberate, drained deploy — never by continuous fast-forward.

## The problem to kill
Today the root checkout continuously fast-forwards to origin/main2 (garden-watchman aggressive-
checkout + garden-deploy-sync) AND gardeners sometimes edit the shared root tree. They collide:
in-tree edits wedge the ff; the ff races in-flight edits → the recurring "dirty-wedge". Remove the
collision by removing BOTH the shared-tree edits and the continuous ff.

## 1. All development in per-subagent worktrees (HARD RULE)
- Every gardener/subagent doing ANY development — including garden-infra (main2) — works in its OWN
  git worktree off the dev branch, NEVER the root checkout. Enforce in the gardener workflow /
  dispatch-prepare so a garden-infra job always gets a worktree, exactly like project jobs do.
- The root checkout becomes read-only for development; only the deploy process (step 3) writes to it,
  via merge. Make the isolated-worktree path the ONLY path (codifies/strengthens the existing
  feedback_garden_infra_jobs_use_isolated_worktree norm; remove any shared-root edit path).

## 2. Branch model (confirm naming in the design pass)
- A DEV / next-version branch holds accumulated development; subagents land here from their
  worktrees. The maintainer's "upgrade available on main2" implies **main2 is that dev source** —
  default to main2. OPEN QUESTION: keep `main2` as the dev branch, or consolidate to `main` (the
  maintainer also called it "the garden's main branch")? And what branch the ROOT CHECKOUT tracks
  as "deployed". Resolve with the maintainer; do not rename branches without confirmation.
- The root checkout tracks the DEPLOYED version and is advanced ONLY by the deploy process.

## 3. The deliberate deploy process (a dedicated process, NOT continuous ff)
Provide a `deploy-garden.sh` that:
1. **DRAIN.** Engage the draining marker (the renamed killswitch) so gardeners finish in-flight
    claims and take no new ones; wait for the `doin` board to quiesce (no active claim on this host).
2. **MERGE.** Advance the root checkout by merging the dev branch (origin/main2) into it. Because
    development no longer happens in the root tree, the root stays clean → a clean fast-forward/merge,
    no wedge. (This is the "merge main2 into the root checkout" the maintainer described.)
3. **RESTART.** Restart all long-running services AND the gardener fleet so they re-exec onto the new
    code; record the newly-deployed sha as the deployed marker; LIFT the draining marker.
- **RETIRE the continuous-ff behavior:** disable garden-deploy-sync's auto-advance+restart and the
  watchman's aggressive-checkout of the root tree (keep the watchman's broadcast role). The root tree
  is no longer auto-ff'd by anything — only `deploy-garden.sh` advances it.

## 4. The "Upgrade ready" deterministic monitor
- A deterministic systemd service whose SOLE role is to detect that the dev branch (origin/main2) has
  advanced beyond the root checkout's DEPLOYED sha and emit **"Upgrade ready"** — a journal/state
  signal (and a log line) the liaison's Monitor surfaces. NO LLM, NO side effects: fetch, compare two
  shas, signal. Silent when up to date.
- **This session (the liaison) acts on the signal:** the liaison runs a Claude Code **Monitor**
  watching the "Upgrade ready" signal and, on seeing it, AUTOMATICALLY invokes `deploy-garden.sh`
  (drain → merge → restart). So the deploy is session-orchestrated (human-surface) but triggered
  automatically by the deterministic signal — matching "occur automatically when this session notices
  an upgrade available on main2." Wire this into roles/liaison/AGENT.md + the CLAUDE.md bring-up.

## 5. Per-instance, journal-tracked state
The DEPLOYED-sha marker and deploy state live in journal/host standing-state (per the existing
conventions), not main2.

## Reconcile / retire
- `garden-deploy-sync` (continuous ff+restart) → replaced by `deploy-garden.sh`; retire or repurpose.
- `garden-watchman` → drop aggressive-checkout of the root tree; keep the reread broadcast.
- The draining marker → the rename-killswitch-to-draining job (coordinate; the deploy uses it).
- dispatch-prepare / gardener workflow → enforce per-subagent worktrees.
- The "Upgrade ready" monitor is a NEW deterministic service.

## Tests
Extend run-test.sh: a garden-infra change builds in a worktree, never the root tree; `deploy-garden.sh`
drains then merges cleanly then restarts and updates the deployed marker; the upgrade monitor emits
"Upgrade ready" EXACTLY when origin/main2 is ahead of the deployed sha and is silent otherwise; no
continuous-ff of the root tree remains (deploy-sync/watchman aggressive-checkout gone).

## Deliverable
Per-subagent worktree enforcement (no shared-root development), `deploy-garden.sh` (drain → merge →
restart, deterministic), the "Upgrade ready" monitor + journal deployed-sha marker, retirement of the
continuous-ff path, the liaison Monitor wiring so this session auto-deploys on the signal, a design
doc, tests, and CLAUDE.md docs — with the branch naming confirmed with the maintainer.

<!-- garden-reaped: 1 -->
