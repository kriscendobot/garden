---
title: Load-bearing invariants
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

Abstract: Athanor's `AGENTS.md` enumerates ten non-negotiable invariants that any contributor (human or AI agent) must preserve. They are the crisp contract of the tool: stable ports, atomic registry writes, preservation of non-athanor pi entries, the router-shaped pi-sync, literal runtime-id matching, effective-context advertisement, the capability-vs-flavor split, the single-active default policy, non-destructive scans, and helper-mediated mutations.

These invariants are load-bearing; a change that seems to need to break one must stop and ask.

1. **Stable port per model.** Ports allocated on first discovery from `config.portRange`, persisted on the registry entry forever; pi-agent provider URLs must be stable across restarts.
2. **Atomic registry writes.** `~/.athanor/models.json` is always written via temp-file + rename in `src/registry/index.ts`; never partial-written, never kept open across awaits.
3. **Preserve non-athanor pi entries.** `src/sync/pi.ts` rewrites only providers whose name starts with `athanor-`; everything else in `~/.pi/agent/models.json` round-trips untouched. Same for `settings.json` (only `defaultProvider` / `defaultModel`, and only when a model is started as the active default).
4. **Pi sync shape follows `config.router.enabled`.** Default (`true`): up to two aggregator providers pointing at the ingress `baseUrl`, each listing only its runtime's models with runtime-specific compat flags, zero-member providers suppressed. When `false`: one `athanor-<runtime>-<slug>` provider per exposed model. Never emit both shapes. The registry field is `publish: boolean` (kept stable for on-disk back-compat); CLI verbs are `expose` / `hide`.
5. **Runtime model id matches launch argument literally.** The pi model `id` emitted must equal the adapter's `--model` (MLX) or `--alias` (llama-server), because `mlx_lm.server` falls back to a HuggingFace network lookup on mismatch.
6. **Pi context metadata reflects effective served context.** `src/sync/pi.ts` advertises the effective runtime context window from merged runtime config, not only explicit preset fields and not the theoretical maximum.
7. **MLX capability detection and flavor routing are separate axes.** `mlxCapabilities` is a detected fact (safe to overwrite on re-scan, single source in `detectMlxCapabilities`); `mlxFlavor` is user intent (only set by `athanor flavor`; discovery and ingest never touch it).
8. **Supervisor default policy is `single-active`.** Starting model B stops model A unless the user opts into `multi-active-lru` or `manual`.
9. **Presets are additive, scans are non-destructive.** `athanor scan` refreshes `path`, `sizeBytes`, `mlxCapabilities`; `preset`, `publish`, `piAlias`, `tags`, `port`, `slug`, `mlxFlavor` survive re-scans.
10. **All mutations go through helpers.** Use `setPresetFields` / `unsetPresetFields` / `recipeToPreset` from `src/presets/edit.ts` and `updateModel` from `src/registry/index.ts`; do not hand-edit registry objects.

Source: [AGENTS.md](https://github.com/MylesBorins/athanor/blob/cd595f148a796875d071faeeff25a598e0002adb/AGENTS.md) at commit `cd595f1`.
