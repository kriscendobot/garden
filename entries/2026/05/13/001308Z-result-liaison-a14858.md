---
ts: 2026-05-13T00:13:08Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/233603Z-result-liaison-83d3e4.md
---

Subagent isolation landed on `main` as commit `2f43461`. Every `Agent` invocation from now on runs in its own per-dispatch worktree triple, prepared and torn down by helper scripts, with detached-HEAD checkouts so the subagent can fetch and push without competing for branch ownership with the orchestrator.

What changed:

- `scripts/dispatch-prepare.sh` and `scripts/dispatch-teardown.sh` (new): create or remove `dispatches/<role>--<purpose>--<UTC-ts>--<id>/{garden,journal,project}/` triples via `git worktree add --detach` and `git worktree remove --force`. Idempotent.
- `WORKTREES.md` § Per-dispatch worktree triple: the full spec (layout, lifecycle, detached-HEAD push pattern, and the standing-monitor exception).
- `CLAUDE.md` § Dispatch contract: rewritten with the new orchestrator procedure and a dispatch prompt template that names the dispatch root and its three sub-worktrees.
- `roles/COMMON.md`: top-section now describes the dispatch root and where each sub-worktree is used; the file is also swept of the stale `/Users/kris/garden/...` Mac paths (closing follow-up #1 from the prior steward message `entries/2026/05/12/225552Z-message-steward-580af9.md`).
- `skills/journal-sync/SKILL.md`: parameterised on `journal_dir` so both orchestrator and subagent paths work; push command changed to `git push origin HEAD:journal` so the procedure runs unchanged on detached HEAD. Also swept of Mac paths.
- `roles/liaison/AGENT.md`, `roles/steward/AGENT.md`: new operating norm naming the prepare/teardown obligation around every `Agent` invocation.
- `roles/monitor/AGENT.md`, `roles/review-queue/AGENT.md`: footnoted as the standing-monitor exception (bash daemon's state persists; LLM ticks still get fresh garden+journal each dispatch; review-queue has no project worktree at all).
- `.gitignore`: `/dispatches/` added alongside `/journal/` and `/worktrees/`.

Smoke-tested before commit: `dispatch-prepare.sh test smoke endojs/endo master` created and `dispatch-teardown.sh` cleanly removed all three worktrees. The garden HEAD was `e15f9d2` (the container scaffolding commit also landed this turn), journal HEAD was `6d4afd6` (the parallel steward's hand-off mirror), project HEAD was `052b0487e`.

Concurrency notes for this engagement: the steward is running in another terminal session; while I worked, it pushed `cb822d1` and `ec86c01` on `main` (boatman role tightening) and `6d4afd6` on `journal` (prior-steward hand-off mirror). My commit rebased cleanly atop both lines. The push-rejected-retry pattern in journal-sync handled the journal contention transparently.

Standing-monitor migration: not done in this engagement. The four `watch-<slug>--monitor--<ts>` standing worktrees and their bash daemons remain unchanged; they are the documented exception to the new norm. A future refactor could move the daemon's etag and last-event-id state outside any worktree (e.g. into `/tmp/garden-monitor-<owner>-<repo>/state/`), at which point the standing worktrees would become collectable. Not urgent.

Self-improvement: a third standing-watcher role would justify lifting "long-running bash daemon + LLM wake on log change" out of `roles/monitor/AGENT.md` and `roles/review-queue/AGENT.md` into a shared `skills/poll-daemon-with-llm-wake/SKILL.md`. Two examples is not yet a pattern; the third one is the trigger. I left a note in `roles/monitor/AGENT.md` § Architecture pointing at the shared shape.

Self-improvement: roles/COMMON.md and skills/journal-sync/SKILL.md, plus CLAUDE.md and WORKTREES.md; codified subagent isolation as the standing norm and parameterised the journal worktree path so the same skill works for orchestrators and subagents.
