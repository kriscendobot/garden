# Sources (primary)

The consolidated primary-source bibliography for the local-inference-AMD tree.
Every version, command, and throughput figure asserted in the sibling docs
([host-and-rocm.md](host-and-rocm.md), [serving-endpoint.md](serving-endpoint.md),
[model-selection.md](model-selection.md), [worker-backend.md](worker-backend.md),
[cost-model.md](cost-model.md), [durability.md](durability.md)) traces back to
one of these; anything not confirmed from a primary source is marked
**UNVERIFIED** at its point of use. Read this to check the ground truth behind a
claim, or to find the upstream doc when a version moves.

- ROCm compatibility matrix — <https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html>
- ROCm on Radeon/Ryzen (lists AI Max 300 series) — <https://rocm.docs.amd.com/projects/radeon/en/latest/docs/compatibility/native_linux/native_linux_compatibility.html>
- ROCm Strix Halo optimization — <https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>
- ROCm 7.2.4 quick-start install — <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html>
- ROCm system requirements (kernel 6.17 HWE) — <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>
- gfx1151 support timeline (ROCm 7.0.2) — <https://github.com/ROCm/ROCm/issues/5339>
- AMD playbooks: Ollama — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/ollama-getting-started/README.md>
- AMD playbooks: vLLM — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/vllm-inference/README.md>
- AMD playbooks: memory config (amd-ttm) — <https://github.com/amd/playbooks/blob/main/playbooks/dependencies/memoryconfig.md>
- AMD playbooks: llama.cpp RPC — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/clustering-rpc-server/README.md>
- Ollama GPU/Linux docs — <https://github.com/ollama/ollama/blob/main/docs/gpu.mdx>, <https://github.com/ollama/ollama/blob/main/docs/linux.mdx>
- vLLM ROCm install (gfx1151, ROCm 7.0.2+) — <https://github.com/vllm-project/vllm/blob/main/docs/getting_started/installation/gpu.rocm.inc.md>
- llama.cpp known-good Strix Halo stack — <https://github.com/ggml-org/llama.cpp/discussions/20856>
- Strix Halo benchmark dataset — <https://github.com/kyuz0/amd-strix-halo-toolboxes/blob/main/docs/results.json>
- amdgpu kernel module params (gttsize deprecated) — <https://www.kernel.org/doc/html/latest/gpu/amdgpu/module-parameters.html>
- GTT/TTM alignment issue — <https://github.com/ROCm/ROCm/issues/5595>
- Design: cleric worker / spine / bid-auction / reputation — [designs/cleric-worker-bid-auction-reputation.md](../../../designs/cleric-worker-bid-auction-reputation.md)
