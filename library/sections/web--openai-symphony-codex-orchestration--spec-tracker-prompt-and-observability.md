---
title: Symphony Service Specification — tracker integration, prompt assembly, and observability
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

Abstract: The tracker, prompt, and observability sections of the spec (§11–§13). The **tracker adapter** (Linear-compatible) must support three operations — fetch candidate issues in active states, fetch issues by state (startup cleanup), and fetch states by IDs (reconciliation) — with Linear-specific GraphQL query semantics (project `slugId` filter, `[ID!]` state refresh, pagination, 30s timeout) and normalization to the §4 domain model; a key boundary is that **Symphony performs no first-class tracker writes** — ticket mutations are the agent's job, and success often means "reached the next handoff state" rather than tracker `Done`. **Prompt construction** renders the `WORKFLOW.md` template strictly over the normalized issue plus an `attempt` integer that lets the prompt vary between first run, continuation, and retry. **Observability** requires structured `key=value` logs (with `issue_id`/`issue_identifier`/`session_id` context) and recommends an optional runtime snapshot (running/retrying rows, token totals, runtime seconds, rate limits), an optional human-readable status surface, careful token accounting (prefer absolute thread totals, track deltas to avoid double-counting), and optional humanized event summaries used for observability only.

## Issue tracker integration contract (§11)

An implementation must support three tracker-adapter operations: `fetch_candidate_issues()` (issues in configured active states for the configured project); `fetch_issues_by_states(state_names)` (startup terminal cleanup); `fetch_issue_states_by_ids(issue_ids)` (active-run reconciliation).

**Linear query semantics** (`tracker.kind == "linear"`): GraphQL endpoint (default `https://api.linear.app/graphql`); auth token in the `Authorization` header; `tracker.project_slug` maps to Linear project `slugId`; candidate query filters `project: { slugId: { eq: $projectSlug } }`; state-refresh uses GraphQL issue IDs with variable type `[ID!]`; pagination required (default page size 50); 30000 ms network timeout. Linear's schema can drift, so keep query construction isolated and test exact fields/types. A non-Linear implementation may change transport details but must produce normalized outputs matching the §4 domain model.

**Normalization:** `labels` → lowercase; `blocked_by` derived from inverse relations where the relation type is `blocks`; `priority` → integer only (non-integers → null); `created_at`/`updated_at` → parsed ISO-8601. **Error categories:** `unsupported_tracker_kind`, `missing_tracker_api_key`, `missing_tracker_project_slug`, `linear_api_request`, `linear_api_status`, `linear_graphql_errors`, `linear_unknown_payload`, `linear_missing_end_cursor`. Orchestrator behavior on tracker errors: candidate-fetch failure → log and skip dispatch this tick; running-state-refresh failure → log and keep active workers running; startup-cleanup failure → log a warning and continue startup.

**Tracker writes (important boundary, §11.5).** Symphony does not require first-class tracker write APIs in the orchestrator. Ticket mutations (state transitions, comments, PR metadata) are typically handled by the coding agent using tools defined by the workflow prompt; the service remains a scheduler/runner and tracker reader; workflow-specific success often means "reached the next handoff state" (e.g. `Human Review`) rather than tracker terminal `Done`. Even the optional `linear_graphql` client-side tool is part of the agent toolchain, not orchestrator business logic.

## Prompt construction and context assembly (§12)

Inputs: `workflow.prompt_template`, the normalized `issue` object, and an optional `attempt` integer (retry/continuation metadata). Rendering rules: render with strict variable and filter checking; convert issue-object keys to strings for template compatibility; preserve nested arrays/maps (labels, blockers) so templates can iterate. `attempt` is passed to the template so the prompt can differ for first run (`attempt` null/absent), continuation run after a successful prior session, and retry after error/timeout/stall. Failure semantics: if prompt rendering fails, fail the run attempt immediately and let the orchestrator treat it like any other worker failure.

## Logging, status, and observability (§13)

**Logging conventions:** required context fields `issue_id` and `issue_identifier` on issue logs, `session_id` on coding-agent session-lifecycle logs; stable `key=value` phrasing; include the action outcome (`completed`, `failed`, `retrying`, …) and a concise failure reason; avoid logging large raw payloads. Sinks are not prescribed (stderr/file/remote), but operators must be able to see startup/validation/dispatch failures without a debugger, and a failing log sink should not stop the service.

**Runtime snapshot (optional but recommended):** a synchronous snapshot returning `running` rows (each with `turn_count`), `retrying` rows, `codex_totals` (input/output/total tokens, `seconds_running`), and latest `rate_limits`; recommended snapshot error modes `timeout` and `unavailable`. An optional human-readable **status surface** (terminal/dashboard) must draw only from orchestrator state/metrics and never be required for correctness.

**Token accounting:** prefer absolute thread totals (`thread/tokenUsage/updated`, `total_token_usage`) over delta-style payloads; extract input/output/total leniently from common field names; track deltas relative to last-reported totals to avoid double-counting; do not treat generic `usage` maps as cumulative unless the event type defines them so. **Runtime** is reported as a live aggregate at snapshot/render time (cumulative ended-session runtime plus active-session elapsed), with no required continuous background ticking. **Rate limits:** track the latest payload seen in any agent update. **Humanized agent-event summaries** are optional, observability-only output — orchestrator logic must never depend on the humanized strings.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
