---
title: Module layout and where state lives
source: AGENTS.md
source_repo: MylesBorins/athanor
source_commit: cd595f148a796875d071faeeff25a598e0002adb
source_date: 2026-05-24
source_authors: [Myles Borins]
ingested: 2026-07-04
ingested_by: scholar
topics: [local-model-serving]
status: current
---

Abstract: Athanor's source is partitioned into focused modules under `src/` (adapters, cli, config, control, discovery, pull, registry, router, search, supervisor, sync, ui, types) and its persistent state lives in a small set of JSON/log files under `~/.athanor/` plus the `athanor-*` namespace of pi-agent's files. This section captures the module map and the state-file table as an at-a-glance orientation for where a given behavior or piece of state lives.

### Layout (`src/`)

- `adapters/` — `mlx_lm` + `mlx_vlm` + `llama-server` command builders, health probes, runtime model ids (`model-id.ts`)
- `cli/` — dispatcher (`index.ts`), `commands.ts`, doctor, formatting
- `config/` — config load + defaults
- `control/` — optional HTTP control API (opt-in)
- `discovery/` — HF cache scanner + ingest + `fs.watch` watcher; `detectMlxCapabilities` lives here
- `presets/` — preset merge, tunable-key metadata, recipes
- `pull/` — HF repo inspection + `hf` download wrapper
- `registry/` — atomic `models.json` CRUD, slug + port allocation, dedup on load, display labels
- `router/` — optional OpenAI-compatible proxy (opt-in, single port)
- `search/` — HF Hub search + trending
- `supervisor/` — detached process lifecycle, policy, reattach, logs
- `sync/` — namespaced pi-agent catalog merge
- `ui/` — Ink TUI: App, ModelList, LogTail, PullModal, PresetEditor
- `types/` — shared types (`ModelEntry`, `DiscoveredModel`, ...)

Entry points: `bin/athanor` → `dist/index.js` (built) or `npm start` (tsx) → `src/index.tsx`, which dispatches to TUI or `src/cli/index.ts` based on argv.

### Where state lives

| Path | Purpose |
| --- | --- |
| `~/.athanor/config.json` | user config: scan roots, port range, supervisor policy, control API |
| `~/.athanor/models.json` | registry — source of truth for slugs, ports, presets, publish state |
| `~/.athanor/recipes.json` | optional user recipes; overrides built-ins of the same name |
| `~/.athanor/logs/<slug>-<pid>.log` | per-run supervisor log |
| `~/.athanor/state.json` | running PIDs / ports for reattach |
| `~/.pi/agent/models.json` | pi-agent providers; athanor namespace only |
| `~/.pi/agent/settings.json` | pi-agent settings; only `defaultProvider` / `defaultModel` touched |
| `~/.cache/huggingface/hub` | HF snapshots scanned by the discovery scanner |

Conventions: TypeScript strict, no `any` unless unavoidable; functions named after what they do; no new top-level `*.md` docs without being asked; command output stays scannable through `format.ts`.

Source: [AGENTS.md](https://github.com/MylesBorins/athanor/blob/cd595f148a796875d071faeeff25a598e0002adb/AGENTS.md) at commit `cd595f1`.
