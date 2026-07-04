# Topic: local-model-serving

> Abstract: Local LLM inference-runtime management on a single machine: discovering MLX and llama.cpp (GGUF) models, assigning each a stable port, supervising detached runtime child processes, exposing OpenAI-compatible HTTP endpoints, and publishing the resulting providers into a downstream agent's catalog. The canonical example is **athanor** (Myles Borins), a TUI/CLI for Apple Silicon that publishes into pi-agent (badlogic/pi-mono). This is the *serving/provisioning* layer beneath an agent harness: distinct from `llm-agent-frameworks` (the agent/orchestration layer that consumes these endpoints) and from Endo's `endopi` design (which re-implements the pi-agent shape under object-capability discipline). Relevant to the garden as a possible self-hosted-model backend for the fleet.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [overview](../sections/athanor--readme--overview.md) | athanor README | Athanor is a TUI/CLI for Apple Silicon that discovers, runs, and switches between MLX and llama.cpp local models while keeping OpenAI-compatible endpoints live for downstream tools. |
| [registry-and-stable-ports](../sections/athanor--readme--registry-and-stable-ports.md) | athanor README | `~/.athanor/models.json` is the source of truth; each model gets a stable port allocated once and never changed, so pi-agent is configured once per model. |
| [mlx-capabilities-and-flavor-routing](../sections/athanor--readme--mlx-capabilities-and-flavor-routing.md) | athanor README | Two independent MLX axes: `mlxCapabilities` (detected fact) versus `mlxFlavor` (user intent about which server binary to launch); athanor never auto-routes VLM. |
| [supervisor-and-observability](../sections/athanor--readme--supervisor-and-observability.md) | athanor README | Three supervisor policies over detached, reattachable child runtimes; tok/s and CPU/RSS parsed best-effort because athanor does not sit in the request path. |
| [pi-agent-sync](../sections/athanor--readme--pi-agent-sync.md) | athanor README | Athanor publishes local models into pi-agent's provider registry by rewriting only `athanor-*` entries, in an ingress-aggregator or direct-per-model shape. |
| [invariants](../sections/athanor--agents--invariants.md) | athanor AGENTS.md | The ten load-bearing invariants: stable ports, atomic writes, preserved non-athanor pi entries, router-shaped sync, literal runtime-id match, and more. |
| [layout-and-state](../sections/athanor--agents--layout-and-state.md) | athanor AGENTS.md | The `src/` module map (adapters, discovery, registry, supervisor, sync, router, ui) and the `~/.athanor/` + pi-agent state-file table. |
| [architecture-map](../sections/athanor--context-arch-map--architecture-map.md) | athanor ARCH_MAP.md | Compressed architecture map: modules, dependency graph, data-flow phases (startup, scan, pull, mutation, start/stop, pi sync), and risk areas. |

## See also

- [llm-agent-frameworks](llm-agent-frameworks.md) — the agent/orchestration layer that consumes these endpoints (LangChain/LangGraph, pi-agent).
- [oauth-credentials](oauth-credentials.md) — the endopi provider-registry-and-oauth design that re-imagines pi-agent's multi-provider surface under Endo's least-authority discipline.
