---
title: Symphony Service Specification — configuration resolution, dynamic reload, and dispatch preflight
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

Abstract: The configuration specification (§6) — how `WORKFLOW.md`'s front matter becomes effective runtime config, how it reloads live, and the preflight validation that gates dispatch. Precedence is: workflow-file selection → YAML front-matter values → `$VAR_NAME` environment indirection → built-in defaults, with `~`/`$VAR` expansion applied only to filesystem-path values (never to URIs or arbitrary shell commands). **Dynamic reload is required**: the service watches `WORKFLOW.md` and re-applies config and prompt template without restart (polling cadence, concurrency, active/terminal states, codex settings, workspace paths/hooks, and future-run prompt), keeping the last known-good config and emitting an operator-visible error on an invalid reload rather than crashing. A dispatch preflight runs at startup and before each tick, checking that the workflow loads, `tracker.kind` is supported, `tracker.api_key` resolves, `tracker.project_slug` is present when required, and `codex.command` is non-empty.

## Source precedence and coercion (§6.1)

Configuration precedence, highest first: (1) workflow file path selection (runtime setting → cwd default); (2) YAML front-matter values; (3) environment indirection via `$VAR_NAME` inside selected YAML values; (4) built-in defaults. Value coercion: path/command fields support `~` home expansion and `$VAR` expansion for env-backed path values, but expansion applies **only to values intended to be local filesystem paths** — do not rewrite URIs or arbitrary shell command strings.

## Dynamic reload (§6.2)

Dynamic reload is required. The service should watch `WORKFLOW.md`; on change it re-reads and re-applies workflow config and prompt template without restart, adjusting live behavior (polling cadence, concurrency limits, active/terminal states, codex settings, workspace paths/hooks, and prompt content for future runs). Reloaded config applies to future dispatch, retry scheduling, reconciliation, hook execution, and agent launches. In-flight agent sessions are not required to restart on config change. Extensions managing their own listeners/resources (e.g. an HTTP server port change) may require restart unless the implementation supports live rebind. The service should also re-validate/reload defensively during runtime operations (e.g. before dispatch) in case a filesystem-watch event was missed. **An invalid reload must not crash the service**: keep operating with the last known-good effective configuration and emit an operator-visible error.

## Dispatch preflight validation (§6.3)

This is a scheduler preflight before dispatching new work — it validates the workflow/config needed to poll and launch workers, not a full audit. Startup validation runs before the scheduling loop; on failure, fail startup with an operator-visible error. Per-tick validation re-runs before each dispatch cycle; on failure, skip dispatch for that tick, keep reconciliation active, and emit an operator-visible error. Checks: the workflow file loads and parses; `tracker.kind` is present and supported; `tracker.api_key` is present after `$` resolution; `tracker.project_slug` is present when required by the tracker kind; `codex.command` is present and non-empty.

## Config cheat-sheet (§6.4)

The spec includes an intentionally redundant field summary so a coding agent can implement the config layer quickly — restating each key's type, requiredness, default, and canonical env var (e.g. `tracker.endpoint` default `https://api.linear.app/graphql`, `polling.interval_ms` default `30000`, `agent.max_concurrent_agents` default `10`, `codex.command` default `codex app-server`, plus the extension fields `worker.ssh_hosts`, `worker.max_concurrent_agents_per_host`, and `server.port`).

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
