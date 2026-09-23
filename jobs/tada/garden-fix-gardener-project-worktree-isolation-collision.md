Pushed to main2 cleanly. Done.

## Completion report

**Root cause (investigated end to end).** A v2 gardener's `claude -p` handler (`scripts/jobs/handlers/gardener-claude.sh`) launches it with cwd already set to a unique per-base **garden** worktree (`$GARDEN_SCRATCH/gardener-wt-<base>`), but **nothing deterministic created the PROJECT checkout** for a job that mutates a fork. The role brief pointed at v1's `dispatch-prepare.sh` (which the job-board gardener never runs), so the gardener improvised a project path. On endo-but-for-bots #58, two gardeners each improvised the **same repo+PR-keyed name** (`…/ebfb-pr58-project`) → one shared working tree → concurrent edits to `error-trace.js` + `chat-bar-component.js` bled across and corrupted each other. `scratch_dir` (which adds a random suffix) was never on this path.

**Fix.** New `scripts/jobs/ensure-project-worktree.sh <base> <owner/repo> <branch>`:
- Keys the project worktree by the gardener's **unique job base** (never repo+branch or PR number), plus a short `owner/repo@branch` digest so one job holding two checkouts can't self-collide.
- Detached checkout off the standing bare clone, bot-identity pinned, under `$GARDEN_SCRATCH`.
- **Deterministic in (base, repo, branch)** → a reaper requeue re-derives the same path and reuses in-flight work (resume-stable), mirroring the garden-worktree convention.
- Two concurrent same-repo/same-branch jobs → distinct trees; only the git push to the shared head branch races (CAS at the remote), which is correct.

**Wiring.** Added the helper's use to the gardener launch prompt, `roles/gardener/AGENT.md`, and `skills/worktree-per-pr/SKILL.md` (documents the v2 gardener path vs. the v1 dispatch triple).

**Test.** New `scripts/jobs/test/project-worktree-isolation-test.sh` — **12/12 pass**: two different bases on the same repo+branch → distinct paths + no edit bleed-through (the #58 regression), requeue re-derives the same path preserving work, one base across two repos doesn't self-collide, all trees under `$GARDEN_SCRATCH`, HEAD detached. Existing `gardener-worktree-test.sh` still **16/16**.

**Landed:** commit `0ec35c1a8` pushed to `main2` (CAS, first try).

**Follow-up (noted, out of scope):** the per-comment **double-dispatch** (manual rsvp jobs + comment-watcher auto-jobs both firing per comment) is what puts two gardeners on the same PR in the first place. Worktree isolation makes that survivable but doesn't dedup the dispatch — worth a separate job.
