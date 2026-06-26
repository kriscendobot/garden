# Skill: self-healing-wrapper

The canonical playbook for wrapping a deterministic script so that, **on
failure**, it (1) captures the failure output, (2) hands it to a `claude -p`
debugging / self-improvement responder wearing a role/skill specific to the
self-healing task, and (3) proposes or posts a fix — rather than dying silently
and relying on the central [mentor](../../roles/mentor/AGENT.md)'s coarse,
30-minute, fleet-wide journalctl scan.

This is the pattern's single source of truth. It was being re-derived ad hoc:
the [driver](#exemplars) implements the full shape, the v1 `report-error.sh`
implements the capture+escalate half, and the gardening state machine implements
the diverted-tracing half — but no one playbook named the whole. Author once,
reference everywhere. See [`designs/self-healing-audit.md`](../../designs/self-healing-audit.md)
for the per-script coverage audit that motivated this skill.

## Purpose

Give every script that runs unattended (a oneshot timer tick, a `Restart=`
service loop, a supervised state machine) an **outer wrapper** that turns a
failure into a *durable, selectively-inspectable artifact plus a task-specific
debugging responder*, instead of a lost transcript or a swallowed `|| true`.

The self-healing wrapper is not a substitute for `Restart=on-failure` — that
restarts the process but *captures and diagnoses nothing*. Nor is it a substitute
for the central mentor — that is the fleet-wide net of last resort. The wrapper
is the **per-script, per-task** layer between them: it knows what *this* script
was doing, captures *its* failure, and invokes a responder that wears a role
fit for *this* failure shape.

## When to use

Wrap a script when **all** of these hold:

- It runs **unattended** (no human watching its stderr in real time).
- A failure is **recoverable or improvable** by an agent — a `claude -p`
  responder could classify it, propose a fix, or post a follow-up job. (If the
  only correct response to failure is CAS-retry, the script is *deterministic*
  and wants retry, not a responder — see the audit's "deterministic" class.)
- The failure output is **worth more than one line** — a transcript, a `set -x`
  trace, a handler's full stdout/stderr.

Do **not** wrap (or wrap only with capture, no responder) when the script is a
pure git/CAS primitive whose only failure mode is contention; there, the
retry-on-rejection loop is the self-healing.

## The three parts

### Part 1 — capture the failure output

On failure, get the failure output into a **durable, content-addressable**
artifact before the process exits. The mechanism is the capture-by-SHA pattern
(see [`prompt-on-failure-capture`](../prompt-on-failure-capture/SKILL.md) once
ported — currently v1-only): hash the output into a git object database and
carry only the SHA forward.

```sh
# Hash the failure capture into the service's own journal clone.
# The blob is content-addressable: identical failures hash to identical SHAs,
# so recurring flakes short-circuit (see Part 2's known-SHA check).
LOG_SHA=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$capture_file")
```

Two capture sources, depending on the failure shape:

- **An EXIT/ERR trap** that keeps the script's own `-x` transcript. The driver's
  `report_unexpected_exit` (`scripts/driver/driver.sh:131-151`) discriminates on
  `$?` at EXIT time — a non-zero exit that the script did not mark expected
  (`DRIVER_EXPECTED_EXIT=0`) keeps the transcript, hashes it, and routes it on.
- **Diverted tracing** for a supervised inner script. `GARDEN_TRACE=1` routes
  `set -x` into `$GARDEN_TRACE_LOG` via `BASH_XTRACEFD` so trace noise never
  reaches the supervisor's context (`scripts/jobs/gardening/garden-pr.sh:34-37`,
  `panel.sh:56-59`). **The trace half is only half the pattern** — the audit's
  finding — because today the trace lives in `/tmp` and is lost on cleanup. To
  self-heal, the inner script's `fail()` must hash the trace into the journal and
  emit the SHA in its terminal failure line, so the supervisor has a durable
  artifact, not a vanished one.

> **Why hash, not inline.** A large failure log inlined into a `claude -p`
> prompt re-introduces the per-cycle token cost the capture-by-SHA pattern
> eliminates, and inlining the whole `journalctl -p warning` tail is the single
> largest wholesale-inlined blob in the fleet (the mentor's standing cost). Pass
> the SHA; the responder pulls only the slices it needs via
> `git cat-file blob $LOG_SHA | grep/sed/awk/tail`.

### Part 2 — hand it to a task-specific `claude -p` responder

Construct a **small** prompt — the **four-slot brief** (identity, work-item,
state, capture SHA) plus a one-line context — and invoke a responder that wears
a role/skill **specific to this self-healing task**, not a generic mentor prompt.

```sh
prompt="You are a <task-specific role> diagnosing a failure in <this script>.

Work item:  ${WORK_ID:-(none)}      # PR id, job base, lane, schedule name
State:      ${state:-unknown}
Exit code:  $rc
Capture:    $LOG_SHA

Context: <one-line description of what the script was doing>

Read the capture on demand via:
  git -C $GARDEN_JOURNAL cat-file blob $LOG_SHA

Diagnose the failure and propose a fix; if the fix is out of your scope,
say what job should be posted to address it."
RESPONSE=$(printf '%s' "$prompt" | claude -p)
```

Three disciplines from the exemplars:

- **Task-specific role, not generic.** The audit's standing criticism of the
  central mentor is that it has "no per-task role — one generic mentor prompt for
  every failure shape." A self-healing wrapper's whole advantage is that it
  *knows what this script does*. Give the responder a role: a panel-trace
  debugger for `garden-pr.sh`, a gardening-state-machine debugger for
  `gardener.sh`, a watcher-classification responder for a feed watcher.
- **Known-SHA short-circuit.** Before invoking, consult a per-lane / per-service
  classifications table (`grep "^$LOG_SHA " "$classifications"`); if the identical
  failure was already classified, apply the prior disposition and skip the LLM.
  Identical inputs hash identically, so recurring flakes cost nothing the second
  time.
- **Best-effort, never crash the wrapper.** The responder invocation OR-guards
  every branch (`... || response="(claude invocation failed)"`) and runs in the
  background where latency matters (`driver.sh:547` invokes
  `_self_improve_invoke_async ... &` and does not `wait`). Self-improvement must
  not become a new failure mode of the thing it is healing.

### Part 3 — propose or post a fix

The responder's output must reach a **human-or-agent-drainable** surface, not
just the script's own stdout. Two routes, by how durable the escalation must be:

- **Gardener inbox (committed, cross-host visible).** Append a failure section to
  `journal/inboxes/<host>/gardener.md` naming the capture SHA — the v1
  `report-error.sh` shape (port pending; see
  [`gardener-inbox-error-reporting`](../gardener-inbox-error-reporting/SKILL.md)
  once ported). This is the right route when a failure the *central mentor on
  another host* must inspect: a committed inbox file carries the SHA across hosts
  even though the blob itself is local until pushed. The driver uses exactly this
  (`driver.sh:140-146`).
- **Self-improvement log (committed, per-service).** Append the responder's
  analysis to a `kind:`-tagged log the gardener picks up
  (`driver.sh:502-522` writes `journal/drivers/<host>/<lane>.improvements.md`).
  Right for incremental "here is how this state could behave better" notes that
  are not themselves a failure to triage.
- **Post a follow-up job.** When the fix is a discrete unit of work, post it to
  the board (`skills/job-board/post-job.sh`) so a gardener claims and does it.

> **The cross-host nuance the audit flags.** A blob hashed into a service's *own*
> journal clone under `$GARDEN_STATE/<svc>/journal` is **local until pushed**. A
> capture another host must read requires either pushing it
> (`git push origin <sha>:refs/captures/<role>/<work>/<short-id>`) or — simpler —
> writing the SHA into a *committed* inbox file (route 1), which is what
> `report-error.sh` does. Default the capture to the service's own clone; anchor
> or push only when a cross-host reader genuinely needs the blob. Anchoring under
> `refs/captures/...` also survives `git gc` — do it only for captures safe to
> retain indefinitely (no leaked secrets).

## Procedure (assembling a wrapper)

1. **Choose the capture source.** EXIT/ERR trap for a top-level loop; diverted
   tracing for a supervised inner script. Discriminate expected vs. unexpected
   exit so a clean shutdown does not escalate.
2. **Hash on failure.** `LOG_SHA=$(... | git -C "$GARDEN_JOURNAL" hash-object -w
   --stdin)`. Guard the journal-not-a-repo and empty-capture cases (return 0).
3. **Short-circuit on a known SHA.** Consult the classifications table; apply and
   return if seen.
4. **Build the four-slot brief** and invoke the **task-specific** responder,
   best-effort and (where latency matters) backgrounded.
5. **Route the output** to the gardener inbox, a self-improvement log, or a
   posted job — whichever matches how durable and how cross-host the escalation
   must be.
6. **Never let self-healing crash the host script.** Every branch OR-guards to a
   no-op.

## Output shape

A self-healing wrapper produces, on a failure:

- a **capture blob** in the journal object DB (SHA is the handle);
- optionally an **anchored ref** under `refs/captures/...` for failures worth
  retaining;
- a **committed escalation** (inbox section, improvement-log entry, or posted
  job) naming the SHA and the responder's conclusion.

On success it produces **nothing** — the wrapper is silent on the happy path, so
it adds no noise to the supervisor's context.

## The reusable runner (the live, canonical implementation)

`scripts/jobs/self-heal-run.sh` is the **portable wrapper** every garden service
unit runs through. It extracts the driver's full shape (below) into a reusable
CLI so the pattern survives the driver's removal (`plan-remove-driver-dead-code`)
and is applied uniformly, not re-derived per service. The systemd units invoke it
as `ExecStart=…/self-heal-run.sh <context> [--work-id %i] -- …/<service>.sh [args]`.

```
self-heal-run.sh <context> [--work-id <id>] [--role <brief>] [--expect <code>] -- <command...>
```

- **Capture (Part 1):** runs the command, tees combined stdout+stderr to journald
  AND a bounded capture file; on an UNEXPECTED non-zero exit hashes the tail via
  `capture_blob` into `$GARDEN_STATE/self-heal/journal`.
- **Responder (Part 2):** hands the responder (`handlers/self-heal-claude.sh`,
  overridable via `SELF_HEAL_HANDLER`) ONLY the SHA + a four-slot brief; it wears
  the `--role` brief (default the mentor role) named for *this* context.
- **Escalate (Part 3):** the responder posts `JOB … ENDJOB` fix jobs, or escalates
  a no-fix diagnosis to the maintainer inbox (throttled).
- **Preserves the exit code** so systemd's `Restart=` / `OnFailure=` / journal /
  central-mentor layers still see the failure — the wrapper *diagnoses*, systemd
  *restarts*. A SIGTERM/SIGINT (a systemd stop) is forwarded to the child and
  treated as a CLEAN shutdown, never diagnosed.
- **Hard throttle (the token-burn guard):** the responder fires at most once per
  `(context, exit-code)` signature per `SELF_HEAL_THROTTLE_SECS` (default 30m),
  capped at `SELF_HEAL_DAILY_CAP` (default 12) per UTC day. Throttle state lives
  under `$GARDEN_STATE/self-heal/throttle/`, outside the unit, so a crash-looping
  service can never spawn `claude -p` every few seconds. The homogeneous
  100-instance gardener pool shares ONE context (`garden-gardener`, with the
  instance as `--work-id`) so a fleet-wide gardener crash is throttled fleet-wide,
  not per instance.
- **CAS-primitive exception:** pure git/CAS primitives (the reaper, post/claim/
  complete, cursors, inboxes) are NOT wrapped — their only failure mode is
  contention, which the retry-on-rejection loop already heals. Use
  `SELF_HEAL_CAPTURE_ONLY=1` for capture without a responder where that fits.

## Exemplars

| Artifact | What it demonstrates | Caveat |
| --- | --- | --- |
| `scripts/jobs/self-heal-run.sh` (+ `handlers/self-heal-claude.sh`) | The **live, reusable runner** applied to the whole service fleet: bounded capture → throttled, task-specific responder → fix-job/inbox escalation, exit-code-preserving, signal-clean. | The canonical implementation; prefer it over re-deriving. |
| `scripts/driver/driver.sh` | The **full shape** the runner was extracted from: EXIT trap (`report_unexpected_exit`, `:131-151`) + per-tick `capture_and_self_improve` (`:481-582`) that hashes into the journal (`:497`) and feeds **only the SHA** to a backgrounded `claude -p` (`:532-541`). | On the **retired/superseded** driver posture; being removed. Read it for the pattern's origin, not as a live dependency. |
| v1 `report-error.sh` (`v1/skills/gardener-inbox-error-reporting/`) | The **capture + cross-host escalate** half: hash the transcript, append a SHA-bearing section to the committed gardener inbox, CAS-push. | Targets the **`journal`** branch; v2 is **`journal2`** (`scripts/jobs/common.sh`). A straight copy pushes to the wrong branch — retarget on port (`self-heal-port-capture-skills`). |
| Gardening state machine (`designs/gardening-state-machine.md` § Divert debugging; `scripts/jobs/gardening/garden-pr.sh:34-37`, `panel.sh:56-59`) | The **diverted-tracing** half: `set -x` → `$GARDEN_TRACE_LOG` via `BASH_XTRACEFD`, so trace noise never reaches the supervisor. | **Half the pattern only.** Neither script hashes the trace nor invokes a debugger; `fail()` just `exit 1`s and the trace in `/tmp` is lost on cleanup. To self-heal, `fail()` must capture-by-hash and emit the SHA. |
| `scripts/jobs/mentor.sh` (+ `handlers/mentor-claude.sh`) | The **fleet-wide net of last resort** the wrapper complements. | **Coarse:** 30-minute timer, **no per-task role**, inlines the whole journalctl tail rather than capturing by hash. A per-script wrapper is the targeted layer this lacks. |

## Notes

- **Wrapper vs. central mentor vs. `Restart=`.** Three distinct layers. `Restart=`
  re-runs the process (no diagnosis). The central mentor scans the whole fleet
  every 30 minutes with one generic prompt (coarse, late). The self-healing
  wrapper is the per-script, per-task, immediate layer that captures *this*
  failure and diagnoses it with a role that knows *this* script. Use all three;
  none replaces another.
- **Silent on success.** The wrapper must add zero context on the happy path. A
  wrapper that narrates every successful run is a noise source, not a safety net.
- **Don't swallow the failure you mean to heal.** The audit's worst finding is a
  live supervisor that writes a one-line "exited non-zero" report and **completes
  a failed job as done** (`gardener.sh`), discarding the handler's actual output.
  A wrapper's first duty is to *not lose the evidence*; capture before you
  decide what to do with the failure.
- **Cross-link.** This skill is the umbrella;
  [`prompt-on-failure-capture`](../prompt-on-failure-capture/SKILL.md) is the
  capture-by-SHA mechanism it builds on, and
  [`gardener-inbox-error-reporting`](../gardener-inbox-error-reporting/SKILL.md)
  is the inbox-escalation route it uses. Both are v1-only pending the
  `self-heal-port-capture-skills` job; until they land, follow their v1 bodies
  under `v1/skills/`.
