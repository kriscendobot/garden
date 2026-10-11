# oros-studio-garden-ce242c49: hardware and capability report (2026-10-11 07:34Z)

The report below went to the maintainer inbox as message `msg-oros-hardware-report-20261011-029df33f7938`. Sending it took 6 tries because of journal push races. I changed nothing on the host, installed nothing and committed nothing.

**Short answer:** part of the gap is hardware, but the biggest limit is how the hardware is exposed, not raw CPU. oros runs the garden inside Docker Desktop's Linux VM on an Apple Silicon Mac. The VM gets 12 cores and 15 GiB of RAM. The whole garden tree, including every git repo, sits on a **virtiofs** share from macOS, and git-heavy work (most of what the fleet does) pays a large cost per file there. The usual config problems (drain, stale deploy, workers down) are not present right now.

## Measured on oros (inside the garden container)
- **CPU:** aarch64, vendor Apple; the VM hides the model name. 12 cores, 1 thread per core, `nproc` = 12. No cgroup CPU cap is visible; the limit is the VM's 12 vCPUs.
- **Memory:** 15 GiB total, 2.7 GiB used, 12 GiB available (mostly page cache). Swap is 1 GiB, with 254 MiB in use. No cgroup memory cap; the limit is the VM size.
- **Disk:**
  - The garden root, `worktrees/` and `scratch/` are all one virtiofs mount: 461 G, 51% used.
  - `/tmp` is tmpfs, 7.8 G, noexec.
  - The VM disk `vda` reports itself as rotating (ROTA=1), but that's a virtio artifact. The backing storage is the Mac's SSD, which can't be checked from inside the VM.
- **Filesystem cost:** `git status` on a 1,430-file worktree took **1.41 s** wall time but only 0.07 s of CPU, so nearly all of it is waiting on virtiofs. On local NVMe it would take tens of milliseconds.
- **GPU:** none visible to the container; no nvidia-smi or rocm-smi.
- **OS:** Ubuntu 24.04.4 LTS on kernel 7.0.12-linuxkit (Docker Desktop's VM).
- **Load:** 8.21 / 5.92 / 4.78 on 12 cores, about 0.4–0.7 per core.
  - Pressure: CPU "some" 6.9% (60 s average), I/O "full" 1.1%, memory 0%.
  - Top CPU users by command: git, then claude, then find.
- **Network:** round trip to api.github.com was 0.175 s, 0.177 s and 0.170 s. Not a factor.

## Garden state on oros
- **Workers:** 8 monks configured in the journal (cap 8 monks, 0 clerics), and all 8 `garden-monk@` units are running.
- **Drain:** not draining.
- **Deploy:** the deployed sha is `592f66b2a04`, exactly one commit behind origin/main2 (`a4268c400d3`), so the deploy isn't stale.
- **Claude Code:** 2.1.296.
- **Failed garden units:** 0.

## Compared with the leader endolin-garden-ece02cb4

| | endolin (leader) | oros-studio |
|---|---|---|
| CPU | Ryzen AI Max+ 395, 32 threads | Apple Silicon, 12 vCPU (VM limit) |
| RAM | 125 GiB | 15 GiB VM + 1 GiB swap |
| Storage for the garden tree | 3.6 TB NVMe, native | virtiofs share from macOS |
| Workers configured today | 1 monk + 1 cleric (cap 4/4) | 8 monks (cap 8/0) |

## Which differences could limit throughput
1. **Filesystem: probably the main limit.** Every journal sync, worktree add, clone and rebase crosses the virtiofs boundary.
   - Earlier oros incidents fit this, not a CPU limit: a journal clone takes about 42 s against a 45 s bound, `worktree add` gets killed at 120 s, and pack bloat slowed leader checks to 57 s.
   - Each of the 8 workers pays this cost on its own worktree and syncs. Endolin runs on native NVMe and doesn't pay it.
2. **Memory: a real ceiling, not hit today.** 15 GiB has to hold 8 Claude Code processes plus the builds and tests their jobs run. A few heavy builds at once would push into the 1 GiB swap. Endolin has about 8 times the room.
3. **CPU: secondary.** 12 cores against 32 threads matters when several workers build or test in parallel. The CPU isn't saturated now, and Apple cores are fast per thread.
4. **Network and GPU: not factors.**

## Configuration, not hardware
- Drain, stale deploys and missing workers aren't present today. When they happened before, the causes were software or ops:
  - the deploy self-swap crash that left the host drained;
  - the stale Claude CLI kill wave;
  - a missing worker-cap row that froze monk scaling.
- **Credential gaps:** the bot's GitHub token can't write PRs on endojs or read checks, and oros has no AWS. Those jobs route to endolin whatever the hardware.
- **VM size:** Docker Desktop's CPU and memory allocation is set on the Mac and may be lower than the machine's physical capacity, which isn't visible from inside the VM.
- **Worker counts:** oros runs 8 monks while endolin is set to 1 monk and 1 cleric today. A per-host throughput comparison needs to account for that.

## Suggested next steps (none taken; this job was read-only)
- On the Mac, compare Docker Desktop's resource settings with the machine's physical cores and RAM, and raise the VM allocation if there is room.
- **Likely biggest win:** move git-heavy state (the `.garden-state` namespace clones, `scratch/` worktrees, possibly the bare clones under `worktrees/`) off the virtiofs share onto a VM-local volume. Then re-measure `git status` and a journal clone.
- Keep oros at 8 monks or fewer with 15 GiB. More workers are more likely to cause swapping than to add throughput.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-hardware-report-20261011.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (407542 cached reads)
- Output: 8496 tokens
- Cost: $0.6199084
- Wall-clock: 805s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
