---
title: Symphony Service Specification — problem statement, system overview, and domain model
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

Abstract: The foundational sections (§1–§4) of the embedded `SPEC.md`. Symphony is a long-running automation service that continuously reads work from an issue tracker (Linear in this version), creates an **isolated per-issue workspace**, and runs a coding-agent session for that issue inside it. It solves four operational problems (repeatable daemon workflow, per-issue isolation, in-repo policy via `WORKFLOW.md`, observability) under an important boundary: Symphony is a **scheduler/runner and tracker reader**, while ticket writes are performed by the coding agent, and a successful run may end at a handoff state (e.g. `Human Review`) rather than `Done`. The service decomposes into eight components across six abstraction layers (Policy → Configuration → Coordination → Execution → Integration → Observability), over a normalized domain model of entities (Issue, Workflow Definition, Service Config, Workspace, Run Attempt, Live Session, Retry Entry, Orchestrator Runtime State).

## Problem statement (§1)

Symphony is a long-running automation service that continuously reads work from an issue tracker (Linear in this specification version), creates an isolated workspace for each issue, and runs a coding-agent session for that issue inside the workspace. It solves four operational problems:

- turns issue execution into a **repeatable daemon workflow** instead of manual scripts;
- **isolates** agent execution in per-issue workspaces so agent commands run only inside per-issue workspace directories;
- keeps workflow **policy in-repo** (`WORKFLOW.md`) so teams version the agent prompt and runtime settings with their code;
- provides enough **observability** to operate and debug multiple concurrent agent runs.

Implementations must document their trust-and-safety posture explicitly; the spec does not mandate a single approval/sandbox/confirmation policy (some target high-trust environments, others require stricter approvals or sandboxing).

**Important boundary.** Symphony is a scheduler/runner and tracker reader. Ticket writes (state transitions, comments, PR links) are typically performed by the coding agent using tools available in the workflow/runtime environment. A successful run may end at a workflow-defined handoff state (for example `Human Review`), not necessarily `Done`.

## Goals and non-goals (§2)

**Goals:** poll the tracker on a fixed cadence and dispatch with bounded concurrency; maintain a single authoritative orchestrator state for dispatch/retries/reconciliation; create deterministic per-issue workspaces preserved across runs; stop active runs when issue state makes them ineligible; recover from transient failures with exponential backoff; load runtime behavior from a repo-owned `WORKFLOW.md`; expose operator-visible observability (at minimum structured logs); support restart recovery without a persistent database.

**Non-goals:** rich web UI or multi-tenant control plane; prescribing a specific dashboard/terminal UI; a general-purpose workflow engine or distributed job scheduler; built-in business logic for editing tickets/PRs/comments (that lives in the workflow prompt and agent tooling); mandating strong sandbox controls beyond what the coding agent and host OS provide; mandating a single default approval/sandbox/confirmation posture.

## System overview (§3)

**Eight main components:** `Workflow Loader` (reads `WORKFLOW.md`, parses YAML front matter + prompt body); `Config Layer` (typed getters, defaults, env indirection, validation); `Issue Tracker Client` (fetch candidate/terminal/by-id issues, normalize payloads); `Orchestrator` (owns the poll tick, in-memory runtime state, dispatch/retry/stop/release decisions, metrics); `Workspace Manager` (map issue → workspace path, ensure dirs, lifecycle hooks, cleanup); `Agent Runner` (create workspace, build prompt, launch the coding-agent app-server client, stream updates); `Status Surface` (optional operator-facing view); `Logging` (structured logs to configured sinks).

**Six abstraction layers** (the portability partition): `Policy Layer` (repo-defined `WORKFLOW.md` prompt + team rules); `Configuration Layer` (typed runtime settings from front matter); `Coordination Layer` (polling loop, eligibility, concurrency, retries, reconciliation); `Execution Layer` (filesystem lifecycle, workspace prep, coding-agent protocol); `Integration Layer` (Linear adapter); `Observability Layer` (logs + optional status surface).

**External dependencies:** an issue-tracker API (Linear); the local filesystem (workspaces + logs); optional workspace-population tooling (e.g. Git CLI); a coding-agent executable supporting a JSON-RPC-like app-server mode over stdio; host environment auth for tracker and agent.

## Core domain model (§4)

Normalized entities used across orchestration, prompt rendering, and observability:

- **Issue** — `id`, `identifier` (human key like `ABC-123`), `title`, `description`, `priority` (lower = higher), `state`, `branch_name`, `url`, `labels` (lowercased), `blocked_by` (list of blocker refs with `id`/`identifier`/`state`), `created_at`, `updated_at`.
- **Workflow Definition** — `config` (YAML front-matter root map) + `prompt_template` (trimmed Markdown body).
- **Service Config (typed view)** — poll interval, workspace root, active/terminal states, concurrency limits, coding-agent executable/args/timeouts, workspace hooks.
- **Workspace** — `path`, `workspace_key` (sanitized identifier), `created_now` (gates the `after_create` hook).
- **Run Attempt** — `issue_id`, `issue_identifier`, `attempt` (null for first run, ≥1 for retries), `workspace_path`, `started_at`, `status`, optional `error`.
- **Live Session** — `session_id` (`<thread_id>-<turn_id>`), `thread_id`, `turn_id`, `codex_app_server_pid`, last-event fields, input/output/total token counters, `turn_count`.
- **Retry Entry** — `issue_id`, `identifier`, `attempt`, `due_at_ms` (monotonic), `timer_handle`, `error`.
- **Orchestrator Runtime State** — the single authoritative in-memory state: `poll_interval_ms`, `max_concurrent_agents`, `running` map, `claimed` set, `retry_attempts` map, `completed` set (bookkeeping only), `codex_totals`, `codex_rate_limits`.

**Normalization rules:** use `Issue ID` for tracker lookups/map keys and `Issue Identifier` for logs/workspace naming; derive `Workspace Key` from `issue.identifier` by replacing any char not in `[A-Za-z0-9._-]` with `_`; compare states after lowercasing; compose `Session ID` as `<thread_id>-<turn_id>`.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
