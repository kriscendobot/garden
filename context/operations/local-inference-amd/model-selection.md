# Model selection for a ~50–110 GB unified-memory budget

Which models to run on this box and why: the decisive **MoE-vs-dense** rule
(memory bandwidth is the bottleneck, so pick Mixture-of-Experts + quantized),
the measured gfx1151 throughput table (`gpt-oss:20b` at ~72 tg t/s as the
everyday default, `gpt-oss-120b` at ~51 t/s as the flagship this box can run),
and **raising the GPU memory budget** (`ttm.pages_limit`, a host-kernel knob) to
fit the 63–80 GB models. Read this to answer "which model, and can this host
hold it?" Getting an endpoint up to pull the model is
[serving-endpoint.md](serving-endpoint.md); pricing the chosen model as a worker
arm is [cost-model.md](cost-model.md).

The decisive fact on this box is **MoE-vs-dense**: because the iGPU's memory
bandwidth is the bottleneck, a Mixture-of-Experts model (few active params per
token) runs an order of magnitude faster than a *dense* model of the same total
size. Pick MoE and quantized (MXFP4 / Q4) models.

Measured on gfx1151 / Radeon 8060S, 128 GB, llama.cpp `-fa 1`, from the primary
Strix Halo benchmark dataset
(<https://github.com/kyuz0/amd-strix-halo-toolboxes/blob/main/docs/results.json>;
viewer <https://kyuz0.github.io/amd-strix-halo-toolboxes/>). pp512 = prompt
processing, tg128 = generation, tokens/sec:

| Model / quant | Type | ~size | pp512 t/s | **tg128 t/s** |
| --- | --- | --- | --- | --- |
| **gpt-oss-20b** (MXFP4) | MoE | ~12 GB | ~1800 | **~72** |
| **gpt-oss-120b** (MXFP4) | MoE | ~63 GB | ~650 | **~51** |
| Qwen ~35B-A3B (Q4) | MoE | ~20 GB | ~1100 | **~50** |
| Qwen ~122B-A10B (Q5) | MoE | ~80 GB | ~336 | **~19** |
| llama-2-7b (Q4_0) | dense | ~4 GB | ~1520 | **~52** |
| ~31B (gemma-class, Q4) | dense | ~18 GB | ~315 | **~10** |

Reading it for garden work:

- **Everyday worker default: `gpt-oss:20b`** — ~72 tg t/s is genuinely
  interactive, fits with huge headroom, and is the AMD playbook's own pick.
- **Best "large + still usable": `gpt-oss-120b` (MXFP4, ~63 GB) at ~51 t/s** —
  the flagship model this unified-memory box can run that a 24 GB discrete card
  cannot. Needs the GPU budget raised toward ~96 GB (§ Raising the GPU memory
  budget below).
- **8B-class dense Q4 (e.g. Llama 3.1 8B):** no direct dataset row; the
  llama-2-7b Q4 proxy puts it at **~40–55 tg t/s** (proxy; specific Llama 3.1 8B
  numbers UNVERIFIED).
- **Avoid dense ≥30B** (e.g. Llama 70B): a 70B dense Q4 fits (~40 GB) but would
  sit **below ~10 t/s** — extrapolated ~4–6 t/s, UNVERIFIED — and prompt
  processing is the weak point. Not worth it when MoE models of similar quality
  run 5–10× faster.
- **Quantization sweet spots:** MXFP4 (for gpt-oss) and Q4_K_XL per the dataset.

## Raising the GPU memory budget (to fit the 63–80 GB models)

Default GTT here is ~50 GiB; the big models need more. Per AMD's Strix Halo page
(<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>)
and the AMD memory-config playbook
(<https://github.com/amd/playbooks/blob/main/playbooks/dependencies/memoryconfig.md>):

- Keep the **BIOS "dedicated VRAM" small** (e.g. 0.5 GB, as it already is) and
  raise the **shared TTM/GTT limit** instead.
- **`amdgpu.gttsize` is deprecated** at the kernel level
  (<https://www.kernel.org/doc/html/latest/gpu/amdgpu/module-parameters.html>);
  the current knob is **`ttm.pages_limit`** (in 4 KiB pages), managed by AMD's
  helper `amd-ttm` (`pipx install amd-debug-tools`; `amd-ttm --set 100` = 100 GB).
- **Keep GTT and `ttm.pages_limit` aligned**, or ROCm under-reports memory (a
  124 GB box showed only 62 GB when they diverged —
  <https://github.com/ROCm/ROCm/issues/5595>). A community-tuned kernel cmdline
  for a 128 GB box: `amd_iommu=off ttm.pages_limit=32505856` (= 124 GiB;
  `amd_iommu=off` measured 5–12% faster) —
  <https://github.com/kyuz0/amd-strix-halo-toolboxes>.
- **Caveat:** these are **host kernel** parameters (cmdline / modprobe). They
  cannot be set from inside the container; a maintainer sets them on the host
  and reboots. Effective GPU memory = min(GTT, `ttm.pages_limit`) drawn from the
  same physical RAM as the OS — leave OS headroom (AMD's worked example uses
  ~100 GB to GPU on a 128 GB box).
