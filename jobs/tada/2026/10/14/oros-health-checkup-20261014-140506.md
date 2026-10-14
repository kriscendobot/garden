**oros-health-checkup-20261014-140506: oros-studio-garden-ce242c49 was degraded. It is repaired on the host, and the code fix is on main2 at `f3fa2078`.**

**Snapshot:**
- **Load and memory:** load about 2.5; 13 GiB of 15 GiB available.
- **Disk and inodes:** disk 6% used, inodes 1%.
- **Uptime:** 13 days, no reboot.
- **Deploy:** the host ran `460f0598`, which was origin/main2 at claim. Roll status is `deployed`, with 0 of 293 units failed.
- **Workers:** 7 monks running. No drain, derotation untouched.
- **Budget meter:** fresh (sampled 18:39Z, ok, 3% used).
- **State clones:** all at 49 packs or fewer, no temporary pack files.

**What was wrong:**
- **Root repo's packs piled up.** It had 59 packs over 1.4M objects, past git's auto-gc limit of 50. Fleet git runs `gc --auto` in the foreground on every non-fetch command, and the 120s git timeout killed that gc every time. So the packs never shrank, and every merge or commit in the root repo hit the timeout.
- **Journal keeper reported a false STALE.** Its fast-forward actually landed, but the command was then killed inside the auto-gc. From about 16:15Z the keeper reported STALE (95 commits behind), alerted once at the 2h threshold, and overran its 600s limit every tick.
- **The repo guard's own gc kept failing.** Its 420s gc budget had timed out on every attempt since at least 10-13 11:22Z.

**What I changed on the host:**
- Ran `root-repo-guard.sh` once with a 1800s gc budget. The gc took 8m12s (19:05 to 19:13Z) and cut the packs from 59 to 2.
- Re-ran the journal keeper. It fast-forwarded cleanly in about 30s, so the false STALE is cleared.
- Pruned 73 dead-pid repo-lock holder files.

**What I changed on main2 (`f3fa2078`):**
- `scripts/jobs/common.sh`: fleet git no longer auto-gcs the deployed root repo or its worktrees. `root-repo-guard.sh` already owns that repo's gc. Other repos keep the old behavior, because project bare clones have no separate gc owner.
- `root-repo-guard.sh`: gc budget raised from 420s to 900s. The guard's systemd unit timeout goes from 1800s to 2700s to cover the new worst case, and `context/operations/systemd-units.md` is updated to match.
- New test, `scripts/jobs/test/root-store-auto-gc-test.sh`: passes with the fix and fails without it. `root-repo-guard-test` passes 76/76.

The health note is on journal2 in `projects/garden/oros-health-log.md`.

**Needs attention, but nothing needs a person at the machine:**
- oros picks up `f3fa2078` through the normal rolling deploy. The new unit timeout applies after deploy re-renders the units. `systemctl` also warned that the keeper's unit file had changed on disk and needed a `daemon-reload`.
- Two test failures, both unrelated to this fix:
  - `repo-locks-test` fails with "CAS writer process" on unmodified HEAD, at least when run inside a monk.
  - `systemd-unit-doc-completeness-test` fails because the `garden-namespace-clone-maintenance` units are undocumented.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261014-140506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (4763736 cached reads)
- Output: 30384 tokens
- Cost: $2.4178591999999997
- Wall-clock: 1602s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
