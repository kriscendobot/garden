# Non-Claude completion nudge parity

| Created | 2026-09-29 |
| Author | designer |
| Status | Accepted |

## Decision

Extend the monk handler's bounded post-turn completion nudge and honest
`continue` framing to `cleric-codex`, `mystic-kimi`, and `opencode`. All three
CLIs can submit another prompt to the session that just ended. This is a handler
parity gap, not a backend capability gap.

The active Codex and Kimi lanes justify the change on their own. A clean end-turn
without the completion marker currently pays for a journal requeue, another
claim, and another full handler launch. It can also consume a reaper doom count or
a gauntlet stage retry even when the deliverable is already finished. One bounded
resume inside the current handler can turn that case into an immediate completion.

Include OpenCode in the same implementation even though its lane remains a
disabled-by-default canary. Its handler already persists the assigned session ID,
so the marginal code and test cost is small once the common continuation policy
exists. Keep the lane disabled until its separate paid-canary requirements are
met; completion-nudge parity does not graduate or enable it.

This nudge happens only after the first CLI process has exited cleanly. It is a
second CLI invocation inside the same handler process, against the same session
and worktree. It is not live message injection into a running model turn and does
not change the inbox-only guarantee in [deadline-nudge.md](deadline-nudge.md).

## Capability findings

| Handler | Resume surface | Evidence | Disposition |
| --- | --- | --- | --- |
| `cleric-codex` | `codex exec resume <session-id> <prompt>` | The installed Codex CLI 0.156.0 advertises a resume command that accepts both the session ID and a new prompt. The handler already extracts the assigned ID from JSONL and uses this command after a requeue. | Extend now. |
| `mystic-kimi` | `kimi --continue --prompt <prompt>` or `kimi --session <id> --prompt <prompt>` | The installed Kimi Code CLI 2.0.2 advertises both forms. The handler gives each job a private `KIMI_CODE_HOME` and already resumes that job with `--continue` after a requeue. A 2026-07-25 canary also completed after resuming its prior Kimi session. | Extend now. |
| `opencode` | `opencode run --session <session-id> <prompt>` | OpenCode is not installed on this host. The 2026-09-01 OpenCode 1.18.25 probe used a temporary real binary and observed the same session ID after `--session`; the handler's hermetic test also covers sidecar resume. A paid successful-run canary remains outstanding. | Implement while the lane is disabled; require the existing paid canary before enabling the lane. |

The garden has no demonstrated supported way to inject the nudge into any of these
CLI processes while it is still executing. That gap is irrelevant to this recovery
path because the trigger is a clean end-turn: the first child has already exited.
Fresh requeue remains the fallback if session state is absent, resume fails, the
provider is unavailable, or the handler reaches its wall-clock limit.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle / commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| Gardener spine -> handler | Supplies the completion sentinel path and `GARDEN_APPLIED_HANDLER_BUDGET`. | The spine decides whether markerless output completes, requeues, or fails. | The journal owns claim and completion state. | The spine owns the claim wall and the `doin` to `tada` transition. | Handler exit status, report, usage record, and completion sentinel, named in spine vocabulary. |
| Shared worker policy -> backend adapter | Supplies continuation prompt text, the unfinished-end-turn marker path, the nudge count, and the minimum remaining wall time. | Shared policy decides whether one more turn is admissible. | No durable state. The worktree's private git admin directory owns a recoverable, host-local unfinished-end-turn marker. | The handler owns starting and stopping each CLI child; shared policy does not call a backend. | A `fresh`, `resume`, `fallback`, or `continue` prompt mode, named in worker-policy vocabulary. |
| Backend adapter -> CLI | Invokes the CLI's resume primitive and parses its output. | The adapter decides whether the backend result is a clean markerless end-turn, a completion, or a failure. | No durable job state. The existing Claude transcript, Codex/OpenCode sidecar, or Kimi private home owns recoverable session continuity. | The adapter owns child-process cleanup and backend-state retirement after completion. | A backend session ID or private-home continuation plus a new user prompt, named in CLI vocabulary. |

The journal is the sole owner of durable job lifecycle state. The per-job
worktree and handler state hold recoverable execution state only. The gardener
spine decides whether a job commits as complete or is requeued. The backend
handler restarts the CLI child and replays the continuation prompt. The handler
classifies how a CLI invocation ended; the spine decides what that result does to
the job lifecycle.

Inner/outer naming check: backend adapters report an invocation outcome and
session continuity. They do not report a job commit, requeue, or completion
decision. Those names remain at the outer gardener-spine boundary.

## Handler contract

The common policy is:

1. Run the normal prompt and parse the backend result.
2. A nudge is eligible only when the CLI exited `0` and its report does not end in
   the completion marker. Provider errors, signals, malformed output, and explicit
   budget or quota stops never trigger it.
3. Require a resumable session, fewer than `GARDEN_COMPLETION_NUDGES` attempts
   (default `1`), and enough time left under
   `GARDEN_APPLIED_HANDLER_BUDGET`. Add one shared
   `GARDEN_COMPLETION_NUDGE_MIN_SECONDS` floor. A backend with its own stricter
   budget check may require both checks; the monk handler retains its remaining
   dollar check.
4. Reinvoke the CLI in the same worktree and session with
   `worker_job_prompt ... continue`. Do not start a fresh session if this resume
   fails: ordinary requeue is safer than duplicating the continuation prompt into
   a new context.
5. Parse the second result through the same adapter path as the first. Sum usage
   across both calls, preserve the first report when the nudge produces no usable
   report, and write the completion sentinel only when the final clean report
   carries the marker.
6. If the final result is still a clean markerless end-turn, write the shared
   unfinished-end-turn marker. A later same-host requeue selects `continue`, not
   the false "you were interrupted" `resume` framing. Clear that marker on every
   other outcome and on completion.

The count and the outer handler wall make every backend bounded. Codex and Kimi do
not expose Claude's per-invocation dollar ceiling, so exact spend parity is not
available. That is not a session-resume gap. The shared remaining-time floor keeps
the handler from starting a second turn immediately before the wall, while the
existing usage adapters record what the two calls consumed.

## Backend adapter work

### Codex

Refactor the existing invocation, session-ID parse, result extraction, failure
classification, and token capture into a reusable one-call function. After a
markerless success, invoke `codex exec resume "$sid" ... "$continue_prompt"`.
Append each call's JSONL to a private aggregate capture or sum the terminal token
records explicitly. Preserve the existing rule that a provider policy refusal does
not fall back to a fresh session.

### Kimi

Wrap the existing `kimi` call and marker normalization in a one-call function.
The nudge uses the same private `KIMI_CODE_HOME` and adds `--continue`. Take the
usage snapshot once before the first call and once after the final call so its
delta naturally includes both turns. Preserve the credential-safe diagnostic
rule and the decorated-marker normalization.

### OpenCode

After the first event stream yields `sessionID`, rerun `opencode run` with
`--session "$sid"` and the continuation prompt against the same private XDG
directories. Accumulate every numeric `step_finish` event across both streams;
absence of a priced event remains censored rather than becoming a zero-dollar
record. Keep authentication and capacity normalization unchanged.

## Verification plan

Extend each handler's hermetic test with the same sequence:

- first call exits `0` with a report but no completion marker;
- exactly one second call uses the same session and the `continue` prompt;
- the second call's marker writes the sentinel and tears down private state;
- `GARDEN_COMPLETION_NUDGES=0` preserves today's requeue behavior;
- insufficient remaining wall time skips the nudge;
- a failed nudge preserves the first report and resumable state;
- two-call token and cost fields are summed without fabricating dollars; and
- a second markerless turn leaves the unfinished marker, then the next same-host
  claim receives `continue` framing.

Keep backend-specific regression cases: Codex policy refusal, Kimi marker
decoration, and OpenCode unpriced or refused events. Run the worker-spine and
completion-signal suites because the sentinel and teardown contract remain shared.

For live acceptance, record one markerless-then-completing run on each enabled
lane and inspect the CLI arguments, report, usage row, and absence of a requeue.
Codex and Kimi can be accepted on their active lanes. OpenCode acceptance remains
part of its existing paid canary and does not block landing the inert handler code.

## Alternatives considered

- **Keep plain requeue for every non-Claude handler.** Rejected because all three
  already preserve enough session state to issue the continuation immediately.
  Requeue adds journal latency and consumes lifecycle retry state without adding a
  recovery capability.
- **Add `continue` framing only after requeue.** Better than the current false
  interruption wording, but it still pays for the requeue when the handler can
  recover in place.
- **Wait for live mid-turn steering.** Rejected because post-turn continuation
  does not require it. Mid-turn deadline-message delivery remains a separate
  backend-adapter question in [deadline-nudge.md](deadline-nudge.md).
