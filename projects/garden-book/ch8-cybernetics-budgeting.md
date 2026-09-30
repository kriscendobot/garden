---
created: 2026-09-30
author: gardener (job book-ch8, orchestration garden-book-orch)
grounded-on: main2 2a5c1991779, journal2 as of 2026-09-30
---

# Chapter 8: Cybernetics and budgeting

A garden spends money. It runs model inference on subscriptions that have
weekly and session quotas, and on metered API keys that bill by the token. Most
agent systems handle cost with a ledger and a hard cap. The garden treats it as
a control problem instead: spend is measured, the measurement is fed back into
the decisions that cause spend, and several separate loops run at different
speeds and with different authority.

This chapter describes those loops as they exist on `main2` today. It follows
the current operator map,
[`context/operations/cybernetics.md`](../../context/operations/cybernetics.md),
checked against the scripts. Two design documents give the rationale:
[`designs/cybernetics-audit.md`](../../designs/cybernetics-audit.md), a
systemic audit from 2026-09-01, and
[`designs/cybernetics-economic-resilience.md`](../../designs/cybernetics-economic-resilience.md),
the accepted follow-up. Both begin with a dated "implementation status"
section. Read everything after that section as history, not as a description of
today's code.

## 8.1 Why "cybernetics"

The audit's unit of analysis is the **feedback loop**. Each loop has a sensor,
a setpoint, a controller, an actuator, and the world it acts on, which the
sensor then reads again. For each loop the audit asks five questions:

- What is measured, and how closely does it track the quantity being
  regulated?
- How fast does the loop act, and how hard?
- What does it do when the sensor is wrong or missing?
- What keeps it from oscillating, saturating, or fighting a neighboring loop?
- Who is the controller when the loop is a human?

Budget is one of several quantities regulated this way (latency, disk, and
deploy health are others), but it is the one with the most loops. Spend state
feeds back into the fleet in four places, each with its own time constant:

| Loop | Sensor | Actuator | Speed |
| --- | --- | --- | --- |
| **Admission** (`claim-job.sh`) | the pool's metered spend vs its high-water mark | refuse this claim tick | every claim attempt |
| **Pacing** (`foreman.sh`) | board depth, host quota status, fleet pool status | promote or generate work, or hold | 5-minute timer |
| **Leveling** (`budget-level.sh`, `worker-derotate.sh`) | per-subscription spend, reset-window slack, host heartbeats | per-host monk/cleric counts | scheduler tick (15 min) |
| **Per-job and per-campaign budgets** (reaper, `orchestrate.sh`) | a job's or campaign's own token ledger | hold, requeue, or stop promoting | per reap / per orchestration step |

A single static cap would be simpler, and the garden's history shows why it
does not work. A cap that is too low wedges the fleet. The audit (§ 2.3) records
a leader host sitting in permanent backoff for days against a 5M-token
placeholder cap whose own header read "PLACEHOLDER CAPS — NOT CALIBRATED". A
cap that is missing or reads as empty lets spend run unbounded. On 2026-09-04 a
host ran about nineteen hours on a temporary API key whose pool was marked
`unmetered`. Admission failed open and roughly $1,090 was spent before anyone
noticed. The layered loops exist so that each failure mode has a loop that
catches it, and so that each loop's gain matches how much its sensor can be
trusted.

Three design rules from the audit recur through the rest of this chapter:

1. **"No signal" is not "zero spend."** The audit's § 2.2 found two meter paths
   that printed a confident `0` when the sensor was blind (a missing log
   directory, an empty `usage/` tree). The leveler of that time turned zero
   spend into maximum workers, so a blind sensor scaled the fleet up. Today
   every loop separates `off` (no budget configured), `unknown` (sensor
   unreadable), `ok`, and `backoff`, and handles each explicitly.
2. **An uncalibrated setpoint must not drive a full-authority actuator.** Pool
   caps carry provenance. A placeholder cap is refused, not obeyed.
3. **Actuate gently.** The original leveler jumped from 4 workers to 1 in a
   single 15-minute tick on a sensor up to 45 minutes stale (audit § 5.1). The
   current leveler moves one slot per step and needs confirmations before it
   raises. The pattern comes from the scaler's backend probe, which the audit
   called "the fleet's only hysteresis."

## 8.2 Subscription accounting

### Pools follow the subscription, not the machine

Budget is keyed to **the account that pays**, not the host that spends. Two
journal files define this.

**`config/budget-pools`** has one row per pool: name, provider, kind, cap,
calibration provenance, and calibration date. As of this writing:

```text
claude-endolin1  anthropic  weekly-tokens  143000000  manual-regression-fresh-contiguous-cluster  2026-09-04T22:10:57Z
claude-endolin2  anthropic  weekly-tokens   64000000  manual-single-point-first-fresh-pair        2026-09-05T11:44:00Z
claude-oros      anthropic  weekly-tokens   73000000  manual-single-point-fresh-pair              2026-09-17T02:06:49Z
codex-endolin    openai     percent              100  codex-cli-rate-limit                        2026-09-28
```

Pool kinds are `weekly-tokens`, `weekly-usd`, `percent` (a provider-reported
usage percentage, as Codex exposes), and `unmetered`.

**`config/subscription-mapping`** maps each `(host, worker kind)` consumer to a
pool:

```text
claude-endolin2  endolin-garden2-5bcdff64  monk
codex-endolin    endolin-garden-ece02cb4   cleric
codex-endolin    endolin-garden2-5bcdff64  cleric
...
```

The mapping is many-to-one. In the example above, two hosts' clerics draw on the
same `codex-endolin` subscription. A host's own spend is therefore not the
whole bill. Before reading one host's numbers as the account's total, check the
mapping.

### The meter

[`scripts/jobs/usage-meter.sh`](../../scripts/jobs/usage-meter.sh) is the
sensor, and it reads Claude Code's own session logs. The Admin Usage & Cost API
covers API-key/Console billing only, so it does not apply to subscriptions and is
deliberately not wired. Each host publishes its contribution under
`budget/live/<subscription>/<host>`. A pool's spend is the sum of its hosts'
contributions within the subscription's reset window. Each subscription has its
own reset window, with independent reset facts under `budget/reset-events/`.
There is no global "Friday 21:00" reset any more. The audit found that anchor
hardcoded, and it was replaced.

The same `budget/live` snapshot serves as a **heartbeat**. A host that stops
publishing it is treated as offline. Worker derotation (§ 8.3) relies on this.

### Calibration: why a pool must be metered *and* calibrated

The meter counts tokens. The subscription's real limit is a percentage shown on
a human-facing dashboard. **Calibration** relates the two.
`append-quota-checkpoint.sh <subscription> <weekly-percent> [session-percent]`
pairs a dashboard reading taken by a human with the summed host contributions
in the freshest sample's reset window. Samples from mismatched windows are
excluded and listed in `meter_hosts`. The oldest included sample sets the
pairing time. If the samples span more than 900 seconds, confidence is lowered.
Corrections are append-only: a new row carries `supersedes` pointing at the old
`checked_at`. `fit-quota-calibration.sh` fits a cap from the checkpoints and
skips superseded rows. The provenance strings in the pool file
(`manual-single-point-fresh-pair`, `manual-regression-fresh-contiguous-cluster`)
record which fit produced each cap.

A checkpoint only measures. It never changes a cap or a worker count by itself;
promoting a fitted figure to the pool file is a deliberate
`set-budget-pool.sh` act.

The admission rule follows. At claim time, `pool_admits` returns one of
four verdicts:

| Verdict | Meaning | Claim gate |
| --- | --- | --- |
| `refuse` | pool is configured but has **no trustworthy ceiling**: kind `unmetered`, or provenance in the uncalibrated set (`''`, `-`, `none`, `placeholder`, `uncalibrated`, `seed`, `tbd`, `todo`), or the inference source is unrecognized | **fail closed**: exit 3, one deduplicated maintainer alert naming the exact `set-budget-pool.sh` remedy |
| `backoff` | calibrated pool at or over its high-water mark | decline this claim tick |
| `unknown` | configured and calibrated, but the meter can't be read | **fail open**, with a WARN and a decision record |
| `off` / `ok` | no pool configured for this provider / under the mark | admit |

Each asymmetry here comes from a specific incident. An **unmetered or
uncalibrated** pool fails closed because a ceiling nobody trusts bounds nothing;
the $1,090 incident is quoted in the code comment. An **absent** pool row means
budgeting is deliberately off for that provider. A **blind sensor** fails open
because wedging the fleet on a broken meter would turn a monitoring fault into
an outage. The fail-closed halt is made loud and explicit so it never looks
mysterious. The leveler handles a sensor failure differently: it **holds** the
current allocation and does not treat unreadable spend as zero (§ 8.3).

The high-water mark is the pool cap multiplied by `GARDEN_TOKEN_BACKOFF_FRACTION`.
The code default is 0.85. When the environment doesn't set the fraction,
`config/token-backoff-fraction` in the journal supplies it; that file currently
reads `0.95`. `set-token-backoff-fraction.sh` validates and writes the file, and
can run as a one-shot schedule preflight hook so a change takes effect at a
chosen time (exit 2 means "written, no job needed").

A cruder ceiling sits under all of this. `claude_call_budget_usd` gives every
single `claude -p` invocation a hard per-call USD cap by tier: $4 for myrmidon,
$10 for minion, $20 for mentor, $40 for mentat. The cap shrinks (never grows)
as the provider's seven-day headroom shrinks, down to a $0.50 floor. It is a
seat belt for a runaway call, not a planning tool.

## 8.3 Worker-count leveling and derotation

### Declared counts, effective counts

Each host's `hosts/<host>` journal file declares `monks:` (native Anthropic,
Claude Code) and `clerics:` (OpenAI, Codex) counts. The per-host
`garden-gardener-scaler` reconciles the declaration into running
`garden-monk@N` / `garden-cleric@N` systemd units. A backend-health probe then
gates the declared count: after one passing probe the effective count ramps up
to the declaration, and after two consecutive failures it drops. So even a
declared count is only an upper bound.

An operator sets counts with `scripts/jobs/set-workers.sh monk|cleric <count>`
(or `set-monks.sh` / `set-clerics.sh`). The setter is **local-only**: its
optional `[host]` argument must equal this host's `GARDEN` identity. To change
another host, send it a message instead (below).

### The leveler

With `config/worker-leveling` in place, the leader's
[`budget-level.sh`](../../scripts/jobs/budget-level.sh) turns budget state into
those declarations. The current file reads:

```text
monk-fleet-ceiling    10
cleric-fleet-ceiling  0
host  endolin-garden-ece02cb4      4  4
host  endolin-garden2-5bcdff64     4  4
host  oros-studio-garden-ce242c49  0  0
```

**Monks** share one fleet ceiling, split by bounded largest-remainder
apportionment. Every mapped host gets a floor of one (by default), and no host
exceeds its physical cap. A host's weight is its calibrated cap multiplied by
`1 + 19 * pacing_bias`. The **pacing bias** rises toward 1 when the fraction of
quota remaining is larger than the fraction of the reset window remaining, which
means the subscription is under-spending relative to the clock. Unused quota
near a reset can therefore earn up to 20 times the base weight. The loop pushes
toward "use it before you lose it" as well as braking overspend.

Inside each allocation, a proportional target is computed from spend against
the high-water mark:

```text
target = lo + round((1 - spend / (cap × fraction)) × (hi - lo))
```

It is clamped to `[lo, hi]` and raised to the pacing target when the bias calls
for more. A ceiling is a permission, not a promise that every slot is busy.

**Clerics** use an envelope that follows active claims plus eligible queued
demand, with a small idle reserve. The envelope respects provider, role, and
host constraints. It does not count manual mentat jobs as automatic demand. It
never shrinks below an active higher-numbered cleric slot, because stopping a
working slot would kill in-flight work.

**Actuation** is hysteretic by default. It moves one slot per step. A raise
needs two same-direction observations; a lower needs one. Reaching the target
resets the streak, and a change of direction starts a new streak. If the monk
configuration is malformed, raises freeze, but a calibrated over-budget host can
still step down toward its floor. The leader's drain suspends leveling. Freeze
and recovery notices are edge-latched, so the maintainer gets one message per
transition, not one per tick. Remote hosts change only through the **benign
sysop `set-workers` op**, never through a cross-host edit of `hosts/<host>`.
This closes the audit's § 4.1 finding, "five writers, one count line, no
arbitration."

### Derotation: a quiet host gives its share back

A budget allocation spent on a host that isn't running is wasted.
[`worker-derotate.sh`](../../scripts/jobs/worker-derotate.sh), added on
2026-09-28, runs just before the leveler in the same leader-only scheduler
tick. It uses the `budget/live` heartbeat through the `host_liveness`
predicate in `common.sh`, which it shares with the rolling-deploy canary.
`GARDEN_HOST_OFFLINE_AFTER` sets the threshold. Derotation works in five steps:

1. A host whose heartbeat is stale past the threshold on **two consecutive
   ticks** has its `host` row in `config/worker-leveling` zeroed.
2. The same commit records the host's exact prior caps in
   `worker-derotate/<host>`.
3. The leveler then quietly leaves the host out, and the live hosts absorb its
   share of the fleet ceiling.
4. When a fresh heartbeat returns, the prior caps are restored and the marker is
   dropped.
5. Each episode posts one notice and one recovery.

The oros row above is a live example. On 2026-09-30 the liaison's muster
handled the derotation notices by hand, and at the time of writing the marker
still stood:

```text
host: oros-studio-garden-ce242c49
reason: heartbeat-offline
prior_monk: 4
prior_cleric: 0
derotated_at: 2026-09-30T02:35:06Z
derotated_by: endolin-garden-ece02cb4
detail: heartbeat stale by 3377s (offline threshold 1800s; ...)
```

That row reads `0 0` because the mechanism zeroed it. When oros heartbeats
again, `4 0` returns without anyone acting.

The ownership rules make derotation safe alongside human operators:

- Only rows the marker owns are restored. A row an operator zeroed by hand
  stays zeroed.
- If an operator re-sets a derotated row, the marker is relinquished and the
  operator's value stands.
- To hand a hand-zeroed row to the mechanism, run
  `worker-derotate.sh adopt <host> <monk> <cleric>`. `worker-derotate.sh status`
  lists the markers.
- A missing or unparseable heartbeat counts as **unknown**. The host is neither
  zeroed nor restored.
- If the leader's own heartbeat reads stale, the tick freezes. The leader
  doesn't trust a sensor that says it is itself offline.

**Known gap.** The heartbeat measures liveness, not claiming. A host that still
heartbeats but doesn't claim keeps its allocation: one that is drained, has
wedged workers, or is stuck in a deploy. The leader's drain guard doesn't solve
this. Treat allocation as heartbeat-live capacity, not claiming capacity.

### Remote operations: the sysop

Leveling across hosts requires something that can act *on* a follower when no
human is sitting at it. That is the **sysop**
(`scripts/jobs/sysop.sh`, [`designs/sysop.md`](../../designs/sysop.md)). It is a
deterministic per-host daemon that runs no LLM. It reads only
`msgs/host/<its-own-GARDEN>` and runs a closed vocabulary of ops on its own
host:

- `set-workers`
- `drain`
- `reset-failed`
- `restore`
- `unit`
- `deploy`
- `local-model`
- `maintain`

Because each op runs *on* the target host, the sysop respects
`set-workers.sh`'s cross-host refusal instead of bypassing it. It runs on
**every** host, unlike the leader-only singletons below. It keeps ticking under
drain, so a drained host can always receive its own `drain off`.

Journal push access is the authorization boundary for benign ops such as
`set-workers`, `drain`, and `restore`: any garden host may send them to any
other. The **destructive** ops need maintainer attestation, an `authorized_by:`
naming someone on `maintainers/allowlist`. Those ops are `unit`, `deploy`,
`local-model` (a model pull can fill a follower's disk), and `maintain` (which
breaks a stale gc lock and repacks the shared root repository). Ferrying and any
identity switch are permanently outside the vocabulary. Every op is idempotent,
logged to `sysop-log/<GARDEN>/<msgid>.md`, and acknowledged. Send one with
`scripts/jobs/send-host-op.sh <GARDEN> op=… key=…`.

### Who runs the controllers

The leveler, derotation, foreman, scheduler, and watchers are **singletons**.
None of them tolerates a concurrent duplicate: two levelers would fight over
count lines, two foremen would double-pump, two schedulers would double-dispatch.
They run only on the **leader**, and `scripts/jobs/is-main-host.sh` gates them
against the journal's `leader` marker. Gardeners (monks and clerics) run on
every host and race-claim safely through the job-board push compare-and-swap.
Moving the marker with `set-main-host.sh` moves every budget controller with it.
The journal-backed foreman brake (`config/foreman-brake`) moves with it too,
because it lives in the journal rather than on a host.

## 8.4 The foreman as pacing actuator

The foreman ([`scripts/jobs/foreman.sh`](../../scripts/jobs/foreman.sh), the
leader-only `garden-foreman` timer) is the fleet's **autonomous spender**.
Watchers post work in response to events. The foreman posts work because the
board is under-full. It is therefore where pacing is applied.

Each tick it counts in-flight work: `jobs/todo/` plus `jobs/doin/`. The count is
compared with `GARDEN_FOREMAN_ACTIVE_TARGET`:

- **At or above target**: the foreman does nothing and clears its settle clock.
- **Below target, but for less than `GARDEN_FOREMAN_IDLE_SETTLE`** (240 s): it
  waits. This keeps it from pumping into the brief dip between one job
  completing and its follow-up being posted.
- **Sustained below target**: it first checks budget:
  - If this host's Anthropic pool is in `backoff`, it pumps nothing. It sends a
    throttled maintainer note and writes a budget-halt decision. The meter only
    sees the Claude subscription, so this gate is skipped when the configured
    provider order lets the handler fall back to OpenAI or the local route.
  - If **every** configured pool is in backoff (`budget_fleet_status`), it stops
    promotion and generation fleet-wide until a recorded reset.
  - An unreadable meter fails open with a WARN, like the claim gate.
- If budget allows, it fills open slots **first by batch-promoting deferred plan
  jobs**. These are pre-approved and cost no model call, and promotion is
  leaf-first by omega rank. Only if none are queued does it run `claude -p`
  wearing the foreman role to generate **one** new milestone step. That step
  may be steered by `config/foreman-mandate`.

Every tick appends one line to `$GARDEN_STATE/foreman/decisions.log`. Before
that log existed, a foreman quiesced at target 0 exited silently every tick for
weeks and could be diagnosed only by live-debugging the unit (job
`investigate-malingering-foreman`, 2026-09-16).

### The active target and why it is 10

The target has moved with quota pressure. The unit file's comment records the
history. The script's own fallback is 5 ("keep ~5 jobs in flight," kriskowal
2026-07-03). The unit pinned it to **0**, quiescing the pump, from 2026-07-14
through quota pressure. It was raised to 2 on 2026-09-16, and to **10** on
2026-09-27. The unit ships `Environment=GARDEN_FOREMAN_ACTIVE_TARGET=10`, and
`CLAUDE.md` and `scaling.md` agree.

The reason for 10 matters more than the number. It covers the fleet's roughly
eight physical worker slots plus a small buffer. The raise was meant to change
**which knob does the braking**. A low concurrency target throttles spend
bluntly and whatever the actual budget state, so the fleet idles even when quota
is available. At 10 the target is effectively "keep the fleet saturated," and
spend is braked by the backoff fraction and pool state, which respond to real
budget. Concurrency is a capacity control; the backoff fraction is the spend
control.

A documentation note: `context/operations/cybernetics.md` and both designs'
2026-09-27 status sections still say "the shipped active target is 2." They were
written just before the raise. The unit file is authoritative.

### Brake, drain, and target: three different levers

| Lever | Scope | Stops |
| --- | --- | --- |
| `brake-foreman.sh on\|off\|status` | journal-backed; follows leadership | **only** the foreman pump |
| `drain-fleet.sh on\|off` | host-local marker | **new claims** on this host; in-flight work finishes ("drain" and "lift") |
| `GARDEN_FOREMAN_ACTIVE_TARGET=0` | unit env / drop-in | the pump, by making every tick "subscribed" |

Drain is a claim moratorium, not a global write lock. On a drained leader the
scheduler has no drain guard and can still dispatch due schedules into `todo/`.
Those jobs sit unclaimed on that host, and undrained hosts may claim them. If
the intent is only to stop autonomous generation, use the brake.

## 8.5 Per-job budgets: wall clock and tokens

Each claimed job carries two separate budgets. They are resolved from the same
role in the same place, `common.sh`, so the gardener that runs the handler, the
reaper that judges staleness, and the deadline nudger that warns the worker
cannot disagree.

### The handler wall (`handler-timeout:`)

`job_handler_budget_base` picks the job's **runtime role**. That is
`handler-budget-role:` if present; otherwise the `gauntlet_stage` (`panel` →
`panel`, `clean`/`fix` → `shepherd`); otherwise the job's `role:`.
`canonical_budget_role` normalizes the alias `fix` to `fixer`. Without that, a
mistyped alias would silently fall through to the 40-minute fleet default. The
`role_default_handler_timeout` table then gives:

| Runtime role/stage | Knob | Default |
| --- | --- | --- |
| `builder`, `web-builder` | `GARDEN_BUILD_HANDLER_TIMEOUT` | 7200 s |
| `fixer` | `GARDEN_FIXER_HANDLER_TIMEOUT` | 7200 s |
| `shepherd` (incl. gauntlet clean/fix) | `GARDEN_SHEPHERD_HANDLER_TIMEOUT` | 7200 s |
| `conductor` | `GARDEN_CONDUCTOR_HANDLER_TIMEOUT` | 7200 s |
| review directive | `GARDEN_REVIEW_HANDLER_TIMEOUT` | 7200 s |
| panel / repanel | `GARDEN_PANEL_HANDLER_TIMEOUT` | 7200 s |
| `botanist` | `GARDEN_BOTANIST_HANDLER_TIMEOUT` | 7200 s |
| anything else | `GARDEN_HANDLER_TIMEOUT` | 2400 s |

Any role that waits on CI or fans out a panel must have a budget longer than
that wait. The CI deadline is 5400 s, so 7200 s covers it.

A strictly positive integer `handler-timeout: <seconds>` in the job body
**overrides** the role default in either direction. A cold `docker build`
typically wants `10800`. The override is **clamped** to

```text
budget_max = GARDEN_CLAIM_TTL − GARDEN_HANDLER_KILL_AFTER − 1
           = 14400 − 60 − 1 = 14339 s  (≈ 3.98 h)
```

and the maintainer is alerted when a request is clamped. The cap is tied to the
claim TTL because of the **single-owner invariant**: the reaper requeues a claim
it considers stale. If a handler could run longer than a claim lives, a second
gardener would claim the same job while the first was still working, and two
workers would run concurrently on one worktree. Work that needs more than one
claim's lifetime must run detached or be split into claim-sized stages. To raise
the ceiling, raise `GARDEN_CLAIM_TTL` in both `gardener.sh` and `reaper.sh`, so
that `budget + kill_after < TTL` still holds.

Only `handler-timeout:` sets the wall. A frequent mistake is writing
`tier: builder`. That is an invalid tier, not a role, so the job silently
receives the default budget. `role:` is the separate field.

### The notional token budget (`token-budget:`)

`role_default_token_budget` assigns **250,000** output tokens
(`GARDEN_TOKEN_BUDGET_LARGE`) to `designer`, `builder`, `web-builder`, `review`,
`panel`, `shepherd`, `conductor`, and `botanist`. Every other role gets
**100,000** (`GARDEN_TOKEN_BUDGET_DEFAULT`). A positive `token-budget:` header
overrides the default.

This budget doesn't cap a single model call. It bounds **repeated resume
cycles**. The wall still decides when a requeue is safe. The token ledger decides
where the job goes after it has hit the wall:

- Output tokens at or above `GARDEN_PROGRESS_MIN_OUTPUT_TOKENS` (2000) since the
  claim, or a productive-cycle marker, means the job is **advancing**. Requeue
  it.
- A job over its token budget becomes a **budget hold**: a `go-ahead` plan with
  `park_reason: over-token-budget`. The leader's `budget-refresh.sh` returns
  that subset to `todo/` after its explicit reset or rolling quota window, and
  it is the only promoter that may.
- Repeated no-progress cycles are **doomed** and parked for a human.

`progress.sh <base>` prints the read-only verdict and budget facts for any job.
`GARDEN_PROGRESS_DOOM=off` restores the older elapsed-only decision.

### Tier is part of cost

`skills/model-selection/SKILL.md` covers the other axis of per-job cost: which
model runs the job. The automatic producers are `post-job.sh` and
`post-plan.sh`, and they normalize every body to `tier: mentor`,
`fallback-tier: minion`, `dispatch: automatic`. Mentor is multi-provider, so a
job runs on whichever pool has live capacity, and the claim gate charges that
pool. The reaper's one-hop reroute on failure never demotes below
`role_tier_floor`: mentor for designer and builder, minion for everything else.
**Mentat**, the most expensive tier (Fable 5, GPT-6 Astra), is manual-only.
It is posted with `post-manual-job.sh`, which stamps `dispatch: manual`, and the
claim predicate and handler both refuse an automatic mentat job. The one
exception is the journal-authorized Ironhorse ratchet watcher, and even that
path is gated by a rolling arc token budget at foreman admission.

## 8.6 Per-orchestration budgets: a bounded pie

The garden's most direct form of "a bounded budget a scheduler draws down"
already exists at the scope of one **orchestration**. See
[`skills/orchestration/SKILL.md`](../../skills/orchestration/SKILL.md) and
[`designs/budgeted-campaign-dispatch.md`](../../designs/budgeted-campaign-dispatch.md).

```sh
post-orchestration.sh --serial --budget-tokens 2080000 <orch-base> <child>...
```

The orchestration record gains `budget_tokens:`. It works like this:

- **Serial only.** Parallel promotion admits every child before any spend
  exists, so there would be nothing to meter against.
- **Checked before each promotion.** Just before promoting the next child,
  the leader's deterministic `orchestrate.sh` freshly sums **billable** tokens
  from the named children's ledgers, counting from the record's `created_at`.
  Billable tokens are input + output + cache creation; cache reads are
  excluded.
- **Exhaustion stops cleanly.** At or over the cap, the orchestration ends
  `budget-exhausted`. The remaining children **stay parked** under their
  `orchestrated` gate. Nothing in flight is killed. A child that was already
  running finishes normally, so a campaign can overshoot by up to one child. The
  terminal report states that overshoot along with the budget, the spend, and
  the non-negative unspent amount.
- **A meter it can't trust stops it.** A malformed or unmetered ledger row ends
  the orchestration `budget-meter-incomplete`, also without promoting anything.
  Here the uncertainty stops spending instead of permitting it, because a
  campaign budget is an explicit authorization.
- **Unspent budget is reported.** Budgeted completion sends the unused remainder
  to the maintainer inbox as a *permission-not-exercised* event.
- **Resume is a new campaign.** `post-orchestration.sh --serial --budget-tokens
  <new-cap> --resume-from <terminal-campaign> <new-campaign> <full-child-list>`
  adopts the parked remainder named in the terminal report's
  `campaign-parked-children:` field. It verifies ownership and re-tags the
  children in one journal commit. An old campaign's budget is never edited or
  refilled in place. Each campaign is its own accounting period.

This mechanism puts a clear boundary around delegated authority: the maintainer
authorizes a quantity of spend toward a named piece of work, the scheduler draws
it down in order, and running out never damages in-flight work.

## 8.7 What's evolving now: the accountant

On 2026-09-30 the maintainer directed that budgeting be **carved into its own
role**:

> we should probably carve an accountant role out of the liaison's and other
> roles' skills and responsibilities regarding budgeting tokens. We are becoming
> increasingly sophisticated with using a budget as a control surface. We should
> have a weekly engagement, triggered by a scheduled message to the maintainer,
> inviting the maintainer to adjust the token budget for the foreman going
> forward, such that the pie gets sliced and apportioned to various arcs the
> foreman can draw from to make progress on prioritized work in the planned jobs.

When this chapter was written, that work was a **queued design job**,
`design-accountant-role-budget-apportionment`, in `jobs/todo/`. No design has
landed in `designs/`, and no `roles/accountant/` exists. Nothing below is
shipped behavior or a decided conclusion. It restates what the design job
asks for:

- A **survey first**, so the role consolidates existing budget duties instead of
  duplicating them. The survey covers everything in this chapter (pools, the
  meter, the foreman's knobs, the budget-hold gate and `budget-refresh.sh`,
  `--budget-tokens`), plus the budget awareness now scattered through the
  liaison's brief and its muster handling of budget watchdog notices.
- **`roles/accountant/AGENT.md`**, scoped narrowly to token economics. The
  design must name exactly which responsibilities leave the liaison and other
  roles.
- A **weekly engagement**: a scheduled inbox message (not a board job) showing
  last week's spend and pacing against the prior allocation and the slate of
  arcs competing for budget, and inviting the maintainer to reslice.
- An **arc-apportionment model**: what an "arc" is as a budget unit, reconciled
  with the existing arc concept (named priority threads tracked by press
  schedules and tracker issues) if that concept is still live. It must also
  cover how the foreman draws against per-arc slices, and what happens when a
  slice runs out mid-week (hold, borrow, or stop), and it must compose with
  `--budget-tokens` rather than duplicate it.
- An explicit **non-goal**: the metering and admission layer
  (`usage-meter.sh`, pools, mappings) stays as it is.

In the terms of this chapter, the accountant would add an **allocation and
priority layer** above the admission and pacing loops. Today the only
setpoints a human sets weekly are pool caps (through calibration) and the
backoff fraction. The foreman draws from one undifferentiated pool, and only an
explicit orchestration gets a bounded budget of its own. The proposal would
generalize the per-orchestration budget to the foreman's own spending, sliced
by priority, with the human re-entering the loop on a fixed weekly cadence
instead of through ad-hoc watchdog notices. How that is actually built belongs
to the design, and a later edition of this chapter should describe it once it
lands.

## Operator quick reference

| Question | Where to look |
| --- | --- |
| Which pool pays for this host's monks? | journal `config/subscription-mapping` |
| What is the cap and how was it calibrated? | journal `config/budget-pools` (provenance column) |
| Why is this host refusing claims? | `claim-job` log; a `refuse` means uncalibrated or unmetered, and the alert names the `set-budget-pool.sh` fix |
| Record a dashboard reading | `append-quota-checkpoint.sh <sub> <weekly%> [session%]` |
| Change the spend brake | `set-token-backoff-fraction.sh` (journal `config/token-backoff-fraction`) |
| Stop autonomous generation only | `brake-foreman.sh on [reason]` |
| Pause claims on this host | `drain-fleet.sh on` / `off` |
| Resize a remote host | `send-host-op.sh <GARDEN> op=set-workers …` |
| Why is a host's leveling row zero? | `worker-derotate.sh status` |
| Why is a job parked `over-token-budget`? | `progress.sh <base>`; `budget-refresh.sh` returns it after reset |
| Why did an orchestration stop early? | its `tada/` report: `budget-exhausted` or `budget-meter-incomplete` |
| What did a controller decide, and why? | `budget/decisions/<week>-<host>.jsonl`; foreman `decisions.log` |
