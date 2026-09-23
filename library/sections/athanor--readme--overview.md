---
title: Overview — what athanor is and does
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

Abstract: Athanor ("personal LLM alchemy") is a TUI/CLI for Apple Silicon that discovers, downloads, configures, runs, and switches between MLX and llama.cpp (GGUF) local models, keeping an OpenAI-compatible HTTP endpoint live for downstream tools. It is the serving/provisioning layer beneath an agent harness: it does not sit in the request path, it stands runtimes up and publishes their endpoints. The named downstream consumer is pi-agent (badlogic/pi-mono).

Athanor — personal LLM alchemy. Discover, download, configure, and switch between MLX and llama.cpp models on Apple Silicon from a single TUI or CLI, while keeping an OpenAI-compatible HTTP endpoint live for downstream tools (pi-agent, editors, etc.).

What it does:

- **Discovers** MLX models in your HuggingFace cache and GGUF files in `~/.models`.
- **Downloads** new models from HuggingFace via the `hf` CLI.
- **Runs** them via `mlx_lm.server` or `llama-server`, one or more at a time, each on a stable port.
- **Supervises** the processes as detached children with per-process log files and automatic reattach.
- **Publishes** exposed models to pi-agent (`~/.pi/agent/models.json`) — by default via ingress-backed `athanor-mlx` / `athanor-llama` aggregators — leaving your other (cloud, Ollama, etc.) providers alone.
- **Exposes** an optional local control API so other tools can ask athanor to activate a model on demand.

Prerequisites: macOS on Apple Silicon; Node.js 18 or newer; `mlx_lm.server` (text-only MLX); `mlx_vlm.server` (vision/multimodal MLX, optional); `llama-server` (llama.cpp); `hf` (HuggingFace CLI, only for `athanor pull`). `athanor doctor` verifies these are on `PATH`.

Surfaces are an Ink TUI (bare `athanor`) and a hand-rolled CLI (`athanor <cmd>`). The project is Apache-2.0, Node/TypeScript (Ink + React), with no network listeners of its own except the runtime children and an optional local control API (off by default). It is explicitly "not a library, not a daemon."

Source: [README.md](https://github.com/MylesBorins/athanor/blob/eb7b004215816f2c5da97ed7bdb6d755fd1fec68/README.md) at commit `eb7b004`.
