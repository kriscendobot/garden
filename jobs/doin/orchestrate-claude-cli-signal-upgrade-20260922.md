---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: orchestrator
tier: mentat
dispatch: manual
handler-timeout: 14339
---
Implement, validate, and canary-deploy better error/quota signal from the Claude
CLI throughout the garden. MAINTAINER DIRECTIVE (kriskowal, 2026-09-22):
"post an orchestrator at mentat tier to do all of these things. Skip design.
Implement, validate, and deploy with a canary."

NO DESIGN PASS. Implement directly. Drive all three work items to landed,
validated, deployed. Everything below was measured on this fleet on 2026-09-22
against Claude Code CLI 2.1.260 — verify each claim still holds, then build.

## Work item 1 — READ THE ENVELOPE FIELDS WE ALREADY RECEIVE (do this first)

`scripts/jobs/handlers/monk-claude.sh:336` invokes:

    claude -p --output-format json --dangerously-skip-permissions ...

and the handler then extracts ONLY `.result`:

    jq -er '.result' "$envelope" > "$report"

The envelope actually carries: `api_error_status`, `is_error`, `stop_reason`,
`terminal_reason`, `subtype`, `permission_denials`, `subagent_stats`,
`queued_turn_count`, `fast_mode_state`, `duration_api_ms`, `ttft_ms`, `usage`,
`modelUsage`. A grep of `scripts/jobs/` shows `stop_reason`, `terminal_reason`,
`api_error_status`, `permission_denials` and `subagent_stats` appear in ZERO
production files; `is_error` appears only in the test fixture
`scripts/jobs/test/provider-cooldown-test.sh:118`.

CONSEQUENCE TO FIX: the garden infers completion from a SENTINEL STRING the model
is instructed to print (`report_has_completion_marker` /
`GARDEN_COMPLETION_SENTINEL`), because — per the handler's own comment — an exit-0
`claude` may have been "quota/usage cut mid-response, a swallowed API error, or an
unsatisfying run that never reached the final act". That is a text-channel proxy
for structured fields already present in the envelope.

TASK: parse the envelope's error/termination fields and use them to classify the
outcome (complete / transient-failure / quota-cut / policy-refusal / API error),
feeding the existing requeue-vs-doom machinery. Record them in the usage ledger
too, so a post-hoc reader can see WHY a run ended.

CAUTION — do not simply delete the completion marker. It also proves the model
reached its instructed final act, which no envelope field expresses. Make the
structured fields AUTHORITATIVE for error classification while deciding
deliberately what role the marker retains, and say what you chose. Landing a
change that silently starts recording unfinished runs as `tada` would be worse
than the status quo.

## Work item 2 — STREAM-JSON FOR QUOTA TELEMETRY

`--output-format stream-json` emits a `rate_limit_event` that the plain `json`
envelope DOES NOT CONTAIN (verified: no rate/limit/window/utilization/reset path
exists in the plain envelope). Observed payload:

    {"type":"rate_limit_event","rate_limit_info":{
      "status":"allowed","resetsAt":1790061600,"rateLimitType":"five_hour",
      "overageStatus":"rejected","overageDisabledReason":"org_level_disabled",
      "isUsingOverage":false,
      "unifiedWindows":{"five_hour":{"utilization":0.15,"resetsAt":1790061600},
                        "seven_day":{"utilization":0.14,"resetsAt":1790391600}}}}

Today `config/budget-pools` holds HAND-CALIBRATED weekly-token ceilings derived
from a human reading `/usage` paired against a meter sample — the most recent
(`anthropic:oros-studio-garden-ce242c49` = 73,000,000) is graded confidence LOW,
single-point, and the file itself warns the ratio "holds only while the workload
mix stays broadly similar". The CLI reports TRUE five-hour and seven-day
utilization per call, plus `overageStatus` (the "usage credits off, stops at the
cap" property).

TASK: switch the worker spine to `--output-format stream-json`, consume the event
stream, and feed real utilization into the budget machinery (`budget/live/<host>`,
`budget-level.sh`, `pool_admits`). Keep hand calibration as a FALLBACK, not the
primary source — and preserve the fail-closed-on-untrustworthy-pool behavior from
`credit-controls-fail-closed-pools`.

Note the incidental win: streaming makes a run observable WHILE it runs. Today a
handler is opaque until exit, which is why a runaway test leak went unnoticed
until load hit 168. If cheap, surface liveness/progress; do not gold-plate it.

MIGRATION RISK — the format change is the risky part of this job. `stream-json` is
newline-delimited events, not one object: `jq -er '.result'` will NOT work, and
the result envelope arrives as the final `type:"result"` event. Every consumer of
the current envelope must move together. Consider `--include-partial-messages`
only if you actually need token-level progress; it multiplies event volume.

## Work item 3 — PER-CALL BUDGET CEILING

Adopt `--max-budget-usd` as a hard per-invocation cap, derived from the job's tier
and the host's remaining pool headroom. This bounds at the CALL level what the
$1,090-in-19-hours unmetered-window incident showed pool arithmetic alone does not
(`reports/credit-investigation-endolin-garden2-20260905.md`). Decide the policy for
a run that hits its ceiling — it is a budget stop, not a failure, and must requeue
or report rather than doom.

Also evaluate `--json-schema` for stages needing a machine-readable verdict
(gauntlet decisions, panel dispositions) instead of marker-grepping. Adopt it where
it plainly fits; do not force it everywhere in this job.

## VALIDATE

Regression tests for each item: envelope-field classification (including a
quota-cut and an API-error envelope), stream-json parsing (including a truncated
stream and a stream whose `result` event never arrives), and the budget-ceiling
stop path. The existing `scripts/jobs/test/provider-cooldown-test.sh` fixture is a
model for the envelope shapes.

The full candidate gate must pass. See the BLOCKER below.

## DEPLOY WITH A CANARY

Per `designs/follower-self-deploy.md`: roll a FOLLOWER first as canary, validate it
(unit health + a host-pinned round-trip probe + a job-processing watch), and advance
the leader LAST, never on a failed canary.

Fleet reality you must check before relying on it:
- `oros-studio-garden-ce242c49` is OFFLINE (no health tick since 2026-09-19T21:54Z,
  no sysop ack to an op sent 2026-09-21T20:33Z). Do NOT count it as an available
  canary unless it has demonstrably returned.
- That likely leaves `endolin-garden2-5bcdff64` as the only canary, with
  `endolin-garden-ece02cb4` (leader) advancing last.
- Validate the canary POSITIVELY: fresh `claim(...)` entries by that host after its
  deploy. Zero failed units is NOT proof — a stale drain marker yields zero failures
  and zero workers.

## HARD BLOCKER — THE DEPLOY GATE IS CURRENTLY RED

No host can deploy right now. The candidate gate has been rejecting `main2` for
days on `signal-kill-classifier-test.sh`, `retry-narrowing-test.sh` and
`provider-cooldown-test.sh` (all rc=1); the leader is 35 commits behind and
`endolin-garden2` 29 behind. `fix-deploy-candidate-gate-red-20260922` is in flight
against exactly this.

So: implement and validate REGARDLESS, but the deploy stage is BLOCKED until that
gate is green. Watch for it; if it has not cleared by the time your work is
validated, land the work and report the deploy as pending rather than burning your
budget waiting. DO NOT use `GARDEN_DEPLOY_TEST_OVERRIDE=1` — that is the
maintainer's emergency lever, and using it here would deploy code whose own tests
fail. Note `provider-cooldown-test.sh` is both a gate blocker AND the file you will
touch in item 1; coordinate rather than collide.

## ORDER AND REPORTING

Run the items in order (1, then 2, then 3) — item 1 is the smallest and lowest risk
and establishes the classification the others build on. If budget runs short,
LANDING ITEM 1 ALONE IS A GOOD OUTCOME; say so plainly rather than leaving three
half-finished changes. Split into follow-on jobs if needed rather than overrunning.

Report per item: what landed, what you validated, and the deploy/canary state.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T04:54:00Z
