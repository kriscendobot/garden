# Mechanically enforce per-subagent worktrees in the gardener launch path

Map: **build** (garden infra), branch main2. Build in an isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via a git-rebase CAS loop.

Follow-on to `garden-deliberate-deploy-no-shared-tree-development` (designs/deliberate-deploy.md
§ All development in per-subagent worktrees). That job landed the deliberate-deploy core (deploy-garden.sh,
the upgrade monitor, retirement of the continuous-ff path) and the worktree HARD RULE as a documented
norm (roles/COMMON.md § Per-subagent worktrees, the gardener role brief, every garden-infra job body).
What remains is the MECHANICAL half: make it physically impossible for a gardener job to edit the root tree.

## The task
Launch the gardener's `claude -p` handler (scripts/jobs/handlers/gardener-claude.sh) with its cwd
already set to a fresh per-job worktree off origin/main2, so a job cannot edit the root checkout even
if its prompt forgets to. Today gardener-claude.sh runs `claude -p` from the gardener's stable launch
cwd (the root, $PWD).

## Constraints to reconcile (why this is its own job, not a ride-along)
1. **Session-resume interaction.** gardener-claude.sh derives a DETERMINISTIC claude session id from the
   job base and resumes a requeued job by re-launching in the SAME cwd
   (`~/.claude/projects/<encoded-cwd>/<sid>.jsonl`). If the cwd becomes a fresh per-job worktree, the
   resume-transcript lookup must use a STABLE per-base worktree path (derive it from the base, like the
   session id) so a requeue re-enters the same worktree and the transcript is found. A random scratch
   suffix per attempt would break resume.
2. **Worktree lifecycle.** The per-job worktree must be created before launch and torn down on
   completion (complete-job path) AND garbage-collected if the job dies (the reaper's scratch janitor
   already GCs $GARDEN_SCRATCH; place the worktree there). It must survive a reaper requeue (so resume
   finds uncommitted work) yet not leak forever.
3. **Non-developing jobs.** Many gardener jobs (PR-pipeline work in a project worktree, pure-message
   jobs, run-… board jobs) do NOT develop the garden and already cd into their own project worktree or
   need the root for read-only context. Decide whether ALL gardener jobs get a garden worktree or only
   garden-infra jobs, and how to tell them apart (the current signal is the job body asking for main2 work).
   A blanket worktree for every job is simplest and safest if resume + project-worktree jobs still work.
4. **dispatch-prepare.** The in-session liaison/Agent-tool dispatch path (skills/dispatch-worktree)
   already gives subagents a worktree triple; confirm the gardener launch path reaches the same
   guarantee, and reconcile the two so the rule "every developing subagent gets its own worktree" holds
   on BOTH paths.

## Deliverable
- gardener-claude.sh (or gardener.sh) launches each developing job in a stable, per-base worktree off
  origin/main2 under $GARDEN_SCRATCH, reconciled with the deterministic-session-id resume logic.
- The worktree is torn down on completion and GC-safe on death.
- A test (extend the standalone test suites, e.g. a gardener-worktree-test.sh) proving a garden-infra
  job runs with cwd = a worktree, never the root tree, and that a requeue re-enters the same worktree.
- Update designs/deliberate-deploy.md § Follow-on work to mark this done and roles/COMMON.md if the
  mechanism changes the norm's wording.
