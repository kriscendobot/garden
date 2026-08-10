# Design: deadline-approaching nudges for claimed jobs

| Created | 2026-08-10 |
| Author | designer |
| Status | Proposed |

## Problem

A gardener gets one wall-clock window in which to finish a claimed job. When the
window closes, `gardener.sh` terminates the handler. A non-productive wall hit
earns `<!-- garden-deadline-overrun: N -->` and `<!-- garden-reap-now -->`; the
reaper then requeues or doom-parks the job. The agent currently learns none of
this while it still has time to finish a small last step, preserve progress, or
write a `## Follow-ups` section for `garden-follow-up` to consume.

The claim TTL is not usually the deadline the agent experiences. Ordinary roles
run under a 2400 second handler budget, builder roles under 7200 seconds, and an
explicit `handler-timeout:` may override either within the claim ceiling. The
default claim TTL is 14400 seconds. A nudge sent only when the claim is fifteen
minutes from its TTL would therefore arrive hours after an ordinary handler had
already stopped.

The inbox also is not a live input stream. `gardener.sh` drains it once before
starting the handler. The shared worker prompt tells the agent to call
`inbox-read.sh <base>` at natural checkpoints, but neither
`handlers/gardener-claude.sh` nor `handlers/cleric-codex.sh` reads it again. Both
run one headless CLI process with the initial prompt fixed at launch. A message
committed while that process is running becomes visible only if the agent itself
polls. There is no current garden hook that pushes it into an active model turn.

## Goals and non-goals

The mechanism should:

- place one short warning in the claimed job's own inbox while useful time
  remains;
- key delivery to a particular claim attempt so retries, timer ticks, and leader
  handoffs do not duplicate it;
- use the same handler-budget calculation as the runner;
- remain independent of the reaper's cycle counters and requeue decisions; and
- disappear harmlessly when journal delivery is unavailable or the attempt ends
  during the send.

It does not extend a deadline, complete a job, create a follow-up by itself,
interrupt a handler, or decide that partially finished work is complete. It also
does not promise immediate model-context delivery. That requires a separate,
backend-specific runner capability described below.

## Decision

Add a deterministic, leader-only `garden-deadline-nudge` oneshot and timer. The
timer scans `jobs/doin/` once per minute from its own journal clone and performs a
conditional inbox append. It runs no LLM.

Do not fold this into `reaper.sh`. The reaper's ten-minute cadence is as long as
the useful lead window for an ordinary job, so it can miss the warning entirely.
The reaper also owns the higher-risk batch transition from `doin/` to `todo/` or
`plan/`. A failed courtesy message must not lengthen, fail, or complicate that
transition. A separate timer gives the nudge its own cadence and lets the whole
path fail open.

The service is leader-only for the same reason as the reaper: all claims are in
one shared journal, so one scanner covers every host. The deterministic message
identity still makes a leader handoff safe if old and new ticks overlap.

## Deadline and lead-time calculation

The warning targets the handler wall, not the later stale-claim reap:

```
attempt_deadline = claimed_at + applied_handler_budget
remaining        = attempt_deadline - now
fractional_lead  = floor(applied_handler_budget / 4)
lead             = min(900, max(2 * timer_interval, fractional_lead))
```

With a 60 second timer interval, the defaults are:

| Job budget | Lead | Result |
| --- | ---: | --- |
| 2400 seconds (ordinary role) | 600 seconds | warn with about 10 minutes left |
| 7200 seconds (builder role) | 900 seconds | cap at 15 minutes |
| 10800 seconds (explicit heavy job) | 900 seconds | cap at 15 minutes |

The fractional term prevents a fixed lead from consuming most of a short custom
budget. The two-tick floor gives the timer two chances to observe a small window.
If the whole budget is shorter than that floor, the first tick sends immediately;
such a short attempt has little room for a useful warning.

The timer sends when `0 < remaining <= lead`. If it first observes an attempt
after the calculated deadline, it does nothing. `claimed_at` starts slightly
before the handler's `timeout` wrapper, so the displayed remaining time is a
conservative approximation rather than a promise of an exact kill second.

The implementation must move the applied-budget calculation into one helper in
`common.sh` and make `gardener.sh`, `reaper.sh`, and the nudge scanner use it. The
helper applies the per-role base, validates an explicit `handler-timeout:`, and
applies the `GARDEN_CLAIM_TTL - GARDEN_HANDLER_KILL_AFTER - 1` clamp. Three copies
of that arithmetic would eventually drift, and a late nudge is the mildest
failure such drift could cause.

The timing knobs are environment-overridable, with shipped defaults of 60 seconds
for the timer interval, one quarter for the fractional lead, and 900 seconds for
the fixed cap. Invalid values disable that tick with a local log line. They never
fall back to arithmetic that could make the timer fail repeatedly.

## Attempt identity and conditional delivery

A claim attempt is identified by this tuple from the committed claim block:

```
(base, claimed_at, host, worker_kind, gardener)
```

The message ID is `deadline-nudge-` plus a short SHA-256 digest of that tuple.
One attempt therefore receives at most one nudge even when:

- the timer observes the lead window on several ticks;
- a CAS push is retried;
- the agent has already moved the message from `unread/` to `read/`; or
- the leader changes during the window.

A requeued and reclaimed basename has a new `claimed_at`, so it is a new attempt
and may receive one new nudge. The reaper removes the old attempt's inbox during
requeue, and claim creates the new inbox. No nudge is carried across the cycle.

The append must be conditional on the same tuple still occupying
`jobs/doin/<base>.md` after every sync. Checking once and then calling today's
unconditional `inbox-send.sh` is not sufficient: the old attempt could be reaped
and the basename reclaimed between those operations, causing an old warning to
land in the new attempt's inbox. Implement either a conditional mode in
`inbox-send.sh` or a small sender inside the nudge service that, on every CAS
retry:

1. syncs its dedicated clone;
2. verifies the complete claim tuple;
3. verifies the deterministic ID is in neither `unread/` nor `read/`;
4. writes only `inbox/<base>/unread/<id>.md`; and
5. commits and pushes, retrying contention from step 1.

If the claim changed, the inbox vanished, or the attempt completed, the send is
a successful no-op. It must never use parked-inbox staging or dead-letter fallback:
a deadline warning for a dead attempt must not become a future job. If the shared
`inbox-send.sh` gains this mode, it should combine a claim-tuple precondition with
`GARDEN_NO_DEADLETTER=1` and the existing deterministic `GARDEN_MSG_ID` behavior.

One timer tick may batch all newly due messages in one commit, provided a rejected
push causes the entire due set and every claim precondition to be recomputed.

## Message shape

The file uses ordinary inbox frontmatter plus machine-readable nudge fields:

```
from_host: <leader-host>
from: deadline-nudge
sent_at: <ISO-8601>
kind: deadline-nudge
claim_attempt: <digest>
deadline_at: <ISO-8601>
remaining_seconds: <integer observed before the send>
---
Deadline nudge: about <N> minutes remain in this attempt. Wrap up now. If the
remaining work is separable, finish the current unit honestly and record the next
job under `## Follow-ups`; garden-follow-up consumes that section. Preserve and
commit safe progress before the wall. Do not emit the completion signal while the
current job's core deliverable is unfinished.
```

The body stays under four sentences. The absolute deadline supports diagnosis
after the fact; the rounded remaining time is the actionable value. The warning
names both safe paths: finish, or leave an actionable follow-up after honestly
closing the current unit. If neither is possible, committing progress and
withholding the completion signal lets the ordinary productive-cycle resume path
carry the attempt forward.

## Delivery to a running agent

### Baseline: inbox delivery at the next checkpoint

The implementable baseline is journal delivery plus the existing explicit poll.
The startup prompt already tells every backend to drain its inbox at natural
checkpoints. No additional claim or message-bus contract is needed. The nudge is
useful when the agent reaches such a checkpoint during the lead window, and it
remains visible to a resumed turn until the inbox is removed.

This is not true mid-turn injection. Committing a file cannot add tokens to an
already running `claude -p` or `codex exec` context. The CLI's Monitor facility is
used by the interactive liaison session, not by these headless job handlers, and
the garden has no Monitor attached to each claimed job.

### Rejected fallback: signal and resume

Do not send `SIGINT` or `SIGTERM` merely to make the model read the warning. The
current spine classifies signal exits as transient, reaps the process group, and
hands the claim to the reaper. Interrupting at the warning boundary would spend
the remaining window on recovery, could cut a tool operation in half, and would
turn a courtesy mechanism into a new source of requeues.

### Future immediate-delivery adapter

Claude Code 2.1.220 advertises `--input-format stream-json` as realtime streaming
input, but the production handler passes a fixed prompt argument and uses final
JSON output. The repository contains no proof that a second user message written
while the agent loop is active is delivered at a safe turn boundary, nor whether
it queues or interrupts an in-flight tool. Codex's current `codex exec` handler has
no corresponding garden integration.

Immediate delivery should therefore be a later backend-adapter capability, not a
condition of the baseline nudge. A Claude spike may replace the fixed prompt with
a supervised stream, keep stdin open, and enqueue the same nudge after it has been
committed to the inbox. It must preserve output accounting, completion-sentinel
parsing, session resume, process-group cleanup, and the outer wall-clock timeout.
The Codex adapter needs its own proven steering surface. Until both are tested,
the shared contract remains `queued-in-inbox`, never `observed-by-running-model`.

## Scope

Enable the scanner for every claimed job on the shared worker spine, independent
of task `role:` or worker kind. The need to wrap up is generic, and every current
agent-backed kind receives the same message-bus prompt. Builder and web-builder
get a longer absolute budget but still benefit from the 15-minute cap. Ordinary
roles all share the 40-minute base, so there is no role whose configured deadline
justifies a special exemption.

The mechanism does not cover inner, unclaimed `claude -p` calls such as individual
panel seats. They have no job inbox or independent claim deadline. It also does
not cover deterministic services that claim no jobs. A test or operator may
disable the timer globally; there is no per-role opt-in in the initial design.

Very short explicit handler budgets get an early warning but little value from it.
That is a property of the chosen job budget, not a role classification, and does
not warrant another policy field.

## Reaper and marker interaction

The nudge service treats the job body as read-only. It never writes or strips:

- `<!-- garden-reaped: N -->`;
- `<!-- garden-deadline-overrun: N -->`;
- `<!-- garden-reap-now -->`;
- productive-cycle or outage-cycle hints; or
- the trailing claim block.

Its successful diff is confined to the attempt's inbox. A claim already carrying
`garden-reap-now` is skipped because its handler is known dead and the reaper owes
an early transition. A deadline-overrun marker normally rides with that hint, so
the nudge cannot perturb overrun counting or doom classification.

Journal fetch, parse, commit, and push failures are local diagnostics only. The
oneshot exits successfully after logging and waits for its next timer tick. It
does not alert the maintainer, write a progress entry, retry without a bound, hold
the reaper's clone lock, or fail another unit. Missing a courtesy warning is safer
than blocking claim recovery.

## Implementation outline

1. Extract the applied handler-budget helper into `common.sh` and replace the
   runner and reaper copies with calls to it.
2. Add `scripts/jobs/deadline-nudge.sh` with a dedicated clone, claim-tuple parser,
   lead calculation, marker skip, and conditional deterministic inbox append.
3. Add a leader-gated `garden-deadline-nudge.service` and an absolute-calendar
   one-minute timer. Render, install, enable, and singleton-test them with the
   existing unit machinery.
4. Add the nudge fields to the message-bus documentation and state plainly that
   observation still depends on `inbox-read.sh`.
5. Add an operator knob to disable the courtesy timer without draining workers or
   changing any job body.

## Test plan

- Budget table tests: ordinary, builder, valid shorter and longer override,
  invalid override, and claim-ceiling clamp all match the runner's applied value.
- Boundary tests: no send above the lead, one send inside it, no first send at or
  after the calculated deadline, and immediate send for a budget shorter than the
  two-tick floor.
- Idempotency tests: repeated ticks and an unread-to-read move leave one file for
  the attempt; an overlapping leader tick computes the same ID.
- Requeue tests: a new `claimed_at` receives a new ID, the old inbox does not
  survive, and an old sender racing the new claim cannot append to the new inbox.
- Completion and reap races: a disappearing or changed claim is a quiet no-op and
  creates neither dead mail nor a board job.
- Marker hygiene: compare the job body byte for byte before and after a send and
  exercise `garden-reaped`, deadline-overrun, reap-now, productive, and outage
  markers. Reap-now attempts receive no nudge.
- Failure tests: unavailable origin, exhausted push retries, malformed claim time,
  and invalid timing knobs exit without changing the board or failing the reaper.
- Delivery test: a sleeping stub handler does not magically receive context; an
  explicit `inbox-read.sh` during the lead window prints the warning and moves it
  to `read/`. This pins the baseline's actual guarantee.
- If immediate Claude delivery is pursued, add a live-CLI acceptance test proving
  safe-boundary delivery plus unchanged report extraction, usage capture, resume,
  timeout, and completion-sentinel behavior before enabling it.

## Open questions

1. **Can Claude Code's realtime `stream-json` input safely enqueue a second user
   message during an active agent loop without interrupting an in-flight tool?**
   The installed CLI advertises the input mode, but the current garden does not use
   or test it. This blocks only the optional immediate-delivery adapter, not inbox
   delivery.
2. **What supported steering surface should the Codex handler use for equivalent
   immediate delivery?** `codex exec resume` covers a later invocation, not a
   demonstrated write into the process that is already running. Until this is
   answered, backend-neutral semantics stop at the inbox.
3. **Should the fixed lead cap remain 15 minutes after production data exists?**
   The proposed fraction keeps the initial value proportional, but the cost ledger
   can later show whether agents actually finish or produce follow-ups after a
   warning. Tune from those outcomes rather than adding repeated messages now.
