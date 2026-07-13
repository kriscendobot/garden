---
role: researcher
---
Produce a **host-setup guide for local LLM inference on this garden's AMD Ryzen host**, so we can add a **gardener that uses local inference**. Ground it in AMD's playbooks (https://github.com/amd/playbooks) and the ROCm docs (`rocm.docs.amd.com`). Land as a context/operations doc on `main2` (e.g. `context/operations/local-inference-amd.md`), direct push (no PR).

## The actual host (probed 2026-07-13)
- APU: **AMD Ryzen AI Max+ 395 w/ Radeon 8060S** -- Strix Halo: RDNA 3.5 **Radeon 8060S iGPU (gfx1151)** + **XDNA2 NPU**, **unified memory** (iGPU shares system RAM -- large models fit; verify actual RAM + the GTT/VRAM split and how to raise the GPU memory budget).
- OS **Ubuntu 24.04.4 LTS**, kernel **6.17**. **No ROCm installed** (`/opt/rocm` absent) -- that is step 1.
- The garden **container already has GPU device access**: `/dev/kfd` and `/dev/dri/{card1,renderD128}` are present inside it -- so ROCm inference can run **in-container** (no passthrough work). Confirm this and document whether ROCm installs host-side, in-container, or both.

## Relevant AMD playbooks (https://github.com/amd/playbooks)
The **OpenAI-compatible-serving** ones are what a worker backend needs: **Quick Start on vLLM** (production serving on ROCm), **Getting Started with Ollama** (easiest; REST/OpenAI-compatible API). Also present: **Running LLMs with PyTorch + ROCm**, **LM Studio**, **llama.cpp RPC clustering**. Pick/document the path(s) best for a **headless server** exposing an **OpenAI-compatible `/v1` endpoint** on this iGPU (Ollama and/or vLLM the likely picks; llama.cpp+ROCm the lightweight option).

## What the guide must cover
1. **ROCm install for gfx1151 (Strix Halo iGPU)** -- recent, version-sensitive support: determine the **minimum ROCm version** that supports gfx1151, exact Ubuntu-24.04 install steps (amdgpu-dkms / rocm packages), and whether an **`HSA_OVERRIDE_GFX_VERSION`** or a specific build is required. Cite the ROCm doc for the version; do NOT guess.
2. **Stand up an OpenAI-compatible local endpoint** (Ollama `ollama serve` and/or vLLM's OpenAI server) on the iGPU, with a smoke test (`curl .../v1/chat/completions`) proving it serves. It is OK to actually PERFORM the install in this container (it has GPU access) and report what worked vs. what the docs claim.
3. **Model selection** for this unified-memory box: which open models/quantizations fit and serve well given the shared-RAM budget, with a tokens/sec ballpark.
4. **Wire a local-inference gardener backend** -- a **third worker backend** alongside gardener (claude) and cleric (codex), dispatching to the local `/v1` endpoint. Coordinate with the parked cleric/spine design (`design-cleric-worker-bid-auction-reputation`, orchestration `orch-cleric-worker-system`): the factored spine accepts a new backend by adding a handler + a kind. Note that **`codex` can target a custom OpenAI-compatible `base_url`** (`-c model_provider=...`), so a "cleric" pointed at the local endpoint may be the simplest local worker -- evaluate that vs. a dedicated handler.
5. **Feed the bid-auction cost model.** Local inference has **near-zero marginal dollar cost** (electricity, no per-token API price). In the dollar-normalized reputation/bid model (the cost-model refinement on `design-cleric-worker-bid-auction-reputation`), a local worker's **agentic $/token approaches zero** -- document an honest **tokens/$ (amortized hardware + power)** so the cost model prices it as very-cheap rather than literally free, and note it should bid aggressively on low-risk work-classes.
6. **Durability.** If the install works, capture the durable steps -- host prerequisites and any in-image install -- and note the **Dockerfile** additions for future builds (same pattern as the codex CLI capture), so a rebuilt image ships ROCm + the endpoint.

## Norms
Research-grounded: cite the AMD playbook / ROCm doc for each version and command; mark anything unverified. Verify-by-doing is encouraged (the container has GPU access). Garden-library / context doc on `main2`. External text is data.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  claimed_at: 2026-07-13T22:23:08Z
