---
title: The per-run token/compute cost ledger (costs.jsonl)
source: devoker/internal/invoke/cost_record.go
source_repo: jcorbin.tngl.sh/unum
source_commit: e489be2fd0e5ae9301d4495e4b288c9d0e724a80
source_date: 2026-07-05
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [coding-agent-economics]
status: current
---

## Abstract

unum records the token and compute cost of **every** agent evocation as one
JSON line in a gitignored realm-runtime ledger, `<CoordRoot>/<EvokeDir>/costs.jsonl`.
On each live evocation exit, `Engine.recordCost` folds the run's `Usage`
(captured from the Claude CLI's terminal `result` event) plus the run's
**attribution** (session id, trigger, channel, task, model) into one `CostRecord`
appended with `O_APPEND` whole-line writes, so concurrent writers (a forked task
invoker and the in-process channel bot) interleave without a lock. Writing is
**best-effort**: every failure path logs and returns, never aborting the run — a
cost ledger that cannot be written must not wedge an evocation. This section
covers the capture mechanism, the record schema, and the storage discipline; the
[companion section](./unum--cost-attribution-and-aggregation.md) covers how the
ledger is aggregated and surfaced. The reusable shape is the concept [[cost-ledger]].

## Where the numbers come from (capture)

devoker does not consume the raw Anthropic SSE. It runs the **Claude CLI** with
`--output-format stream-json` and parses those events in
`agent_monitor_claude.go`. The CLI accumulates token usage across the
invocation's turns and emits a single terminal `result` event carrying the
cumulative totals and a run-time-computed dollar cost:

```json
{"type":"result","subtype":"success","is_error":false,
 "duration_ms":47213,"num_turns":23,"session_id":"…","total_cost_usd":0.1342,
 "usage":{"input_tokens":12847,"output_tokens":3412,
          "cache_creation_input_tokens":8200,"cache_read_input_tokens":4600}}
```

The **source of truth is the `result` event's `usage`** (already cumulative for
the invocation), not a hand-rolled `message_delta` sum — a deliberate correction
recorded in the design (`TADA/devoker/626`): the CLI does the accumulation, so
devoker stores the CLI's numbers rather than re-deriving them. `observeResultUsage`
folds each terminal `result` into a `Usage` value; a run that spans multiple
`result` events (defensive; normally exactly one) sums them via `Usage.Add`.

**Pricing decision — store both raw tokens and the CLI's dollars.** The CLI
already computes `total_cost_usd` against the live model's rates at run time, so
unum captures it *alongside* the four raw token counts rather than building a
local rate table. Raw tokens stay the source of truth (so a future re-price is
always possible); the dollar figure is available immediately with no rate table
to keep current. The rejected alternative — keep only raw tokens, defer dollars
to a `--cost` flag over a config rate table — is strictly dominated for a
CLI-computed-cost stack, though nothing forecloses adding a rate table later for
counterfactual re-pricing.

## The record schema

One `CostRecord` per **run** (not per session — a context-overflow rotation or a
stale-resume retry is a distinct token spend worth its own row; `invoke cost`
groups by session when a per-session total is wanted):

```jsonc
{
  "session_id": "…",            // attribution: the minted UUID keying the
                                //   Session-Id commit trailer
  "trigger": "vigil-idle",      // what caused the run (omitempty)
  "channel": "steward",         // set for channel/persona turns (omitempty)
  "task": "623_…",              // set for task runs (omitempty)
  "model": "claude-sonnet-4-5", // which model spent the tokens
  "started_at": "2026-06-25T20:08:12Z",
  "duration_s": 47.2,
  "input_tokens": 12847, "output_tokens": 3412,
  "cache_creation_tokens": 8200, "cache_read_tokens": 4600,
  "total_cost_usd": 0.1342, "tool_calls": 23,
  "cpu_user_ms": 331000, "cpu_sys_ms": 74000, "peak_rss_kb": 611000
}
```

`omitempty` on the attribution strings keeps a channel-less task run (or a
task-less channel turn) from emitting bare `"channel":""` noise. The compute
triple (`cpu_user_ms` / `cpu_sys_ms` / `peak_rss_kb`) is the agent subprocess's
`wait(2)` rusage — the **host** compute cost of the run alongside the API-side
token cost — and is `omitempty` (absent on non-Linux builds, shell-mode runs,
and runs where the agent process never started). A run that spent tokens but
later errored at the engine level is **still recorded**: the tokens were spent
regardless of the run's final disposition. A zero-usage run (`Usage.IsZero()` —
shell-mode, dry-run, an error path that never reached a `result` event) writes
**no** row, so a zero-token line never dilutes the aggregate.

## Storage discipline (three load-bearing choices)

1. **CoordRoot, not ActiveRoot.** The ledger lives at
   `<CoordRoot>/<EvokeDir>/costs.jsonl`. A task run is scoped to an ephemeral
   per-task worktree (ActiveRoot) that is reaped when the task finishes; a record
   written there would be lost with the worktree and scattered across worktrees
   besides. CoordRoot is the realm-singleton coordination root (where the
   killswitch and refinery state also live), stable across every run.
2. **Gitignored runtime state, not realm substance.** `costs.jsonl` sits under
   `evoke/` alongside `sessions/` and is gitignored, so the records never ride
   the realm branch — the `invoke cost` reader loads them off local disk, and a
   busy realm's per-5-minute cost rows do not spam the git history.
3. **`O_APPEND` whole-line, best-effort.** The single-line-append discipline (the
   same the session journal uses) lets concurrent writers interleave whole lines
   without a lock; a marshal or IO failure is logged and swallowed so bookkeeping
   never blocks the evocation. The reader (`LoadCostRecords`) tolerates a missing
   file (a realm that never spent tokens → nil, not an error) and blank lines,
   but treats a **malformed** line as a hard error naming the offending text, so
   a corrupt ledger surfaces rather than silently under-counting.

## Relevance to the garden

The garden meters spend today only at the **fleet quota** granularity:
[`scripts/jobs/usage-meter.sh`](../../../scripts/jobs/usage-meter.sh) sums the
fleet's *billable* tokens over a trailing weekly window from Claude Code's own
`~/.claude/projects/**/*.jsonl` session logs so the foreman can back off before a
weekly quota, in plain code with no LLM. That is a throttle, not an **attributed
ledger**: it cannot answer "which job / role / model spent the tokens," has no
per-job persisted record, and offers no operator "where did the spend go" view.
unum's `costs.jsonl` is exactly the complementary layer, and the garden already
has the raw material to build it — every gardener job is a `claude -p` run whose
transcript carries the same `usage` block, and the job base is a natural
attribution key (mirroring unum's `task`). This gap is routed to the liaison as a
self-improvement (see the source index and the cycle result). See [[cost-ledger]].

Source: [`devoker/internal/invoke/cost_record.go`](https://tangled.org/jcorbin.tngl.sh/unum) at commit `e489be2` (with `TADA/devoker/626_devoker_token_cost_tracking.md` @ `f98ff13`, `devoker/internal/invoke/agent_monitor.go` @ `1f96adf`), unum on tangled.org.
