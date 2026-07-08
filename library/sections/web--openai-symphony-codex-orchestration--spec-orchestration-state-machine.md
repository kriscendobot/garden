---
title: Symphony Service Specification — orchestration state machine, polling, and reconciliation
source_kind: web
source_url: https://openai.com/index/open-source-codex-orchestration-symphony/
source_snapshot: http://web.archive.org/web/2id_/https://openai.com/index/open-source-codex-orchestration-symphony/
source_content_sha256: b7c17d55f4faf42eb09282c0670a14dce360f83a5fe205834b5bbe09a7695c09
source_authors: [Alex Kotliarskyi, Victor Zhu, Zach Brock]
source_date: 2026-04-27
retrieved: 2026-07-08
ingested: 2026-07-08
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

Abstract: The coordination core of the spec (§7–§8) — the orchestration state machine, the poll loop, candidate selection, concurrency, retry/backoff, and reconciliation. The orchestrator is the **only component that mutates scheduling state**; all worker outcomes are reported to it and converted into explicit transitions. Each issue occupies an internal *claim* state (Unclaimed / Claimed / Running / RetryQueued / Released) distinct from tracker states; a run attempt walks a lifecycle (PreparingWorkspace → … → StreamingTurn → Succeeded/Failed/TimedOut/Stalled/CanceledByReconciliation). Each poll tick reconciles running issues first, validates config, fetches candidates in active states, sorts them (priority → age → identifier), and dispatches while slots remain — honoring a **Todo blocker rule** (do not dispatch a `Todo` issue with any non-terminal blocker). Retries use a short 1s continuation delay after a clean exit and exponential backoff (`min(10000 * 2^(attempt-1), max_retry_backoff_ms)`) after failure. Reconciliation each tick does stall detection and tracker-state refresh. Recovery is tracker-and-filesystem-driven with **no durable orchestrator DB**.

## Issue orchestration (claim) states (§7.1)

Distinct from tracker states (`Todo`, `In Progress`, …), these are the service's internal claim state: `Unclaimed` (not running, no retry scheduled); `Claimed` (reserved to prevent duplicate dispatch — in practice `Running` or `RetryQueued`); `Running` (worker task exists, tracked in the `running` map); `RetryQueued` (no worker, but a retry timer exists); `Released` (claim removed because the issue is terminal, non-active, missing, or a retry path completed without re-dispatch).

**Multi-turn continuation nuance.** A successful worker exit does not mean the issue is done forever. A worker may run multiple back-to-back coding-agent turns before exiting: after each normal turn completion it re-checks tracker state, and if still active starts another turn on the *same live thread in the same workspace*, up to `agent.max_turns`. The first turn uses the full rendered prompt; continuation turns send only continuation guidance (not the original prompt already in thread history). Once the worker exits normally, the orchestrator still schedules a short (~1s) continuation retry to re-check whether the issue remains active.

## Run-attempt lifecycle (§7.2)

Phases: `PreparingWorkspace` → `BuildingPrompt` → `LaunchingAgentProcess` → `InitializingSession` → `StreamingTurn` → `Finishing`, then a terminal reason: `Succeeded`, `Failed`, `TimedOut`, `Stalled`, or `CanceledByReconciliation`. Distinct terminal reasons matter because retry logic and logs differ.

## Transition triggers (§7.3) and idempotency (§7.4)

Triggers: `Poll Tick` (reconcile, validate, fetch candidates, dispatch until slots exhaust); `Worker Exit (normal)` (remove running entry, update totals, schedule a continuation retry); `Worker Exit (abnormal)` (remove entry, update totals, schedule exponential-backoff retry); `Codex Update Event` (update session fields, token counters, rate limits); `Retry Timer Fired` (re-fetch active candidates and re-dispatch, or release claim); `Reconciliation State Refresh` (stop runs whose issue states are terminal or no longer active); `Stall Timeout` (kill worker, schedule retry).

Idempotency and recovery: the orchestrator serializes state mutations through one authority to avoid duplicate dispatch; `claimed` and `running` checks are required before launching any worker; reconciliation runs before dispatch every tick; **restart recovery is tracker- and filesystem-driven — no durable orchestrator DB is required**; startup terminal cleanup removes stale workspaces for already-terminal issues.

## Poll loop and candidate selection (§8.1–§8.2)

At startup the service validates config, performs startup cleanup, schedules an immediate tick, then repeats every `polling.interval_ms`. Each tick: (1) reconcile running issues; (2) run dispatch preflight; (3) fetch candidates from the tracker using active states; (4) sort by dispatch priority; (5) dispatch eligible issues while slots remain; (6) notify observability. If per-tick validation fails, dispatch is skipped but reconciliation still runs first.

An issue is dispatch-eligible only if all hold: it has `id`, `identifier`, `title`, `state`; its state is in `active_states` and not `terminal_states`; it is not already in `running` or `claimed`; global concurrency slots are available; per-state slots are available; and the **Todo blocker rule** passes — if the state is `Todo`, do not dispatch when any blocker is non-terminal. Sort order (stable intent): `priority` ascending (1..4 preferred; null/unknown last), then `created_at` oldest first, then `identifier` lexicographic.

## Concurrency, retry/backoff, reconciliation (§8.3–§8.6)

**Concurrency.** Global: `available_slots = max(max_concurrent_agents - running_count, 0)`. Per-state: `max_concurrent_agents_by_state[state]` if present (normalized key), else the global limit. An optional SSH-host limit skips hosts at `worker.max_concurrent_agents_per_host`.

**Retry and backoff.** Normal continuation retries after a clean exit use a short fixed **1000 ms** delay; failure-driven retries use `delay = min(10000 * 2^(attempt-1), agent.max_retry_backoff_ms)` (default cap 5m). Retry handling fetches active candidates, finds the issue by id, and: releases the claim if absent; dispatches if slots are free (else requeues with `no available orchestrator slots`); releases the claim if the issue is no longer active.

**Reconciliation (every tick, two parts).** Part A — *stall detection*: for each running issue compute elapsed since `last_codex_timestamp` (or `started_at`); if it exceeds `codex.stall_timeout_ms`, terminate the worker and queue a retry (skipped entirely when `stall_timeout_ms <= 0`). Part B — *tracker state refresh*: fetch current states for all running IDs; if terminal, terminate worker and clean the workspace; if still active, update the in-memory snapshot; if neither active nor terminal, terminate the worker without workspace cleanup; if the refresh fails, keep workers running and retry next tick. **Startup terminal cleanup** queries terminal-state issues and removes their workspace directories so stale workspaces do not accumulate across restarts.

> This is the sharpest point of divergence from the garden's own board: Symphony centralizes all scheduling-state mutation in **one authoritative orchestrator** that reserves (`claimed`) each issue before dispatch. The garden instead has no central authority — gardeners on every host **race to claim** via a git-push compare-and-swap against the `journal2` branch, and the accepted push *is* the serialization point. Both prevent duplicate dispatch; Symphony does it with a single in-memory authority, the garden with a distributed CAS. Symphony's stall-detection + retry-with-backoff parallels the garden's reaper/park-on-fail machinery.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
