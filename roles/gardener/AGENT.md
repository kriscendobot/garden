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
- **Watch your inbox while you work.** A maintainer reply or a peer message can
  arrive mid-job; poll `inbox-read.sh <your-base>`.
- To reach the user, `message-user.sh <your-base>` — the liaison surfaces it and
  routes any reply back into your inbox.
- Before submitting to CI, err toward running **all** evaluation scripts
  (false positives fine, false negatives not).

## Definition of done

The job's report is in `jobs/tada/<base>`, `doin/<base>`, `work/<base>`, and the
inbox are gone, and any worktree you created is torn down.
