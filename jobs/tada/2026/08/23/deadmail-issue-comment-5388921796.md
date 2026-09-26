All work is complete and verified. Inbox is empty. Let me summarize.

## Completion report

**Job:** Dead-lettered maintainer directive on kriscendobot/garden#58 (kriskowal, [comment 5388921796](https://github.com/kriscendobot/garden/issues/58#issuecomment-5388921796)): *"If we see that there are no next steps twice, or that we have spent half our weekly token budget on the press, just park the scheduled press."* The addressee (`issue-kriscendobot-garden-58`) had completed; I picked up its intent.

**What "the press" is.** The `minion-town-agenda-review` schedule — a two-hourly press driving the minion.town primary-phase agenda (issue #58), 100k token-budget/tick. The comment is a policy directive to make it self-park when unproductive or too expensive.

**What I did — encoded it as a deterministic park gate** (garden-idiomatic, modeled on the existing `xs2rust-endor-press-preflight` circuit-breaker precedent):

- **`scripts/jobs/minion-town-press-preflight.sh`** (new) — a no-LLM scheduler preflight that parks the press (advances the clock, dispatches nothing) when either:
  - **IDLE** — the two most-recent press ticks both report `press-status: no-next-step` ("no next steps twice"). Sticky until resumed.
  - **BUDGET** — press-attributed billable tokens over the trailing weekly window reach half of `GARDEN_TOKEN_WEEKLY_QUOTA`. Self-recovering as spend ages out; inert when no quota is configured.
  - Fails **open** on any ambiguity (unreadable journal, unset quota, <2 marked reports) — parks only on a positively-observed condition; pages the maintainer once per episode.
- **`scripts/jobs/resume-minion-town-press.sh`** (new) — writes a per-host resume watermark to un-stick an idle park once blockers clear.
- **`scripts/jobs/test/minion-town-press-preflight-test.sh`** (new) — 15-case hermetic test (idle streak, streak-break, deploy-transition history, resume, budget over/under/aged-out, never-park-on-unreadable-journal). All pass.
- **Schedule body (journal2)** — added the required `press-status: advanced|no-next-step` end-of-report marker instruction + the park-policy note, and wired `preflight: minion-town-press-preflight.sh`. `last_dispatched`, `handler-timeout`, and the routing frontmatter were preserved.

**Landed:** main2 at `8501ccb2c1` (pushed); schedule change live on journal2.

**Replied on the issue:** https://github.com/kriscendobot/garden/issues/58#issuecomment-5389010721 (issue left open per standing instruction).

**Follow-up (owned by existing automation, not this job):** the gate is on `origin/main2` but not yet in the deployed root, so it **activates on the next garden deploy** (the liaison's deploy-on-upgrade Monitor). Until then the press runs unchanged and the scheduler logs one benign deploy-lag notice for the not-yet-deployed preflight — expected and self-healing. No memory written (the mechanism is fully recorded in code, the schedule, and the issue).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5388921796.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (6116999 cached reads)
- Output: 70270 tokens
- Cost: $6.389102500000001
- Wall-clock: 1010s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
