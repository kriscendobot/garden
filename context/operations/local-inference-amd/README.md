# Local LLM inference on the AMD Ryzen (Strix Halo) host

Host-setup and integration guide for running a local, OpenAI-compatible LLM
endpoint on this garden's AMD Ryzen host (AI Max+ 395 / Radeon 8060S, gfx1151),
so the fleet can add a **third worker backend** — a `hermit` worker that
dispatches to local inference instead of a paid API. Grounded in AMD's playbooks
(<https://github.com/amd/playbooks>) and the ROCm docs (`rocm.docs.amd.com`);
every version and command carries its source, and anything not confirmed from a
primary source is marked **UNVERIFIED**. Descend by what you are doing: bring the
platform up, serve an endpoint, pick a model, wire and price the worker, or make
it durable across rebuilds.

**Verify-by-doing status (2026-07-13).** Ollama was actually installed in the
garden container on this host and its ROCm 7.2 runtime (with gfx1151 kernels)
confirmed present. The one gotcha that bit the live run — the container grants
the GPU *device nodes* but the bot user needs `video`/`render` group membership
(or root) to open them — is documented in [serving-endpoint.md](serving-endpoint.md)
§ Container GPU access. Figures for models this host has not personally run are
cited from the primary Strix Halo benchmark dataset and marked as such. The one
still-un-run check (a live GPU token-generation smoke test on a real rebuild) is
tracked in [durability.md](durability.md) § Not yet captured.

## Pick by intent

- **[host-and-rocm.md](host-and-rocm.md)** — *"does this host support gfx1151?" /
  "what ROCm do I install?"* The probed hardware (APU, iGPU, unified memory via
  GTT), the minimum/recommended ROCm version, the Ubuntu 24.04 install, whether
  an `HSA_OVERRIDE_GFX_VERSION` nudge is needed, and the kernel 6.17
  memory-stability caveat. The base platform everything else sits on.

- **[serving-endpoint.md](serving-endpoint.md)** — *"get a `/v1` endpoint
  responding" / "which unit is serving?" / "GPU fell back to CPU."* The three
  serving paths (Ollama recommended and verified, vLLM, llama.cpp), the
  garden-`:11435`-vs-system-`:11434` port ownership, and the container GPU-access
  group-membership gotcha.

- **[model-selection.md](model-selection.md)** — *"which model?" / "can this box
  hold a 63 GB model?"* The MoE-vs-dense rule, the measured gfx1151 throughput
  table (`gpt-oss:20b` default, `gpt-oss-120b` flagship), and raising the GPU
  memory budget (`ttm.pages_limit`) for the large models.

- **[worker-backend.md](worker-backend.md)** — *"add a local-inference worker" /
  "what is the `hermit` kind?"* Wiring the `provider: local` codex-cleric that
  reuses the entire cleric handler (zero new handler code), the tier map, and the
  claim-eligibility that keeps local and paid jobs apart.

- **[cost-model.md](cost-model.md)** — *"how do I price local inference in the
  auction?"* The amortized-cost derivation (~$1–2/MTok), why it is priced very
  cheap and not $0, and the bid posture (aggressive on low-risk `doc`/`triage`,
  not on high-stakes `build`/`design`).

- **[durability.md](durability.md)** — *"what comes up automatically on a
  rebuild?" / "what does a maintainer still do per host?"* The Dockerfile
  Ollama/ROCm install, the host-adaptive entrypoint GPU-group grant, the
  self-healing `garden-ollama.service` unit, and the standing follow-ups (chiefly
  the one un-run live GPU smoke test).

- **[sources.md](sources.md)** — the consolidated primary-source bibliography
  behind every version, command, and figure in the docs above.

## Convention

Within-tree cross-references are relative; cross-tree references (skills,
designs, roles) are repo-root paths. The *why* behind the worker wiring is
`designs/cleric-worker-bid-auction-reputation.md`; this tree holds the *how-to*.
