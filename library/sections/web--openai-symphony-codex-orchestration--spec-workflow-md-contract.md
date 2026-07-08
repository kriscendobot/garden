---
title: Symphony Service Specification — the WORKFLOW.md repository contract
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

Abstract: The `WORKFLOW.md` repository contract (§5 of the spec) — the version-controlled, repo-owned file that carries both the per-issue **prompt template** and the runtime **configuration** so a team versions its agent policy with its code. `WORKFLOW.md` is Markdown with optional YAML front matter: front matter becomes typed config, the trimmed body becomes the prompt template. The front-matter schema has six top-level keys — `tracker`, `polling`, `workspace`, `hooks`, `agent`, `codex` — with unknown keys ignored for forward compatibility and documented extension points (e.g. `server.port`, `worker.ssh_hosts`). The prompt template renders with a strict Liquid-compatible engine (unknown variables/filters fail) over an `issue` object and an `attempt` integer. A small error taxonomy separates parse/config errors (which block new dispatches) from per-run template render errors (which fail only that attempt).

## File discovery and format (§5.1–§5.2)

Workflow file path precedence: an explicit application/runtime setting (CLI startup path), else default `WORKFLOW.md` in the process working directory. If the file cannot be read, return `missing_workflow_file`. The file is expected to be repo-owned and version-controlled.

`WORKFLOW.md` is Markdown with optional YAML front matter, and should be self-contained enough to describe and run different workflows (prompt, runtime settings, hooks, tracker selection/config) without out-of-band service-specific config. Parsing rules: if the file starts with `---`, parse until the next `---` as YAML front matter and the remainder as prompt body; absent front matter means the whole file is the prompt body with an empty config; front matter must decode to a map; the prompt body is trimmed. The returned object is `{config, prompt_template}`.

## Front-matter schema (§5.3)

Top-level keys: `tracker`, `polling`, `workspace`, `hooks`, `agent`, `codex`. Unknown keys are ignored for forward compatibility; extensions may define additional top-level keys (e.g. `server`) and should document their field schema, defaults, validation, and whether changes apply dynamically or require restart.

- **`tracker`** — `kind` (required for dispatch; current value `linear`); `endpoint` (default `https://api.linear.app/graphql` for Linear); `api_key` (literal or `$VAR_NAME`; canonical env `LINEAR_API_KEY`; empty resolution = missing); `project_slug` (required for Linear); `active_states` (default `Todo`, `In Progress`); `terminal_states` (default `Closed`, `Cancelled`, `Canceled`, `Duplicate`, `Done`).
- **`polling`** — `interval_ms` (default `30000`; re-applied at runtime without restart).
- **`workspace`** — `root` (path or `$VAR`; default `<system-temp>/symphony_workspaces`; `~` and separator-containing strings expanded; bare names preserved).
- **`hooks`** — `after_create` / `before_run` / `after_run` / `before_remove` (multiline shell scripts, all optional); `timeout_ms` (default `60000`). `after_create` failure aborts workspace creation; `before_run` failure aborts the attempt; `after_run` and `before_remove` failures are logged and ignored.
- **`agent`** — `max_concurrent_agents` (default `10`); `max_turns` (default `20`); `max_retry_backoff_ms` (default `300000` / 5m); `max_concurrent_agents_by_state` (map state→positive int, keys normalized, invalid entries ignored).
- **`codex`** — `command` (default `codex app-server`, launched via `bash -lc` in the workspace); `approval_policy` / `thread_sandbox` / `turn_sandbox_policy` (pass-through Codex app-server config values, defaults implementation-defined — inspect via `codex app-server generate-json-schema`); `turn_timeout_ms` (default `3600000` / 1h); `read_timeout_ms` (default `5000`); `stall_timeout_ms` (default `300000` / 5m; `<= 0` disables stall detection).

Documented extension fields include `server.port` (enables the optional HTTP server), `worker.ssh_hosts` (SSH hosts to distribute work across; omitted = local), and `worker.max_concurrent_agents_per_host` (per-host concurrency cap).

## Prompt template contract (§5.4)

The Markdown body is the per-issue prompt template. Render with a strict engine (Liquid-compatible semantics suffice): **unknown variables must fail rendering; unknown filters must fail rendering.** Input variables: `issue` (all normalized fields including labels/blockers) and `attempt` (null/absent on the first attempt, integer on retry/continuation). If the prompt body is empty, the runtime may use a minimal default (`You are working on an issue from Linear.`); file read/parse failures are config errors and must not silently fall back to a prompt.

## Validation and error surface (§5.5)

Error classes: `missing_workflow_file`, `workflow_parse_error`, `workflow_front_matter_not_a_map`, `template_parse_error`, `template_render_error`. Dispatch gating: **workflow file read / YAML errors block new dispatches** until fixed; **template errors fail only the affected run attempt.**

> The garden's equivalent of `WORKFLOW.md` is split rather than unified: the per-role `AGENT.md` carries the prompt/policy, the job body carries the per-task instruction, and the systemd/service config carries runtime settings. Symphony's single-file, in-repo, version-controlled policy is a tighter packaging of the same "policy lives with the code, read just-in-time" principle.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
