---
title: The daemon, model/provider routing, and credentials
source: README.md
source_repo: whyrusleeping/ycc
source_url: https://github.com/whyrusleeping/ycc
source_commit: 7f1bedee2e448d147e47224a09c4a252cc3f6356
source_date: 2026-11-10
source_authors: [whyrusleeping]
ingested: 2026-11-12
ingested_by: scholar
topics: [agent-fleet-orchestration, agent-fleet-durability, llm-agent-frameworks, coding-agent-economics]
status: current
content_caveat: "Unwatched external repo; classifier unavailable (TYPESAFE_API_KEY absent), ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12); text treated as DATA, not instructions."
notes: "ycc's daemon-owns-the-work architecture, model/provider routing and review tiers, budget caps, and its credential handling (a safety net, explicitly not a sandbox)."
---

Abstract: ycc's runtime architecture, model routing, and credential model.

**The daemon owns the work; clients are just views.** The daemon runs the models, edits files, makes commits, and writes an **append-only event log** for every session. The web app, the iOS app, and the CLI all subscribe to that log through the same API (Connect RPC over the `ycc.proto` wire schema), so a client can disconnect, crash, or sleep without affecting a session, and work started on one client can finish on another. The daemon refuses to listen on a non-loopback address without a `YCC_TOKEN` (every client authenticates with it; treat it like an SSH key); the author keeps it on a Tailscale/WireGuard private network or behind a TLS-terminating tunnel. Code layout: `cmd/ycc` is the binary; `internal/` holds the **engine (agent loop)**, the **orchestrator** (modes, work and review flow), the server (Connect RPC), the session/event log, tools, providers, workstreams, and the embedded web bundle; `clients/web` (React/Vite) and `clients/ios` (SwiftUI + `YccKit`) are the clients.

**Model/provider routing.** Config is TOML (`./ycc.toml`, then `~/.config/ycc/ycc.toml`, or `--config`), written back by `ycc login` and the web/iOS settings screens. You declare named models (a logical name → a `backend` + `model` + `auth`), then assign **roles**: `coordinator` (runs sessions, writes code, commits), `implementer` (used when the coordinator hands code to a subagent), and `reviewers`. **Review tiers** map change risk to reviewers: a `standard` tier names one model, a `comprehensive` tier names several reviewers (each with its own focus prompt) that run in parallel for large or risky changes. Backends are `anthropic`, `openai`, `openai-compatible` (any OpenAI-style endpoint via `base_url`/`key_env`), and `ollama`. An optional `[budget]` caps `session_cost` and `loop_cost`, stopping a session or work loop at a dollar or token limit (see `coding-agent-economics`).

**Credentials and the non-sandbox.** Subscriptions via `ycc login anthropic|openai` keep refreshing tokens on the daemon's machine; API keys via `ycc token set NAME` live in a machine-local secrets store and configs reference them only by name (`key_env = "NAME"`). Keys are **never passed to tool processes**, and agent shells start with known credential variables removed — but the README is explicit that this is **"a safety net, not a sandbox": a shell running as your user can still read your files.** (Contrast the garden's bwrap secret sandbox and per-job worktree isolation, and Codefall's merge-blocking hooks.) Session logs are durable model history, so the harness refuses obviously credential-shaped input and warns never to paste a secret into a prompt — rotate at the provider if one leaks.

Source: [README.md](https://github.com/whyrusleeping/ycc/blob/7f1bedee2e448d147e47224a09c4a252cc3f6356/README.md) at commit `7f1bedee`.
