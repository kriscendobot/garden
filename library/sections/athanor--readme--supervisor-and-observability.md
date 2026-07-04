---
title: Supervisor, policies, and observability
source: README.md
source_repo: MylesBorins/athanor
source_commit: eb7b004215816f2c5da97ed7bdb6d755fd1fec68
source_date: 2026-05-29
source_authors: [Myles Borins]
ingested: 2026-07-04
ingested_by: scholar
topics: [local-model-serving]
status: current
---

Abstract: Athanor's supervisor manages N concurrent runtime children under one of three policies (`single-active` default, `multi-active-lru`, `manual`). Children are spawned `detached` with stdio redirected to per-run log files and `unref`ed so the CLI/TUI can exit without killing them; athanor reattaches by PID on next launch. Readiness is polled from each runtime's health endpoint. Observability (`tok/s`, CPU%, RSS) is parsed best-effort from logs and `ps` because athanor does **not** sit in the request path: clients connect directly to each runtime's port.

### Supervisor and policies

The runtime supervisor manages N concurrent child processes. Three policies:

- `single-active` (default) — starting a model stops any others.
- `multi-active-lru` — keep up to `supervisor.maxConcurrent` running; evict the least-recently-started.
- `manual` — never auto-stop; you decide.

Children are started with `detached: true`, stdio redirected to `~/.athanor/logs/<slug>-<pid>.log`, and `unref()`ed so the CLI/TUI can exit without killing them. On next launch athanor reattaches via PID. Readiness is detected by polling the runtime's health endpoint (`/health` for llama.cpp, `/v1/models` for mlx_lm.server), not by matching stdout strings.

### Observability

The TUI banner shows system CPU and RAM bars plus 1-minute load average, refreshed once a second; each running row gets a `CPU% · RSS · tok/s` suffix, mirrored by `athanor status`. Caveats:

- **CPU% is per-core, not per-machine** (matching `ps` / Activity Monitor); a runtime using 8 cores reads as ~800%.
- **RSS is resident set size**, the honest "how much RAM this model is pinning" number on Apple Silicon's unified memory.
- **tok/s is post-request, not live.** Athanor does not sit in the request path; clients connect directly to each runtime's port. The number is parsed from the per-completion timing line the runtime writes to its log and updates once a generation finishes.
- Sampling is best-effort: if `ps` fails or a log format changes, the affected column is hidden rather than showing a wrong number.

Source: [README.md](https://github.com/MylesBorins/athanor/blob/eb7b004215816f2c5da97ed7bdb6d755fd1fec68/README.md) at commit `eb7b004`.
