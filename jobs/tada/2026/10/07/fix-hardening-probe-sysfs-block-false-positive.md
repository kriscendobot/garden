I fixed the false positive in `scripts/check-container-hardening.sh`, and the fix is pushed to `main2` as commit `08691a025fa`. Run live in this container (endolin-garden2), the probe now passes all 7 checks and exits 0.

**Why the probe changed, not the launcher:** I don't think sysfs visibility is the exposure the design meant to close. `/sys/block` is read-only and lists only device names. Without a device node in `/dev` the bot user can't open or mount anything. The bot user also has no capabilities, so it can't create a device node (`mknod`), and the container's device controls deny access anyway. So masking `/sys/block` in the `garden` launcher isn't needed.

**What changed:**
- **Check 4 (block devices):** a new function `exposed_block_devices` decides the result.
  - Every block node in `/dev` (found with `find /dev -maxdepth 2 -type b`) is a finding.
  - A name from `lsblk -nro NAME` is a finding only if `/dev/<name>` or `/dev/mapper/<name>` is a real block node. This also catches a node deeper than the `/dev` scan reaches.
  - Names that `lsblk` reads from sysfs alone are no longer a finding. The pass message now gives their count for transparency.
- **Other checks:** check 5 (the mount test) still tries the first exposed node, or `/dev/sda1` if there is none. Checks 1–3 and 6–7 are unchanged.
- **Test hook:** a new `--block-devices-selftest <devroot>` option runs only this check, reading `lsblk` names from stdin.
- **Tests** (`tests/checks/test_container_hardening_probe.sh`): 31 pass, 0 fail.
  - **Covered:** a fake `/dev` with `lsblk` names `loop0 loop1 loop20 sda` and no block nodes comes back clean (the original false positive). An empty case also comes back clean. The test also confirms check 4 uses the new function.
  - **Skipped here:** the "exposed" cases need a real block node. The test points a symlink at one from the host's `/dev`, because creating a node needs privileges the test doesn't have. This container has no block nodes, so those cases were skipped, and the "exposed" path has not been run anywhere yet.
- **Docs** (`context/operations/harden-container.md`): the wording never said `lsblk` must be empty. I added a short paragraph under § Probe outcomes saying the check fails only on a reachable node, and that `lsblk` listing host devices from `/sys/block` is expected.

**Follow-ups:**
- Once this is deployed, the next timer run on each recreated host should write the hardened-verified marker and close the pending-recreate notice. My live run wrote its marker to a temporary path, so the real marker hasn't been written yet.
- Running the test on a machine that has block nodes in `/dev` would exercise the "exposed" cases.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-hardening-probe-sysfs-block-false-positive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (724253 cached reads)
- Output: 7477 tokens
- Cost: $0.7920226
- Wall-clock: 80s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
