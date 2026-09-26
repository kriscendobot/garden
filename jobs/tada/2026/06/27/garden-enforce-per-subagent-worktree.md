All work landed and verified. Completion report follows.

---

## Completion report: `garden-enforce-per-subagent-worktree`

**Landed on `origin/main2` at `557e0d763`.** Mechanical enforcement of the per-subagent-worktree hard rule in the gardener `claude -p` launch path.

### What I did
The default handler `scripts/jobs/handlers/gardener-claude.sh` now launches `claude -p` with its **cwd already set to a fresh per-job worktree** off `origin/$GARDEN_MAIN_BRANCH` under `$GARDEN_SCRATCH`, so a job physically cannot edit the deployed root tree even if its prompt forgets the rule.

All four spec constraints reconciled:
1. **Session-resume.** The worktree path is *stable per job base* (`$GARDEN_SCRATCH/gardener-wt-<base>`), derived from the base exactly like the deterministic session id. The resume probe is keyed off the new worktree cwd, so a requeue re-enters the same worktree and finds both its uncommitted work and its transcript. No random suffix.
2. **Lifecycle.** Created off the local `origin/$main_branch` tracking ref (no per-job fetch — the watchman keeps it fresh; the job's own CAS push reconciles staleness). Reused as-is on resume; reset on a fresh claim that finds a stale leftover; torn down on successful completion; GC-safe on death (top-level child of `$GARDEN_SCRATCH`, reclaimed by the reaper's scratch janitor).
3. **Non-developing jobs.** Chose the blanket-worktree approach (simplest/safest per the spec) — every gardener job launches in a garden worktree; project-worktree and message jobs are unaffected (they `cd` into their own project worktree or read context, fresher).
4. **dispatch-prepare reconciliation.** Documented that the Agent-tool path already reaches the same guarantee via its worktree triple, so the rule holds on **both** launch paths.

### What changed
- `scripts/jobs/handlers/gardener-claude.sh` — the worktree mechanism (the core change; the peer's deliberate-deploy work did not touch this file, so it was conflict-free).
- `scripts/jobs/test/gardener-worktree-test.sh` (new, hermetic, 14 assertions, all pass) — proves cwd = a worktree never the root, the root tree stays clean, teardown-on-success, worktree-survives-failure, and **requeue re-enters the same worktree and resumes**. Includes an exec-allowed-temp-base probe because `/tmp` is mounted `noexec` here (which would silently fall through to the real `claude`).
- `designs/deliberate-deploy.md` — marked § Follow-on work **done**, updated the § All-development two-layer bullet to past tense, and **removed a stray `</content></invoke>` tool-call artifact** the peer's commit had left at the end of the file.
- `roles/COMMON.md` § Per-subagent worktrees and `roles/gardener/AGENT.md` — refined the norm wording to the now-automatic worktree (a `claude -p` gardener is *already inside* its worktree; the manual `git worktree add` shape is for shell/script jobs).

### Notes / coordination
- This was a follow-on to `garden-deliberate-deploy-no-shared-tree-development`, which was **in-flight by a live peer** when I claimed. I built independently off `origin/main2` in an isolated worktree, waited for their core to land (`fe2d9f296`), rebased onto it, and made the doc updates against the real landed base. Sent the peer a heads-up so they don't redo the follow-on.
- Build/verify worktrees cleaned up; real garden scratch and root tree left clean.

### Follow-ups
- None required. One latent edge (pre-existing, not introduced here): if the reaper wrongly requeues a *still-live* job past its TTL, two handlers could target the same worktree path — the same double-claim hazard that already existed for commits. Out of scope for this job; worth a note if reaper-vs-liveness tuning is revisited.

**Self-improvement:** Encoded nothing new as a memory — the relevant facts (`/tmp` noexec → run via real binaries; garden-infra jobs build in an isolated worktree off `origin/main2`; CAS push must check `git push`'s real exit code, not a piped `tail`'s) are already captured in existing memories. One reusable lesson surfaced: a `git push … | tail` in a CAS loop masks the push's exit status via the pipe — check `${PIPESTATUS[0]}` or capture without a pipe.
