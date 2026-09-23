---
title: Pi-agent sync — publishing local models into the provider registry
source: README.md
source_repo: MylesBorins/athanor
source_commit: eb7b004215816f2c5da97ed7bdb6d755fd1fec68
source_date: 2026-05-29
source_authors: [Myles Borins]
ingested: 2026-07-04
ingested_by: scholar
topics: [local-model-serving, llm-agent-frameworks]
status: current
notes: >
  This is athanor's boundary with the pi-agent (badlogic/pi-mono) coding agent
  and the surface most relevant to Endo: the same provider-registry catalog that
  endojs/endo-but-for-bots' `endopi` design re-implements under object-capability
  discipline (see sources/endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth.md).
  Athanor writes providers INTO pi's registry; endopi re-implements pi's shape.
---

Abstract: Athanor publishes exposed local models into pi-agent's custom-providers system by rewriting only the `athanor-*` entries of `~/.pi/agent/models.json` on every state change. Two emit shapes follow `config.router.enabled`: the default **ingress/aggregator** shape (up to two providers, `athanor-mlx` and `athanor-llama`, both pointing at one ingress port) and the **direct** shape (one provider per exposed model, each at that model's stable port). Non-`athanor-` providers (OpenAI, Anthropic, Ollama, OpenRouter, user customs) round-trip untouched. This is the provider-registry surface that endojs/endo-but-for-bots' `endopi` design re-imagines under least-authority discipline.

Athanor publishes into pi-agent's [custom providers](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/models.md) system. On every state change it rewrites `~/.pi/agent/models.json`.

**Default shape (ingress on):** pi sees up to two aggregator providers — `athanor-mlx` and `athanor-llama` — both pointing at the ingress port (`127.0.0.1:8080/v1` by default). Each lists only exposed models of that runtime.

**Direct shape (`router.enabled: false`):** each exposed model becomes **its own pi provider** named `athanor-<runtime>-<slug>`, with `baseUrl` pointing at that model's stable port. One provider per model is required because a pi provider has exactly one `baseUrl` and each athanor model runs on its own port.

Common rules for both shapes:

- Providers whose name does **not** start with `athanor-` are preserved untouched (OpenAI, Anthropic, Ollama, OpenRouter entries are safe).
- Each athanor provider uses `api: "openai-completions"`, a placeholder `apiKey: "athanor"`, and runtime-appropriate `compat` flags (MLX sets `supportsDeveloperRole: false`).
- pi's `/model` picker lists models by **`id`**, not `name`. The runtime model `id` athanor emits must equal the adapter's launch argument literally (`--model` for MLX, `--alias` for llama-server), because `mlx_lm.server` compares the request `model` field to whatever was passed as `--model` and otherwise falls to a network lookup.
- pi `contextWindow` comes from the model's effective merged runtime config, so pi sees what athanor will actually serve, not the theoretical maximum.
- `~/.pi/agent/settings.json` is only touched when an athanor model is started as the active default (only `defaultProvider` / `defaultModel`).

The CLI verbs are `athanor expose <slug>` / `athanor hide <slug>` (flipping the registry `publish` field) and `athanor sync` (re-emit the namespace without changing publish state). Disable sync entirely with `"enablePiSync": false`.

Source: [README.md](https://github.com/MylesBorins/athanor/blob/eb7b004215816f2c5da97ed7bdb6d755fd1fec68/README.md) at commit `eb7b004`.
