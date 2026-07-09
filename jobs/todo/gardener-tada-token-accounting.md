---
role: designer
---

# Design: deterministic per-engagement token-spend accounting on the tada report

**Repo:** the garden's OWN repo (this repo). Land the design on `main2` directly,
no PR (garden convention: no PR workflows for our own repo). Deliverable is a
design doc in `designs/` (suggested `designs/tada-token-accounting.md`) that a
follow-up **builder** job can implement. Deterministic, **no LLM anywhere in the
capture/annotation path** — this is the whole point.

## Goal (maintainer request, 2026-07-09)

Have **gardener.sh capture the final token spend for every engagement**
automatically and record it against the job, so the tada report carries an
authoritative running token cost. Hard constraints from the maintainer:

1. **Automatic, driven from `gardener.sh`** (plain code, no agent involvement).
2. **Every engagement** is captured — not just the last one.
3. Costs **accumulate over multiple engagements** (append + running total), since
   one job base can be worked repeatedly: todo→doin→requeue cycles, resume after
   a message-block, or different gardeners/hosts working the same base.
4. The annotation is **never authored or redrawn by an agent** — it must survive
   an agentic rewrite of the report body.
5. Therefore **externalize the token annotation to a separate file** (maintainer's
   own suggestion) so a handler's `claude -p` has no ability or reason to touch
   it.

## What already exists (reuse, do not reinvent)

- `scripts/jobs/usage-meter.sh` — already reads Claude Code's per-turn token
  `usage` from `~/.claude/projects/**/*.jsonl`: each assistant-turn line has a
  `.timestamp` and `.message.usage` (`input_tokens`, `output_tokens`,
  `cache_creation_input_tokens`, `cache_read_input_tokens`). It **dedups by
  message id** (a message id repeats per streamed block) and defines **billable =
  input + output + cache_creation** (cache_read excluded unless
  `GARDEN_TOKEN_COUNT_CACHE_READ=1`). `meter_window_total` sums billable over a
  trailing window. Sourced by `common.sh`, so its helpers are already in scope in
  every job-board script. Reuse this billable definition and the dedup exactly;
  add a helper if a bounded delta is needed (below).
- `scripts/jobs/gardener.sh` — invokes `$GARDEN_JOB_HANDLER <base> <jobfile>
  <report>` (~line 379); the handler's `claude -p` run **is** one engagement. The
  completion marker (not the exit code) gates doin→tada.
- `scripts/jobs/complete-job.sh <id> <base> <report>` — the deterministic
  doin→tada transition where the agent-authored `$report` becomes the tada file.
  This is the natural seam to write the machine annotation.

## Design questions to resolve (the substance)

a. **Per-engagement attribution under concurrency.** Multiple gardeners on one
   host share a single `~/.claude`, so a naive "sum session-log lines whose
   timestamp falls in [handler-start, handler-end]" **races** — two concurrent
   handlers' turns interleave in the same logs. Prefer attributing to **this
   handler's own `claude -p` session** (capture the session/project JSONL the run
   writes — e.g. via `--session-id`/the session file it creates — and sum only
   that session's usage). Resolve the robust boundary; a time-window delta is the
   fallback only if session attribution proves infeasible, and its race must be
   documented.

b. **Define "engagement."** One handler invocation (todo→doin→(tada | requeue)).
   A requeued base accrues several engagements; specify that each requeue that
   later reaches tada contributes its own row, and the accumulation spans
   gardeners **and hosts** working the same base.

c. **The externalized store.** A sidecar keyed by base, **append-only**, written
   only by `gardener.sh`/`complete-job.sh`, never by the handler. Propose the path
   (journal-backed so it is shared across hosts and survives — e.g. a usage ledger
   keyed by base under the journal) and the row format (suggested: epoch, host,
   gardener id, engagement billable tokens, cumulative-to-date), plus how the
   running total is derived.

d. **How it reaches the tada report without agent authorship.** Recommend between:
   (i) `complete-job.sh` deterministically (re)appends a clearly-delimited machine
   footer to the tada file from the sidecar on every transition — so even a
   rewritten body gets the footer re-stamped; or (ii) the tada body stays
   agent-only and merely points at the authoritative sidecar. Either way the
   **sidecar is the source of truth**; the report is a view. State the choice and
   why.

e. **Multi-host accumulation.** `~/.claude` is per-host but the sidecar must sum a
   base's spend across every host that engaged it. usage-meter.sh documents a
   single-host assumption; design the ledger to be **host-additive** via the
   journal (each host appends its own rows; the total is the sum).

f. **Fail-open, always.** A missing/unreadable session log or meter must **never**
   wedge the doin→tada transition or lose the report — record `0`/`unknown` and
   proceed with a logged warning. The token annotation is best-effort; the job
   completing is not.

## Definition of done (design)

A `designs/` doc specifying: the attribution mechanism (question a), the
engagement boundary (b), the sidecar path + append-only row format + total
derivation (c), the report-surfacing choice (d), the host-additive accumulation
(e), and the fail-open guarantees (f) — concrete enough that a builder implements
it by editing `usage-meter.sh` / `gardener.sh` / `complete-job.sh` with no further
design decisions. Note the follow-up builder job is expected but not part of this
job.
