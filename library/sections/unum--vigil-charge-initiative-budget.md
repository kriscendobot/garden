---
title: The vigil-charge initiative budget
source: devoker/internal/vigil/CHARGE_HEARTBEAT.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 23cb6dd980e4216ca5631f56973134894bc4aa53
source_date: 2026-07-09
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

## Abstract

The **vigil-charge initiative pulse** is unum's budget on *proactive* agent
invocations: rather than firing self-initiated ("initiative") persona work on a
blind wall-clock timer, unum accumulates a **charge** counter — `+1` for each
health round the monitor (vigil) completes having taken no corrective action —
and only when charge crosses a per-persona threshold does it **spend** the charge
to fire one heartbeat pulse. Initiative becomes a *reward for verified
stability*: a busy or unhealthy realm suppresses its own proactive wakes (charge
stops climbing) until it settles. This is a distinctive answer to a cost/spend
question the garden also faces — *when should a fleet spend tokens on work nobody
asked for?* — and its through-line to the token-spend theme is that a proactive
agent turn is itself a token spend, so gating it on a verified-quiet signal is a
spend-discipline. The reusable shape is the concept [[vigil-charge]].

## The signal and the counter

Vigil reaches a single **all-clear** point ("service idle, no pending tasks —
all clear") only after passing every health gate: unit inactive, no failure, no
pending work, nothing stuck, no burst worker mid-task, nothing landing. That is
the **verified-quiet observation** — the single-writer window when the realm
worktree is quiescent. The charge increment lives exactly there.

Because vigil is a systemd **oneshot** (each ~5-minute tick is a fresh process
with no in-memory state), the counter **must be persisted** to a small state
file, read at tick start and written at tick end — the single biggest build risk,
and the reason a naive in-memory counter fails. unum keeps it as
`{charge, updated_at, fired_at}` per persona, and prefers an **orphan/uncommitted**
file: charge is host-local ephemeral liveness bookkeeping, not realm history, so
committing every 5-minute tick would spam the log.

## Charge semantics (a three-way classification)

Vigil's actions are bucketed by their effect on charge — the heart of the design:

| Bucket | Example actions | Effect on charge |
|--------|-----------------|------------------|
| **Health failure / un-run work** (never reaches all-clear) | failed-unit restart; idle-with-pending kick; stale queue; stuck-wake fires | **RESET to 0** — the stability streak is genuinely broken |
| **Convergence housekeeping** (acts *inside* the all-clear window) | reaping abandoned worktrees, releasing stranded claims, consuming decisions, escalating conflicts | **PENALTY: decrement** (`charge = max(0, charge-1)`) — the realm was basically fine, vigil did minor latent cleanup |
| **Busy-but-healthy / neutral** (returns early, not idle, not unhealthy) | a burst worker mid-task; the refinery mid-landing | **HOLD** — no clean sample this tick |
| **Clean round** | reaches all-clear AND no convergence sweep acted | **+1** |

The critical choice is **decrement, not reset, on convergence.** If any in-window
housekeeping reset charge to 0, a lively realm — where there is nearly always
*some* claim to reap or decision to consume — would never accumulate, starving
initiative forever. Decrement lets a busy-but-fine realm still trend slowly
upward while a chronically-churning one hovers near zero. This is a
negative-feedback stabiliser: a pulse authors work → that work creates
claims/merge churn → the next few ticks are busy/convergence → charge holds →
once the work settles, charge climbs again.

## Firing, anti-storm, and liveness

- **Delivery reuses existing machinery.** The pulse fires the *existing*
  `heartbeat` event through the *existing* per-persona routing table — it invents
  no new delivery path, adds only the *trigger* (the charge counter) and its
  state file. Default consumer: `steward` (the initiative actor); `liaison`
  opt-in; the task-driven invoker and the dispatch foreman deliberately stay out.
- **Anti-storm floor.** Firing spends the charge (reset to 0), giving a hard
  wall-clock floor of `threshold × cadence` between pulses per persona (5 × 5min
  = 25min at defaults). The threshold is counted in **rounds, not seconds**, so
  lengthening the vigil cadence lengthens time-to-pulse proportionally.
- **Liveness without a re-fire loop.** Charge resets on **fire** (marker drop),
  not on **completion**, so a hung heartbeat turn does not spin the pulse. To
  avoid a park-forever hole, the pulse marker is TTL'd (self-clears if undrained)
  and armed with an overdue once-latch (surfaces once loudly past 30m, then ages
  out): `fire = spend charge + drop coalesced TTL'd marker + arm overdue latch`.
  Never a silent swallow, never a park-forever. A **staleness guard** treats a
  charge older than `K × cadence` (host was off) as cold → reset to 0, so a stale
  accumulation from days ago cannot fire a spurious pulse on first tick back;
  cold start (absent file) begins at 0, so a crash-restart does not immediately
  fire.

## Relevance to the garden

The garden's proactive spend today is the **foreman** promoting deferred plan
jobs and generating milestone steps when the board idles, gated only by the
fleet-wide weekly token meter
([`usage-meter.sh`](../../../scripts/jobs/usage-meter.sh)) — a *quota* back-off,
not a *health* signal. vigil-charge is a complementary gate: spend proactive
tokens as a **reward for verified stability**, not merely when under quota.
Transferable specifics: (1) accumulate initiative budget only over
verified-quiet observations; (2) decrement rather than reset on minor
housekeeping, or a busy fleet starves its own initiative; (3) persist the counter
(the fleet's schedulers are likewise stateless per tick); (4) make firing
TTL'd + overdue-latched so a hung proactive turn neither re-fires nor parks
forever. See [[vigil-charge]] and the [`agent-fleet-orchestration`](../topics/agent-fleet-orchestration.md) topic.

Source: [`devoker/internal/vigil/CHARGE_HEARTBEAT.md`](https://tangled.org/jcorbin.tngl.sh/unum) at commit `23cb6dd`, unum on tangled.org.
