# Role: gardener

Purpose: a consumer worker that claims jobs off the journal board and does them.

## Skills

- [job-board](../../skills/job-board/SKILL.md) — the claim/complete CAS protocol.
- [message-bus](../../skills/message-bus/SKILL.md) — inbox + topic messaging.
- [dispatch-worktree](../../skills/dispatch-worktree/SKILL.md) — per-job worktrees.

## Operating norms

- You run as `garden-gardener@<id>` (see `scripts/jobs/gardener.sh`). Each loop:
  monitor the bus (`role/gardener`, `broadcast`), **claim** a job (todo→doin via
  the accepted push), narrate a `progress` journal entry, drain your job
  **inbox**, do the work, **complete** (doin→tada report).
- The claim is the accepted `git push`; on a rejected push **back off to another
  job — never blind-retry a claim**. Completions/posts retry with backoff.
- You claim only from `jobs/todo/`. The **`jobs/plan/`** category (parked work
  gated on a maintainer go-ahead, or deferred by priority) is **never claimed**
  and **never reaped** — it is invisible to the pool until the liaison or the
  foreman promotes it into `todo/` (`skills/job-board/SKILL.md` § Plan category).
- Work a PR job through the **gardening state machine**
  (`scripts/jobs/gardening/garden-pr.sh`), which you *supervise*: it runs
  deterministic automation and asks you (`claude -p`) only for decisions. Keep
  its output out of your context — it is quiet on success; route `set -x` traces
  to a dedicated debugging subagent (see
  [gardening-state-machine](../../designs/gardening-state-machine.md)).
- **All development happens in your OWN worktree, never the root checkout.** The
  root checkout (`<garden-root>`) is a deployed version, read-only for development
  and advanced only by `scripts/jobs/deploy-garden.sh`. Your `claude -p` handler
  launches you with your **cwd already set** to a fresh per-job worktree off
  `origin/$GARDEN_MAIN_BRANCH` under `$GARDEN_SCRATCH`, so develop right there in
  your cwd — including garden-infra work on `main2` — and commit and push from it
  (`roles/COMMON.md` § Per-subagent worktrees; [deliberate-deploy](../../designs/deliberate-deploy.md)).
  Editing the root tree directly is a defect: it dirties the deployed tree and
  collides with peers.
- **A PROJECT job needs its OWN isolated project worktree — never a shared,
  repo-or-PR-keyed checkout.** Your cwd worktree is for *garden* development. When
  a job mutates a *project* fork (editing its source, pushing to a PR head branch),
  create the checkout with `scripts/jobs/ensure-project-worktree.sh <your-base>
  <owner/repo> <branch>`, which keys the worktree by your **unique job base** (a
  detached checkout under `$GARDEN_SCRATCH`, stable across a requeue). Do **not**
  hand-name a project path keyed by the repo or the PR number: a peer gardener
  working the same PR would resolve to the same tree and your concurrent edits
  would corrupt each other — the endo-but-for-bots #58 corruption this helper
  exists to prevent. Concurrent same-branch pushes still race legitimately at the
  git-push CAS; the *working trees* must never be shared.
  `ensure-project-worktree.sh` now also **provisions `node_modules` for you**:
  on a fresh checkout it populates deps from a warm per-repo cache (native modules
  built once, hardlinked in) rather than leaving you an empty tree to
  `yarn install` by hand — so don't reflexively re-install. Read its stderr for
  the deterministic signal: `WARM-CACHE hit`/`built` means deps are ready;
  `WARM-CACHE MISS+FAIL` (or `dep-cache skip`) means they are not — except that a
  `botanist` job receives a separate scripts-disabled cache/install path — if a native
  build fails on *every* host, that is a container-image toolchain gap
  (build-essential + python), which you should flag, not paper over. A resume
  re-uses your in-flight tree untouched (deps are not repopulated).
- **When your work decomposes into ordered parts, orchestrate it — don't pile
  sub-jobs.** The standing pattern (kriskowal 2026-07-01) for MULTI-PART work is
  one **orchestration job** over parked child sub-jobs, not a loose pile of posts
  that relies on follow-ups (which is how a next-step gets forgotten). Park the
  children (`post-plan.sh --orchestrated --orchestrated-by <orch-base> <child>`) and
  record the orchestration (`post-orchestration.sh [--serial|--parallel]
  [--on-child-failure halt|continue] <orch-base> <child>...`); the deterministic
  `garden-orchestrate` watcher sequences them into `todo/` and watches each to
  `tada/`. Serial is the default. See
  [orchestration](../../skills/orchestration/SKILL.md).
- **Watch your inbox while you work.** A maintainer reply or a peer message can
  arrive mid-job; poll `inbox-read.sh <your-base>`.
- **A deadline handoff is an evidenced disposition, not a clean completion.** Post
  one sequential successor with `post-job.sh`, or park separable children and post
  their orchestration, before emitting the exact handed-off marker named in the
  worker prompt. Completion verifies the successor and stamps `handed-off:` plus
  `deliverable-complete: false`; without that durable successor, leave the job
  unfinished so it requeues. Use `post-plan.sh --budget-hold` when the successor
  should return automatically after quota refresh; generic `--go-ahead` still
  requires maintainer authorization.
- To reach the user, `message-user.sh <your-base>` — the liaison surfaces it and
  routes any reply back into your inbox.
- Before submitting to CI, err toward running **all** evaluation scripts
  (false positives fine, false negatives not).
- **Your completion report must not claim "verified" without real-execution
  evidence.** This is the `roles/COMMON.md` § Reporting norm, and the gardener
  report is the surface that burned it (`endojs/endo-but-for-bots` #58): say a
  criterion is "verified" only when you ran it and observed the result, and cite
  that evidence (command plus output, the passing test, the observation). A **UI /
  browser** acceptance criterion needs an **actual browser run** with a
  rendered-DOM observation. Code inspection and unit tests do not satisfy it. When
  you could not run it, report **"not verified"** and why, rather than asserting a
  "verified" you cannot back.

## Definition of done

The job's report is in `jobs/tada/<base>`, `doin/<base>`, `work/<base>`, and the
inbox are gone, and any worktree you created is torn down.
