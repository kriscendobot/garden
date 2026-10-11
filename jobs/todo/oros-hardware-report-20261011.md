---
requires: host=oros-studio-garden-ce242c49
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 900
---
# Hardware and capability report for oros-studio-garden-ce242c49

Maintainer ask (kriskowal, liaison session 2026-10-11): we want to know whether the
performance gap between the endolin hosts and oros-studio is a hardware limit. This job is
pinned to oros-studio, so it runs ON that host. It is read-only: change nothing, install
nothing, and do not touch the journal beyond normal job completion.

## Collect (read-only commands, inside the garden container)
- CPU: `lscpu` (model, sockets, cores, threads, max MHz), `nproc`
- Memory: `free -h`, swap
- Disk: `df -h` for the garden root and the worktrees/tmp mounts, filesystem type, and
  whether root is NVMe/SSD/HDD (`lsblk -d -o NAME,ROTA,SIZE,MODEL`)
- GPU/accelerator, if any (`lspci | grep -iE 'vga|3d|display'`, `nvidia-smi` or `rocm-smi`
  when present)
- OS and kernel (`uname -a`, `/etc/os-release`), container runtime and any cgroup CPU or
  memory limits on the garden container (`cat /sys/fs/cgroup/cpu.max memory.max`)
- Load now: `uptime`, `nproc` vs load average; top few CPU consumers by command name only
- Network: a short latency check to github.com (`curl -s -o /dev/null -w '%{time_total}'
  https://api.github.com/zen`, three samples)
- Garden state on this host: worker counts configured vs active (`systemctl --user
  list-units 'garden-monk@*' 'garden-cleric@*'`), `scripts/jobs/drain-fleet.sh status`,
  deployed sha (`git -C "$GARDEN_ROOT" rev-parse HEAD`), `claude --version`, and the
  number of failed garden units.

Do not record hostnames of other machines, IP addresses, credentials, serial numbers,
MAC addresses, or usernames; the journal is public.

## Report
Compare against the leader endolin-garden-ece02cb4 (AMD Ryzen AI Max+ 395, 32 threads,
125 GiB RAM, 3.6 TB NVMe). State plainly which differences could plausibly limit job
throughput, and which observed symptoms (drain state, stale deploy, worker counts) are
configuration rather than hardware. Send the report as a maintainer message with
`scripts/jobs/message-user.sh` and put the same text in the job result.
