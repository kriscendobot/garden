---
id: athanor
aliases: ["athanor", "MylesBorins/athanor", "personal LLM alchemy", "pi-agent", "pi-mono", "badlogic/pi-mono", "MLX", "mlx_lm.server", "mlx_vlm.server", "llama.cpp", "llama-server", "GGUF", "local model serving", "stable per-model port", "athanor router", "athanor ingress", "mlxFlavor", "mlxCapabilities"]
topics: [local-model-serving, llm-agent-frameworks]
status: current
---

# athanor

**Athanor** (`MylesBorins/athanor`, "personal LLM alchemy") is a Node/TypeScript TUI + CLI, Apache-2.0, that manages **local LLM inference runtimes on Apple Silicon**. It discovers MLX models in the HuggingFace cache and GGUF files on disk, registers each in `~/.athanor/models.json` with a **stable per-model port**, supervises the runtime processes (`mlx_lm.server`, `mlx_vlm.server`, `llama-server`) as detached, reattachable children, and keeps **OpenAI-compatible HTTP endpoints** live so downstream tools can call them. It is *not* a library or a daemon and does not sit in the request path: clients connect straight to each runtime's port.

Its named downstream consumer is **pi-agent** (`badlogic/pi-mono`), a coding agent. Athanor's `sync` module publishes exposed local models into pi-agent's **custom-providers registry** (`~/.pi/agent/models.json`) by rewriting only the `athanor-*` entries — either as two ingress-backed aggregators (`athanor-mlx` / `athanor-llama`) or as one provider per model, following `config.router.enabled`. Everything not named `athanor-*` round-trips untouched.

**Where it fits the garden and Endo.** Athanor is the *model-serving / provisioning* layer that sits **beneath** an agent harness, distinct from the agent/orchestration layer ([[llm-agent-frameworks]]) that consumes the endpoints. For the **garden** it is a candidate self-hosted-model backend: it would stand local models up behind stable OpenAI-compatible ports the fleet's roles could target, an operational concern adjacent to the model-selection map. For **Endo** the link is through **pi-agent**: `endojs/endo-but-for-bots`' [[endopi]] design re-implements pi-agent's shape (transcript format, skills, provider registry + OAuth) under object-capability / least-authority discipline. Athanor feeds providers *into* pi's registry; endopi re-implements pi's registry *shape*. Athanor itself uses **no** SES / hardened-JS / ocap machinery — the relationship is ecosystem-adjacency, not code lineage.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/athanor--readme--overview.md) | What athanor is and does: discover / download / run / switch MLX and llama.cpp models with live OpenAI-compatible endpoints for pi-agent. |
| [registry-and-stable-ports](../sections/athanor--readme--registry-and-stable-ports.md) | `~/.athanor/models.json` schema and the stable-port invariant that lets pi be configured once per model. |
| [mlx-capabilities-and-flavor-routing](../sections/athanor--readme--mlx-capabilities-and-flavor-routing.md) | `mlxCapabilities` (detected fact) vs `mlxFlavor` (user intent); athanor never auto-routes VLM. |
| [supervisor-and-observability](../sections/athanor--readme--supervisor-and-observability.md) | Three supervisor policies over detached reattachable runtimes; tok/s parsed from logs because athanor is out of the request path. |
| [pi-agent-sync](../sections/athanor--readme--pi-agent-sync.md) | Publishing local models into pi-agent's provider registry (ingress-aggregator vs direct-per-model shapes). |
| [invariants](../sections/athanor--agents--invariants.md) | The ten load-bearing invariants that pin the tool's behavior. |
| [layout-and-state](../sections/athanor--agents--layout-and-state.md) | The `src/` module map and the state-file table. |
| [architecture-map](../sections/athanor--context-arch-map--architecture-map.md) | Compressed architecture: modules, dependency graph, data-flow phases, risk areas. |

## See also

- [[endopi]] — Endo's least-authority re-imagining of the pi-agent shape (endo-but-for-bots); the provider-registry-and-oauth sibling design is the closest surface to athanor's pi-sync.
