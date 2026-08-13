# Host and ROCm — the base platform for gfx1151 (Strix Halo)

Getting the base compute platform working on this specific AMD Ryzen host: the
probed hardware facts (APU, iGPU `gfx1151`, unified memory) and the ROCm stack
that drives it — minimum version, the Ubuntu 24.04 install, whether an
`HSA_OVERRIDE_GFX_VERSION` nudge is needed, and the kernel 6.17 memory-stability
caveat. Read this to answer "does this host support gfx1151, and what ROCm do I
install?" Standing up the `/v1` endpoint on top of this is
[serving-endpoint.md](serving-endpoint.md); raising the GPU memory budget for
large models is [model-selection.md](model-selection.md).

## The host, as probed

| Fact | Value | How probed |
| --- | --- | --- |
| APU | AMD Ryzen AI Max+ 395 w/ Radeon 8060S | `/proc/cpuinfo` |
| iGPU | Radeon 8060S, **gfx1151**, RDNA 3.5; PCI device `0x1586` | `lspci -d 1002:` → `Device 1586`; matches vLLM's `"0x1586": "AMD_Radeon_8060S"` |
| NPU | XDNA2 (not used for LLM serving here) | spec |
| System RAM | **125 GiB** unified | `free -h` |
| OS | Ubuntu 24.04.4 LTS | `/etc/os-release` |
| Kernel | 6.17.0-35-generic | `uname -r` |
| ROCm host-side | **absent** (`/opt/rocm` does not exist) | `ls /opt/rocm` |
| GPU device nodes in container | `/dev/kfd`, `/dev/dri/card1`, `/dev/dri/renderD128` all present | `ls -l` inside the container |
| Default VRAM carve-out | **512 MiB** (`mem_info_vram_total` = 536870912) | sysfs |
| Default GTT budget | **50 GiB** (`mem_info_gtt_total` = 53687091200) | sysfs |

**Unified memory.** The iGPU has no dedicated VRAM to speak of — a 512 MiB
BIOS carve-out — and instead maps system RAM through the **GTT** (Graphics
Translation Table), defaulting to ~50% of RAM (here ~50 GiB, raisable; see
§ Raising the GPU memory budget in [model-selection.md](model-selection.md)).
This is what lets large models fit: a 63 GB `gpt-oss-120b` loads into the same
DRAM the OS uses, at a bandwidth lower than a discrete card's but on a very
large pool.

## ROCm for gfx1151 — version, install, and whether an override is needed

### Minimum version

**gfx1151 stable Linux support begins at ROCm 7.0.2; current/recommended is
ROCm 7.2.x.**

- gfx1151 PyTorch **preview** first shipped in **ROCm 6.4.4**; **ROCm 7.0.2**
  (Oct 14 2025) is the first stable release explicitly naming gfx1150/gfx1151
  Linux support, per the AMD-maintainer thread
  (<https://github.com/ROCm/ROCm/issues/5339>).
- **Caveat — gfx1151 is absent from the canonical (Instinct-oriented)
  compatibility matrix** in every ROCm version, which is a documented source of
  confusion (<https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html>;
  issue #5339). Its support lives instead on the **"Use ROCm on Radeon and
  Ryzen"** shelf, which lists "Ryzen™ APUs (AI Max 300 Series …)" — the
  AI Max+ 395 is in that series
  (<https://rocm.docs.amd.com/projects/radeon/en/latest/docs/compatibility/native_linux/native_linux_compatibility.html>).
- AMD publishes a **dedicated Strix Halo system-optimization page**, confirming
  first-class attention to this APU
  (<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>).

### Ubuntu 24.04 install (system ROCm)

From the ROCm 7.2.4 Quick Start
(<https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html>):

```sh
wget https://repo.radeon.com/amdgpu-install/7.2.4/ubuntu/noble/amdgpu-install_7.2.4.70204-1_all.deb
sudo apt install ./amdgpu-install_7.2.4.70204-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms                       # SKIP on an in-tree driver — see below
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME           # REQUIRED — see § Container GPU access in serving-endpoint.md
sudo apt install rocm
```

- **Kernel 6.17 is supported**: ROCm 7.2.4 system-requirements lists Ubuntu
  24.04.4 kernels 6.8 [GA] and **6.17 [HWE]**
  (<https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>).
- **amdgpu-dkms is NOT required when using the kernel's in-tree amdgpu
  driver.** The installer's own `--no-dkms` option "skip[s] the installation of
  the kernel-mode driver"
  (<https://rocm.docs.amd.com/projects/install-on-linux/en/docs-6.4.0/install/install-methods/amdgpu-installer/amdgpu-installer-ubuntu.html>);
  a compute-only install is `amdgpu-install -y --usecase=rocm --no-dkms`.
  Prefer in-tree on 6.17 — there are reports of amdgpu-dkms failing to build
  against newer kernels (<https://github.com/ROCm/ROCm/issues/5110>). On this
  host the GPU nodes already exist inside the container, so the amdgpu **kernel
  driver is already loaded on the host** and DKMS should be skipped.

### HSA_OVERRIDE_GFX_VERSION

**Not needed on a current stack.** gfx1151 is a natively supported target once
ROCm ≥ 7.0.2 / a gfx1151-aware runtime is in play; the llama.cpp "known-good
Strix Halo stack" note states "HSA_OVERRIDE_GFX_VERSION: not required"
(<https://github.com/ggml-org/llama.cpp/discussions/20856>).

- If you must set it, the **exact-match nudge is `11.5.1`** (gfx1151's own
  version — tells an almost-aware ROCm to recognize the device), reported
  working in Ollama issue #14855 (<https://github.com/ollama/ollama/issues/14855>).
- **`11.0.0` is the legacy spoof** (pretend to be gfx1100/RDNA 3) used before
  runtimes shipped gfx1151 code objects — a hack, architecturally wrong since
  gfx1151 is RDNA 3.5 (<https://github.com/ollama/ollama/blob/main/docs/gpu.mdx>).
- iGPU gotcha: some tools drop integrated GPUs by default — Ollama needs
  **`OLLAMA_IGPU_ENABLE=1`** (<https://github.com/ollama/ollama/issues/16529>).

### Kernel 6.17 memory-stability caveat (real gotcha)

AMD's Strix Halo page states stable unified-memory behavior needs
**"Linux 6.18.4+ or Ubuntu 24.04 HWE 6.17.0-19.19~24.04.2+"**
(<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>);
a community toolbox README independently reports "kernels older than 6.18.4 have
a bug causing stability issues on gfx1151"
(<https://github.com/kyuz0/amd-strix-halo-toolboxes>). **This host is on
6.17.0-35**, which is past the `-19.19` HWE point release, so it should be on
the safe side — but confirm the exact HWE build before pushing large models,
and be ready to move to the 6.18 HWE if you see GTT/VRAM under-reporting or GPU
hangs.
