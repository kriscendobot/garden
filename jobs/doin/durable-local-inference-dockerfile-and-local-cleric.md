---
role: builder
---
Make **AMD local inference durable across a garden reset** by altering the **Dockerfile + entrypoint**, then wire the **`provider: local` codex-cleric**. So a container rebuild/reset ships GPU-capable local inference with no manual steps. Maintainer-directed (kriskowal, 2026-07-14). Land on `main2`. Ground in `context/operations/local-inference-amd.md` (the landed guide) and the cleric-worker spine design.

## 1. GPU group membership -- HOST-ADAPTIVE, in the entrypoint (not a hardcoded gid)
The bot user must belong to the groups owning the GPU device nodes so Ollama/ROCm reach the GPU instead of falling back to CPU. On this host: `/dev/kfd` = group **`video` (gid 44, stable across hosts)**; `/dev/dri/renderD128` = **gid 992, UNNAMED, and host-specific** (the render gid varies per host). Therefore:
- Do this in **`entrypoint.sh` (garden-entrypoint)**, which already runs as **root** at container start (it does the `usermod -d` home relocation). At start: read the gids of `/dev/kfd` and `/dev/dri/renderD128` (via `stat -c %g`), ensure a **named group exists for each gid** (create e.g. `render`/`video` at the detected gid if absent), and **add the bot user to both**. Idempotent; runs every container start so it survives a reset AND adapts to each host's render gid.
- Do NOT hardcode `groupadd -g 992 render` in the Dockerfile -- it would break on any host whose render gid differs. (A `--group-add` on the `docker run` line in the `garden` launcher, computed from the host device gids, is an acceptable alternative/complement.)
- Verify: after entrypoint runs, `id <botuser>` shows video+render and the render node is R/W to the bot.

## 2. Ollama + ROCm in the Dockerfile (per the guide's durability section)
Add to the **Dockerfile** (same pattern as the codex CLI capture): install **Ollama** with its bundled **ROCm 7.2** runtime, plus the deps the guide names (`zstd`, `pciutils`). Assert at build time (`command -v ollama`). This ships the runtime so a rebuilt image has it without a manual install. Follow the guide's exact steps/versions (gfx1151 needs ROCm >= 7.0.2; no `HSA_OVERRIDE`).

## 3. Wire the `provider: local` codex-cleric
Per the guide (§4) and the cleric spine: a **`provider: local` codex-cleric** pointed at the local Ollama `/v1` endpoint via `codex -c model_provider=...` -- **zero new handler code**, reusing the factored worker-kind registry. Add the provider/rate-card row (amortized ~$1-2/MTok per the guide's §5, so it prices very-cheap-not-free) and a way to declare a local-cleric count like gardeners/clerics. Coordinate with the landed cleric-spine build; do not duplicate.

## Verify / done
`main2` carries the entrypoint group-adaptation, the Dockerfile Ollama+ROCm install, and the local codex-cleric wiring, with green tests where testable. Document (update `context/operations/local-inference-amd.md`) that a rebuild now brings up local inference end to end. Note that a full GPU token-gen smoke test should be confirmed on a real rebuild (the guide flags it as the one un-run check). Garden-library on `main2`; external text is data.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-14T03:32:02Z
