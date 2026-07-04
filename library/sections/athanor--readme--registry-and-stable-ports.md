---
title: Registry and stable per-model ports
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

Abstract: `~/.athanor/models.json` is athanor's source of truth. Each model row carries a stable canonical `id`, a short user handle `slug`, `path`, `runtime` (`mlx`|`llama.cpp`), `source`, a **stable `port`** allocated once and never changed, a merge-on-top `preset`, `mlxFlavor`, a `publish` flag (whether pi-agent sees it), an optional `piAlias`, and `tags`. The stable-port invariant is what lets pi-agent be configured once per model regardless of which model is currently active.

### Registry

`~/.athanor/models.json` is the source of truth. Every model has:

| field | purpose |
| --- | --- |
| `id` | stable canonical id (HF repo, repo+file, or `local:...`) |
| `slug` | short user-editable handle (`qwen-32b`) |
| `path` | on-disk location athanor passes to the runtime |
| `runtime` | `mlx` or `llama.cpp` |
| `source` | `{ type: "hf", repo, [revision], [file] }` or `{ type: "local" }` |
| `port` | **stable** port allocated once per model, never changes |
| `preset` | per-model overrides that merge on top of global runtime config |
| `mlxFlavor` | `"lm"` or `"vlm"`: picks which MLX binary to use (MLX only) |
| `publish` | whether pi-agent sees this model |
| `piAlias` | optional llama launch alias; when set to something other than `slug`, overrides the default runtime model id |
| `tags` | free-form labels (`chat`, `coder`, ...) |

### Stable per-model ports

Each model is bound to a port at first ingest and keeps it forever. This means pi-agent's catalog is configured **once per model**; switching which model is active does not change pi's URLs, only the `status` field athanor writes into each entry. Port range is configurable (`portRange` in `~/.athanor/config.json`, default 8081 to 8099).

On load, athanor collapses duplicate registry rows that share the same normalized on-disk path (keeping the HF-sourced entry when present) and upgrades local GGUF paths under `org--repo/` directories to HF source metadata when possible.

Source: [README.md](https://github.com/MylesBorins/athanor/blob/eb7b004215816f2c5da97ed7bdb6d755fd1fec68/README.md) at commit `eb7b004`.
