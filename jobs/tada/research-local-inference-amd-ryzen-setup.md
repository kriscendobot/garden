Completion report:

## Job complete: local-inference-amd host-setup guide

**Delivered:** `context/operations/local-inference-amd.md` on `main2` (commit `a251002d61`, pushed to `origin/main2`; indexed in `context/operations/README.md`). A peer's cleric-worker-spine build landed on top — my doc references that design and remains accurate.

**What the guide covers** (all 6 required areas, research-grounded with per-fact source URLs; unverified items marked):
1. **ROCm/gfx1151** — minimum **ROCm 7.0.2** for stable Linux gfx1151 (7.2.x current), the gotcha that gfx1151 is absent from the canonical compat matrix but supported on the Radeon/Ryzen shelf, Ubuntu-24.04 install steps, **no `HSA_OVERRIDE_GFX_VERSION` needed** (legacy `11.0.0` spoof vs. exact-match `11.5.1`), and the **kernel-6.17 HWE memory-stability caveat** (needs `≥6.17.0-19.19~24.04.2`; this host on `-35` is past it).
2. **Endpoint** — Ollama recommended for the headless `/v1`; vLLM (`vllm/vllm-openai-rocm`, now gfx1151-supported) and llama.cpp as alternatives, with smoke-test curls.
3. **Model selection** — MoE-over-dense is the decisive insight; `gpt-oss:20b` (~72 t/s) default, `gpt-oss-120b` (~51 t/s) as the flagship the unified-memory box can run, with measured tok/s from the primary Strix Halo dataset; GTT-budget raising via `ttm.pages_limit`/`amd-ttm`.
4. **Worker backend** — recommends a `provider: local` codex-cleric pointed at the local `/v1` via `-c model_provider` (**zero new handler code**, reusing the factored spine's registry) over a dedicated handler.
5. **Bid-auction cost** — honest amortized **~$1–2/MTok** (power + hardware) so local prices as very-cheap-not-free, with the aggressive-bid-on-low-risk-work-classes posture.
6. **Durability** — proposed Dockerfile additions (zstd/pciutils, Ollama + bundled ROCm 7.2, `usermod -aG video,render`) in the codex-CLI-capture pattern.

**Verify-by-doing done:** probed the host (Ryzen AI Max+ 395, 125 GiB RAM, GTT 50 GiB, kernel 6.17, no host ROCm, GPU device nodes present in-container); **installed Ollama 0.31.2 with its bundled ROCm 7.2 runtime and confirmed gfx1100–1151 rocBLAS kernels are present**. Found and documented the key in-container gotcha: the GPU device nodes are present but the bot user isn't in `video`/`render`, so serve falls back to CPU until `usermod -aG video,render` (or root).

**Follow-up (documented in the doc):** a clean end-to-end `/v1/chat/completions` **GPU token-generation** smoke test was not captured on this host — the fleet reaper repeatedly interrupted the `ollama serve`/model-pull cycles (blocking commands trip its timeout). The install and ROCm/gfx1151 runtime are verified present; a non-reaped run or maintainer should add the groups, `ollama pull gpt-oss:20b`, and confirm `ollama ps` shows `100% GPU`. Other follow-ups: host-side `ttm.pages_limit` tuning is untested, and the §5 rate-card dollars are illustrative pending real box-price/`amd-smi` measurement.
