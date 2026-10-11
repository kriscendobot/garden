from_host: oros-studio-garden-ce242c49
from: gardener:oros-hardware-report-20261011
reply_to: oros-hardware-report-20261011
msg_key: msg-oros-hardware-report-20261011-029df33f7938
notice_count: 1
first_seen: 2026-10-11T07:35:31Z
last_seen: 2026-10-11T07:42:16Z
sent_at: 2026-10-11T07:42:16Z
---
# oros-studio-garden-ce242c49: hardware and capability report (2026-10-11 07:34Z)

Short answer: part of the gap is hardware. The biggest limit is how the hardware is exposed, not raw CPU. oros runs the garden inside Docker Desktop's Linux VM on an Apple Silicon Mac. The VM gets 12 cores and 15 GiB of RAM, and the whole garden tree, including every git repo, sits on a virtiofs share from macOS. Git-heavy work, which is most of what the fleet does, pays a large per-file cost there. The usual config problems (drain, stale deploy, workers down) are not present right now.

## Measured on oros (inside the garden container)
- CPU: aarch64, vendor Apple. The VM hides the model name. 12 cores, 1 thread per core, `nproc` = 12. No cgroup CPU cap shows inside the container; the cap is the VM's 12 vCPUs.
- Memory: 15 GiB total (MemTotal 16.35 GB), 2.7 GiB used, 12 GiB available (mostly page cache). Swap is 1 GiB, with 254 MiB in use. No cgroup memory cap; the cap is the VM size.
- Disk: the garden root, `worktrees/` and `scratch/` are all one **virtiofs** mount: 461 G total, 233 G used (51%). `/tmp` is tmpfs, 7.8 G, noexec. The VM disk `vda` (460 G) reports ROTA=1, but that is a virtio artifact. The backing storage is the Mac's internal SSD, which can't be checked from inside the VM.
- Filesystem cost: `git status` on this 1,430-file worktree took **1.41 s** wall time (0.07 s CPU). Nearly all of it is waiting on virtiofs metadata. On local NVMe it would be tens of ms.
- GPU/accelerator: none visible to the container (lspci shows no VGA/3D devices; no nvidia-smi or rocm-smi). The Mac's GPU/ANE is not passed through.
- OS: Ubuntu 24.04.4 LTS on kernel 7.0.12-linuxkit (Docker Desktop VM), aarch64.
- Load: 8.21 / 5.92 / 4.78 on 12 cores, so 0.68 / 0.49 / 0.40 per core. Pressure (PSI): CPU "some" avg60 6.9%; IO "full" avg60 1.1%; memory 0%. The top CPU consumers by command were git (several processes, up to 16%), then claude and find.
- Network: api.github.com round trip 0.175 s / 0.177 s / 0.170 s. Consistent and not a bottleneck.

## Garden state on oros
- Workers: the journal sets `monks: 8` for this host, and `config/worker-leveling` caps it at 8 monks / 0 clerics. All 8 `garden-monk@1..8` units are active/running; there are no cleric units.
- Drain: `not draining`.
- Deployed sha: `592f66b2a04` (feat(classify): strict mode). origin/main2 is `a4268c400d3`, exactly one commit ahead. The deploy is not stale in any meaningful way.
- Claude Code version: 2.1.296.
- Failed garden units: 0.

## Compared with the leader endolin-garden-ece02cb4
| | endolin (leader) | oros-studio |
|---|---|---|
| CPU | Ryzen AI Max+ 395, 32 threads | Apple Silicon, 12 vCPU (VM limit) |
| RAM | 125 GiB | 15 GiB VM + 1 GiB swap |
| Storage for the garden tree | 3.6 TB NVMe (native) | virtiofs share from macOS (VM boundary) |
| Workers configured (journal, today) | 1 monk + 1 cleric (cap 4/4) | 8 monks (cap 8/0) |

## Which differences could plausibly limit throughput
1. **Filesystem: most likely the dominant limit.** Every git operation on journal sync, worktree add, clone, rebase and fetch crosses the virtiofs boundary. Earlier oros incidents look like I/O, not CPU:
   - a full journal2 clone takes about 42 s against a 45 s bound;
   - `worktree add` is killed at the 120 s git bound;
   - pack bloat slowed leader checks to 57 s.

   The 1.4 s `git status` above shows the per-file cost. Each of the 8 workers runs its own worktree and journal syncs, so this cost multiplies. Endolin runs on native NVMe and doesn't pay it.
2. **Memory: a real ceiling, not hit right now.** 15 GiB has to hold 8 Claude Code processes plus whatever builds and tests the jobs run (yarn installs, node tests on endo). Pressure is 0% today with 12 GiB available, but a few concurrent heavy builds would push into the 1 GiB swap. Endolin has about 8x the headroom.
3. **CPU: a secondary limit.** 12 cores against 32 threads matters for parallel builds and tests, and when 8 workers all compile at once. Right now the load is about 0.5 per core and CPU pressure "some" is about 7%, so CPU isn't saturated. Apple cores are fast per thread, so single-job latency is probably comparable.
4. **Network: not a factor** (about 0.17 s to GitHub).
5. **GPU: not relevant.** Neither host's garden work uses an accelerator. oros exposes none.

## Configuration, not hardware
- Today oros shows no drain, a deploy one commit behind, all 8 workers up, and 0 failed units. When drain, a stale deploy or missing workers showed up before, the causes were software or ops, not hardware:
  - the deploy self-swap crash that left the host drained and frozen;
  - the stale Claude CLI kill wave;
  - a missing worker-leveling row that froze monk scaling.
- Credential and scope gaps, not hardware: the bot PAT can't write PRs on endojs or read checks, and there is no AWS on oros. Jobs that need these must route to endolin, which shifts throughput there whatever the hardware.
- The VM size is itself configuration. Docker Desktop's CPU and memory allocation is set on the Mac and may be lower than the Mac's physical capacity, which can't be seen from inside the VM.
- Worker count is configuration. oros runs 8 monks on 12 cores and 15 GiB, while endolin is configured for 1 monk + 1 cleric today. A per-host comparison needs to normalize for that.

## Suggested next steps (none taken; this job is read-only)
- On the Mac, check Docker Desktop's resource settings against the machine's physical cores and RAM, and raise the VM allocation if there is headroom.
- The biggest likely win: move git-heavy state (the `.garden-state` namespace clones, `scratch/` worktrees, maybe the bare clones under `worktrees/`) off the virtiofs bind mount onto a VM-local volume, or onto Docker Desktop's faster file-sharing backend. Re-measure `git status` and a journal clone afterwards.
- With 15 GiB, keep monks at or below about 8. Raising the count on this host is more likely to cause swapping than to add throughput.
