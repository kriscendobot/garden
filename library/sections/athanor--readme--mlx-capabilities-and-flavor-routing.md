---
title: MLX capabilities and flavor routing
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

Abstract: MLX entries track two independent axes. `mlxCapabilities` is a detected *fact* (does the snapshot's `config.json` advertise a vision tower?), refreshed on every scan. `mlxFlavor` is user *intent* about which server binary to launch: `"lm"` routes to `mlx_lm.server` (the default, no torch needed), `"vlm"` routes to `mlx_vlm.server` (needs torch + torchvision, for real image input). The split is deliberate: many VLM-tagged repos run fine text-only under `mlx_lm.server`, so athanor never auto-routes and leaves the flavor upgrade to the user via `athanor flavor <slug> lm|vlm`.

MLX entries track two independent axes:

- `mlxCapabilities` — *what the model advertises*. Detected from the snapshot's `config.json` at scan and pull time, primarily by looking for a `vision_config` block, with fallbacks for known VLM `model_type` values (`qwen2_vl`, `qwen2_5_vl`, `llava*`, `mllama`, `pixtral`, `idefics2/3`, `phi3_v`) and architecture-name patterns such as `Qwen2VLForConditionalGeneration`. Today the only capability is `"vlm"`. Capabilities are refreshed on every scan.
- `mlxFlavor` — *which server binary to launch*. `"lm"` routes to `mlx_lm.server` (the default, no torch/torchvision required); `"vlm"` routes to `mlx_vlm.server` (requires torch + torchvision; needed for actual image input). Never set automatically — you choose with `athanor flavor <slug> lm|vlm`.

The split is deliberate: many VLM-tagged repos (Qwen2.5-VL, Qwen3-VL-MLX) run fine as text-only under `mlx_lm.server`, which is lighter, faster to load, and does not need a PyTorch install. Auto-routing every VLM-capable repo to `mlx_vlm.server` would silently break text-only workflows whenever torch is not available. So athanor defaults everything to `lm` and leaves the upgrade to the user.

In `athanor ls` and `athanor show`, entries with `mlxFlavor: "vlm"` display `mlx-vlm` in the runtime column; `athanor show` prints a `caps` row and, for vision-capable entries still on `lm`, a hint pointing at `athanor flavor <slug> vlm`. In pi-agent, VLM-flavored entries render as `[mlx-vlm] <repo> (athanor)`; the provider id stays `athanor-mlx-<slug>` regardless of flavor, so pi URLs do not churn if a model's flavor is toggled later.

Source: [README.md](https://github.com/MylesBorins/athanor/blob/eb7b004215816f2c5da97ed7bdb6d755fd1fec68/README.md) at commit `eb7b004`.
