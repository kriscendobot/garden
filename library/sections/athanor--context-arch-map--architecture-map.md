---
title: Architecture map — modules, dependency graph, data flow, risk areas
source: context/ARCH_MAP.md
source_repo: MylesBorins/athanor
source_commit: cd595f148a796875d071faeeff25a598e0002adb
source_date: 2026-05-24
source_authors: [Myles Borins]
ingested: 2026-07-04
ingested_by: scholar
topics: [local-model-serving]
status: current
notes: >
  Reference-shaped doc; consolidated to one section preserving the module list,
  dependency graph, data-flow phases, and risk areas for grep-based lookup.
---

Abstract: Athanor's `context/ARCH_MAP.md` is the compressed, code-driven architecture map maintained for future work: the module roster, the dependency graph, the end-to-end data-flow phases (startup, scan/discovery, pull/materialization, registry mutation, start/stop/restart, pi sync, TUI flow), and the acknowledged tight-coupling risk areas. It is the entry point the project's own agents consult before touching code.

### Modules (data-flow roles)

- **entrypoint** (`src/index.tsx`) — bootstraps base dirs, dispatches CLI vs TUI, starts optional control API, reconciles detached router lifecycle.
- **config** — home paths, defaults, load/save, sanitization, effective runtime baselines.
- **registry** — atomic `models.json` CRUD, slug + stable-port allocation, shared materialization, duplicate cleanup on load, fit/recommendation inference.
- **discovery** — scan HF/local roots, `detectMlxCapabilities`, ingest into registry, watch for changes.
- **pull** — inspect HF repos, download, materialize pulled entries.
- **adapters** — runtime-specific command building, merged config resolution, health probes, runtime model ids.
- **presets** — tunable runtime overrides, built-in recipes with context bands, editing helpers.
- **supervisor** — detached child lifecycle, policy enforcement, reattach, logs, metrics, inflight drain.
- **sync** — merge athanor providers into pi-agent files and update defaults.
- **router** — optional OpenAI-compatible proxy over published models plus detached lifecycle coordination.
- **control** — optional local HTTP API for activate/deactivate/status.
- **search** — HF search/trending queries.
- **app** (`src/app/models.ts`) — thin orchestration layer for model operations + pi-sync side effects.
- **cli / ui** — command dispatch and Ink TUI components/hooks.

### Dependency graph (selected edges)

- entrypoint → config, discovery, cli, ui, control, router
- cli → app, registry, supervisor, presets, adapters, search, config, router
- ui → app, registry, supervisor, discovery watcher, presets, pull suggestions
- app → registry, discovery, pull, supervisor, sync
- router → registry, supervisor, adapters, config
- sync → registry, config, adapters
- supervisor → adapters, config, registry, inflight, state, metrics

### Data flow

- **Startup:** `index.tsx` ensures base dirs, dispatches to CLI; if no CLI command handles argv, enters TUI. TUI startup does eager `ingestDiscovered()`, starts the control API when configured, reconciles detached router state.
- **Scan/discovery:** scanner scans HF cache + local GGUF roots, detects MLX capabilities, ingest maps discovered models into shared registry materialization while preserving user-owned fields; watcher re-triggers ingest on filesystem changes.
- **Pull/materialization:** resolve repo/file/runtime, download, materialize/update a registry entry, refresh MLX capabilities for pulled MLX repos.
- **Registry mutation:** persisted in `~/.athanor/models.json`; atomic writes only through `src/registry/index.ts`; semantic mutation helpers for publish/flavor/preset/last-used; app-layer operations wrap mutations and trigger pi sync.
- **Start/stop/restart:** CLI/TUI/control call `src/app/models.ts` → supervisor applies policy, spawns detached child, health-checks, persists runtime state, reattaches on startup; router lifecycle coordinated via `src/router/lifecycle.ts` so router mode follows active model state rather than foreground TUI lifetime; stop drains router inflight work before SIGTERM.
- **Pi sync:** `src/sync/pi.ts` reads registry + config and rewrites only `athanor-*` providers; router-off yields one provider per published model, router-on yields up to two runtime aggregators; `contextWindow` comes from effective merged runtime config.

### Tight coupling / risk areas

- Sync side effects centralized by convention, not events (mutation paths can still bypass the service layer).
- Supervisor and registry remain directly coupled (supervisor touches `lastUsedAt`).
- Router request handling is pragmatic, not fully streaming end-to-end (bodies parsed into memory before proxying).
- App shell still owns layout/mode composition.

Source: [context/ARCH_MAP.md](https://github.com/MylesBorins/athanor/blob/cd595f148a796875d071faeeff25a598e0002adb/context/ARCH_MAP.md) at commit `cd595f1`.
